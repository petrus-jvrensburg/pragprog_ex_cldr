# encoding: utf-8


# Check that we're running the PragProg jruby, and not some system
# ruby

require 'rbconfig'

if !defined?(RbConfig)
  RbConfig = Config
end

bin_path = RbConfig::CONFIG['bindir']
unless bin_path =~/Common/i && bin_path =~ /ThirdPartyTools/i
  puts "Switching to the PragProg Ruby…"
  exec "./rake", *ARGV
  fail "never get here"
end

if RUBY_VERSION < "1.9"

  def require_relative(relative_feature)
    c = caller.first
    fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
    file = $`
    if /\A\((.*)\)/ =~ file # eval, etc.
      raise LoadError, "require_relative is called in #{$1}"
    end
    absolute = File.expand_path(relative_feature, File.dirname(file))
    require absolute
  end

end

# Maybe update ourselves if we find that PerBook is symlinked.
last_updated = ".last_updated"

if File.symlink?("../PerBook")
  unless File.exist?(last_updated) && File.mtime(last_updated) > Time.now - 24*60*60
    Dir.chdir("../PerBook") do
      puts("Updating shared files…")
      sh("svn up")
    end
    touch(last_updated)
  end
end


# This is added to by individual modules

LOCAL_TIDY_LIST = []

$: << File.expand_path(File.dirname(__FILE__))

require 'config'

# We keep the epub stuff in a common, shared, tree. This enables us to alter
# it even after a print book is frozen. Unfortunately, that makes
# the rake file configuration a tad messy

$: << File.join(COMMON, 'rake')
$: << PREPROCESSORS
$: << NOKOGIRI_DIR
$: << CODERAY_DIR

require 'options'
require 'bib'
require 'pdf'
require 'preprocessors'
require 'filters'
require 'dumper'
#require 'stats'
require 'common'
require 'yaml_to_pml.rb'
require 'includer'

Preprocessor.add_internal('includer', "Includer")

if defined?(USE_PMLCODE)
  Preprocessor.add_final(PML_CODE,'PmlCode')
else
  Preprocessor.add_final(ROUGE_CODE, 'RougeCode')
end

Preprocessor.add_final('interact', 'Interact')
Preprocessor.add_final(BUILD_INDEX, 'BuildIndex')


require 'helpers'


# ==========================================
desc "Create a fresh screen version of the book"
# ==========================================
task :default => [ :clean, :epub ]


# ==========================================
desc "Total clean up of work products"
# ==========================================
task :clean => :tidy do
  files = FileList.new('*.pdf').existing
  rm(files, :force => true) unless files.empty?
end


task :local_tidy do
  rm(FileList.new(LOCAL_TIDY_LIST), :force => true) unless LOCAL_TIDY_LIST.empty?
end

# =====================================================================
author_book_targets = AUTHOR_BOOK_FORMATS.map {|target| "#{NAME}_#{target}"}
desc "Create a book for authors from the continuous build system"
# =====================================================================
task :author_book => author_book_targets.push("copy_log_file")


AUTHOR_BOOK_FORMATS.each do |target|
  ab_name ="#{NAME}_#{target}"
  desc "Copy #{target} to the author build web site (use rake author_book to invoke this)"
  task ab_name => target do |t|
    if `uname -a` !~ /Linux/
      dest = "pragprog@authors.pragprog.com:domains/authors.pragprog.com/public_html/build/#{NAME}"
      puts_in_bold "scp '#{target}' '#{dest}/#{t.name}'"
      safe_sh "scp '#{target}' '#{dest}/#{t.name}'"
    end
  end
end

task :copy_log_file do
  if `uname -a` !~ /Linux/
    dest = "pragprog@authors.pragprog.com:domains/authors.pragprog.com/public_html/build/#{NAME}"
    puts_in_bold("scp book.log #{dest}/log.txt")
    safe_sh "scp book.log #{dest}/log.txt"
  end
end

# ================================================
desc "Check the images, URLs, and XML structure"
# ================================================
task :new_preflight => "book.xml" do
  ruby "-KU -J-Djavax.net.ssl.trustStore=NONE #{File.join(COMMON, 'bin', 'preflight.rb')} book.xml"
  puts_in_bold "\n\nChecking document structure"
  xslt("preflight_checker.xsl", "book.xml")
end



# ================================================
desc "Do a simple sanity check on the xml"
# ================================================
task :preflight => [ "book.xml", :check_urls, :check_images ] do

  puts_in_bold "\n\nChecking document"
  xslt("preflight_checker.xsl", "book.xml")
end

# ================================================
desc "Validate images"
# ================================================
task :check_images => "book.xml" do
  puts_in_bold "\nChecking images"
  Dir.chdir("images") do
    ruby PREFLIGHT_IMAGES
  end
end

# ================================================
desc "Validate that URLs in a document point somewhere valid"
# ================================================
task :check_urls => "book.xml" do
  puts_in_bold "\nChecking URLS"
  # no need to use JRuby here
  system("ruby #{CHECK_URLS} book.xml")
end

# ================================================
# = Rules (such as 'how to convert .pml to .xml') =
# ================================================

rule ".xml" => [".pml" ] do |t|  #  , *Preprocessors::dependencies ] do |t|
  Preprocessor.preprocess(t.source, t.name)
  puts_in_bold "Validating #{t.name}"
  cmd = %{java -cp "#{VALIDATOR_CLASSPATH}" PMLValidator #{t.name}}
  safe_sh(cmd, err_ok: true) do
    puts_in_bold("\nBuild failed…\n\n")
    exit(1)
  end
end

# book.xml has an additonal dependency on all pml files.
if File.exist?("book.yml")
  file "book.pml" => "book.yml" do
    create_book_pml_from_yaml("book.yml")
  end
end

file "book.pml" => FileList['*.pml'].exclude("book.pml")




# =============================
# = Generate ancilliary files =
# =============================

desc "Create a contents listing in Textfile format, suitable for pasting into PIP"
task :toc => "book.xml" do
  xslt("ppb2toc.xsl", "book.xml", "book-code" => BOOK_CODE, "level" => ENV["LEVEL"] || "1")
end


# =================================
# = Uploading and publishing code =
# =================================

namespace "code" do
  desc "Make the downloadable code archives"
  task :publish do
    safe_sh "#{JRUBY} #{PUBLISH_CODE} '#{TITLE.gsub(/'/, %{''})}' #{BOOK_CODE} #{CODE_IGNORE_LIST}"
  end

  desc "Upload the code archives"
  task :upload do
    safe_sh "#{JRUBY} #{UPLOAD_CODE} #{BOOK_CODE} #{PP_SITE_DIR}"
  end
end

# =================
# Creating Extracts
# =================


namespace "extracts" do

  # ==========================================
  desc "Upload extracts to media.pragprog.com"
  # ==========================================
  task "upload" do
    Dir.chdir HTML_DIR do
      safe_sh "#{JRUBY} #{UPLOAD_EXTRACTS} #{BOOK_CODE} #{PP_SITE_DIR}"
      upload_cmd = %{ssh prod 'cd apps/store/current && } +
                     %{RAILS_ENV=production script/runner "CmdLine::UpdateToc.run(%{#{BOOK_CODE}})"'}
      xslt("ppb2toc.xsl", "../book.cited-xml", "book-code" => BOOK_CODE, :pipe => upload_cmd)
    end
  end

end


# ==================
# Remove Markdown
# ==================

desc "Remove Markdown from a .pml file"
task "demarkify" do
  file = ENV['PML'] or fail("Missing PML=<filename>")
  fail "PML=xxx should be a .pml file" unless File.extname(file) == ".pml"
  old_file = file.sub(/pml$/, 'old_pml')
  FileUtils.cp file, old_file, :verbose => true

  Preprocessor.remove_all
  Preprocessor.add_internal('includer', "Includer")
  Preprocessor.add_internal("markdown", "Markdown")
  Preprocessor.preprocess(old_file, file)
  puts "\n\nMarkdown in #{file} has been converted to pure PML"
  puts "The previous version of #{file} is in #{old_file}"
end


# Not documented
task "remove-index" do
  list = if ENV["NAME"]
           list = FileList.new(ENV["NAME"])
         else
           FileList.new("*.pml", "*.md")
         end

  list.to_a.each do |file|
    remove_index_from(file)
  end
end


def remove_index_from(file)
  backup = file + ".backup"
  FileUtils.mv file, backup
  xslt(REMOVE_INDEX_XSL, backup, to: file)
  puts file
end
