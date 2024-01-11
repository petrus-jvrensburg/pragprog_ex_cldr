# -*- coding: utf-8 -*-
#
# Args:
# title archive_name ignore_list...
#
# ignore_list should be relative to the "code" directory

#require 'rdoc/usage'
require 'fileutils'

def usage
  #RDoc::usage  ## doesn't work in 1.8.5
  puts File.open(__FILE__).readlines[0,5]
  exit
end


# Generate a header comment using a language-specific comment block style
class Header

  LANGUAGES = {}
  IGNORES   = {}

  def self.set_up(comment)
    @comment = comment.split(/\n/)

    [
     # Batch files
     ['', 'REM ', '', 'bat'],

     # C-like comments
     ['/***', ' * ', '***/', 'c', 'cc', 'cs', 'groovy',
                             'h', 'm', 'mm', 'java', 'js', 'javascript',
                             'scala'],

     # XML comments
     ['<!--', ' ! ', '-->', 'html', 'jnlp', 'jsp', 'rhtml', 'rss', 'xml', 'xsl'],

     # Scripting comments
     ['#---', '# ', '#---', 'properties', 'rb', 'pl', 'sh', 'ex', 'exs'],

     # Erlang comments
     ['%% ---', '%%  ', '%%---', 'erl'],

     # ini comments
     [';---', '; ', ';---', 'ini', 'nsi'],

     # clojure
     [ ';---', '; ', ';---', 'clj', 'cljs' ],

     # opencl
     [ '//---', '// ', '//---', 'cl' ],

    ].each do |leader, each_line, trailer, *languages|
      create(leader, each_line, trailer, *languages)
    end

    # no comments
    ignore(*%w{
       aif
       aiff
       bz2
       dump
       eot
       ftp
       gif
       gem
       gz
       gzip
       ico
       jar
       jpeg
       jpg
       m4a
       mp3
       nib
       ods
       ogg
       otf
       pcvd
       png
       raw
       strings
       sks
       swo
       tgz
       ttf
       woff
       woff2
       zip
       pbxproj
       xcworkspacedata
       xcscmblueprint
       xcuserstate
    })
  end

  # leader, each_line, and railer are the strings to start,
  # continue, and end the comment. They're collowed by a list
  # of applicable languages

  def self.create(leader, each_line, trailer, *languages)
    comments = leader + "\n"
    @comment.each do |line|
      comments << each_line << line << "\n"
    end
    comments << trailer << "\n"
    languages.each do |language|
      LANGUAGES[language] = comments
    end
  end

  def self.ignore(*languages)
    languages.each {|language| IGNORES[language] = true}
  end

  # Ugh—a nil return means you don't want to mess with the file
  # content (its binary), and a false return means we just don't know
  # how to comment it
  def self.find_comment(language)
    language = language.sub(/^\./, '')
    if language.length == 0 || IGNORES[language]
      nil
    else
      LANGUAGES[language] || false
    end
  end
end





#
# If these lines are first in the file, they need to stay there.
#
MAGIC_LINES = [
  "<\\?xml",
  "<!DOCTYPE",
  "\#!",
  "echo off"
  ]

MAGIC_RE = Regexp.new("^" + MAGIC_LINES.join("|"))

def is_magic?(line)
  MAGIC_RE =~ line
end



def get_initial_block(file_name)
  Header.find_comment(File.extname(file_name))
end


# Remove our special comments from files
FLAG = "\001\002"

def massage(content, do_callout = true)

  content.gsub!(/#\s*(START|END):.*/,         FLAG)
  content.gsub!(/%%\s*(START|END):.*/,        FLAG)
  content.gsub!(%r{//\s*(START|END):.*},      FLAG)
  content.gsub!(/<!--\s*(START|END):.*/,      FLAG)
  content.gsub!(/;\s*(START|END):.*/,         FLAG)
  content.gsub!(/\"\/\/\":\s*\"(START|END):.*/, FLAG)    # Support comments in JSON like "//": "START:"
  content.gsub!(%r{\{/\*\s*(START|END):.*?\*/\}}, FLAG)  # JSX is special. {/* this is a jsx comment */}
  content.gsub!(%r{/\*\s*(START|END):.*?\*/}, FLAG)
  content.gsub!(%r{//\s*(START|END):.*},      FLAG)
  content.gsub!(/#\s*<label id=.*?>/,         FLAG)
  content.gsub!(/;\s*<label id=.*?>/,         FLAG)
  content.gsub!(/#\s*<wtf.*<\/wtf>/,          FLAG)
  content.gsub!(/<!--\s*<label.*?-->/,        FLAG)
  content.gsub!(/<!--\s*<wtf.*?-->/,          FLAG)
  content.gsub!(%r{/\*\s*<label.*?>.*?\*/},   FLAG)
  content.gsub!(%r{//\s*<label.*?>.*},        FLAG)
  content.gsub!(%r{/\*\s*<wtf.*?\*/},         FLAG)
  content.gsub!(%r{//\s*<wtf.*</wtf>},        FLAG)
  content.gsub!(%r{</?code:bold>},            FLAG)
  content.gsub!(%r{</?literal:[^>]*?>},       FLAG)

  # if removing special markup leaves a blank line, remove that line,
  # too
  content.gsub!(/^[ \t]*#{FLAG}[ \t]*\n/o, '')
  content.gsub!(/#{FLAG}/o, '')

  # Remove start_highlight and end_highlight embedded in an HTML tag.
  # This is a hack for React JSX where we have to embed code like this:
  #
  # <div/* START_HIGHLIGHT */>
  #
  # </div/* END_HIGHLIGHT */>
  #
  # So remove the markup like that but leave the line alone.
  content.gsub!(/\s*\/\*\s*START_HIGHLIGHT\s*\*\//, '')
  content.gsub!(/\s*\/\*\s*END_HIGHLIGHT\s*\*\//, '')

  # Remove the rest of the highlighting - remove newlines
  content.gsub!(/.*START_HIGHLIGHT.*\n/, '')
  content.gsub!(/.*END_HIGHLIGHT.*\n/, '')

  # remove callout markup
  if do_callout
    callout = 0
    content.gsub!(/<callout.*?>/) { callout += 1; "(#{callout})" }
  end

  content

end

# Copy the input file to the output directory, inserting
# the copyright block (after the magic first line if there
# is one).

def copy_file(input_file, output_file)
  comment = get_initial_block(input_file)

  # Binary file?
  if comment.nil?
    FileUtils::cp(input_file, output_file)
    return
  end

  File.open(output_file, "w") do |op|
    content = File.read(input_file)
    break if content.nil?

    content = massage(content)  # get rid of our special markup

    # Now add a comment block at the top if we know how
    if comment
      if content =~ /\A(.*)/
        line = $1

        if is_magic?(line)
          if line =~ /DOCTYPE/
            loop do
              op.puts line
              break if line =~ />/
              content.sub!(/\A.*\n/, '')
              break unless content =~ /\A(.*)/
              line = $1
            end
          else
            op.puts line
          end
          content.sub!(/\A.*\n/, '')
        end
        op.puts(comment)
      end
    end
    op.write(content)
  end
  File.chmod(File.stat(input_file).mode, output_file)

rescue ArgumentError => e

  if e.message =~ /invalid byte sequence/
    FileUtils::cp(input_file, output_file)
  else
    raise
  end

rescue Exception => e

  STDERR.puts "\n\n>>>>>>> In #{input_file}"

  raise


end


def copy_tree(relative_path, output_dir, ignore_regexp)
  Dir.glob(File.join(relative_path, "*"),File::FNM_DOTMATCH).each do |name|

    fn = File.basename(name)
    case
    when fn == "." || fn == ".." || fn == ".svn" || fn == "CVS"
      next

    when ignore_regexp =~ name || name =~ /~$/ || name =~ /^#/
      next

    when ignore_regexp && ignore_regexp =~ name
      next

    when File.directory?(name)
      puts name
      Dir.mkdir(File.join(output_dir, name))
      copy_tree(name, output_dir, ignore_regexp)

    else
      copy_file(name, File.join(output_dir, name))
    end
  end

end


def safe_system(cmd)
  unless system(cmd)
    fail "#{cmd} failed"
  end
end

if __FILE__ == $0

  title = ARGV.shift  || usage
  archive_name = ARGV.shift || usage

  ignore_regexp = nil

  unless ARGV.empty?
    ignore_pattern = ARGV.shift
    if ignore_pattern && ignore_pattern.strip != ''
      ignore_regexp = Regexp.new(ignore_pattern)
    end
  end


  Header.set_up(
    %{Excerpted from "#{title}",
published by The Pragmatic Bookshelf.
Copyrights apply to this code. It may not be used to create training material,
courses, books, articles, and the like. Contact us if you are in doubt.
We make no guarantees that this code is fit for any purpose.
Visit https://pragprog.com/titles/#{archive_name} for more book information.
})


  ##
  # Create an output directory which parallels the code directory
  #

  FileUtils::rm_rf "tmp_code"
  Dir.mkdir("tmp_code") unless File.exists?("tmp_code")

  relative_output_dir = "tmp_code/code"

  output_dir = File.expand_path(relative_output_dir)

  fail "Output #{output_dir} already exists" if File.exist?(output_dir)

  Dir.mkdir(output_dir)

  Dir.chdir("code") {  copy_tree(".", output_dir, ignore_regexp) }

  archive = archive_name + "-code"

  Dir.chdir("tmp_code") do
    File.unlink("code/README") rescue 1;
    tar_file = "../" + archive + ".tgz"
    puts "Creating #{tar_file}"
    safe_system("tar czf #{tar_file} code")

    zip_file = "../" + archive + ".zip"
    puts "Creating #{zip_file}"
    File.unlink(zip_file) if File.exist?(zip_file)
    safe_system("zip -qr #{zip_file} code")
  end
  #FileUtils::rm_rf(output_dir)
else
  Header.set_up("Here is\nthe special comment\n")
end
