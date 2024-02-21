# encoding: utf-8
#
# Read a file replacing <pml:include file="xx"/> with the
# contents of xx.pml, and replace <pml:ignore file="xx"/>
# with nothing

######################################################################
######################################################################

require "stringio"
require "yaml"

BASE_DIR = Rake.original_dir

class Includer < Preprocessor

  # Check that the case of the name of the file in the file system
  # actually matches the case requested. This needn't be the case on
  # OSX with regular File.exist
  def case_sensitive_file_exist?(path)
    return nil unless File.exist?(path)

    # it exists. is it the right case
    dir, name = File.split(path)
    path = File.join(dir, name)
    lc_name = name.downcase

    Dir.glob("#{File.join(dir, "*")}").each do |entry|
      entry_name = File.basename(entry)
      return true if name == entry_name

      if entry_name.downcase == lc_name
        fatal_error(
          "You're looking for a file called\n\t\t'#{name}'\n" +
          "I found one called\n\t\t'#{entry_name}'\n" +
          "(notice that the case is different.)\n" +
          "Although this operating system supports case case-insensitive\n" +
          "file names, others don't. Please fix the pml:include"
        )
      end
    end
  end

  ######################################################################

  def missing_file(pml)
    fatal_error("Cannot file find '#{pml}'")
  end

  ######################################################################

  # def contents_of(basename)

  #   STDERR.puts "Including:     #{pml}"
  #   content = File.read(pml).
  #     sub(/\A\357\273\277/, '').    # remove any BOM
  #     sub(%r{<\?xml.*?>}, '').
  #     sub(%r{<!DOCTYPE[^>]*[ \t\r\n]+\[.*?\]>}m, '').
  #     sub(%r{<!DOCTYPE.*?>}m, '')
  #   fail content if content =~ /DOCTYPE/
  #   process_includes(content)
  # end

  def full_with_extension_given(filename)
    fullname = File.expand_path(filename, BASE_DIR)
    missing_file(filename) unless case_sensitive_file_exist?(fullname)
    [ fullname, filename =~ /\.md$/i ]
  end

  def try_adding_extension(basename, ext, is_markdown)
    fullname = File.expand_path(basename + ext, BASE_DIR)
    if case_sensitive_file_exist?(fullname)
      [ fullname, is_markdown ]
    else
      false
    end
  end

  def find_markup_for(filename)
    markdown = false
    markup = filename
    if filename =~ /\.\w+$/
      full_with_extension_given(filename)
    else
      try_adding_extension(filename, ".md", true) || try_adding_extension(filename, ".pml", false) || missing_file(filename)
    end
  end

  def include(file, record_location = true)
    log file

    markup_file, is_markdown = find_markup_for(file)

    content = File.readlines(markup_file)

    line_no = 0
    line = nil

    # strip off DOCTYPE
    until content.empty?
      line = content.shift
      line_no += 1
      break unless line =~ /(<\?xml)|(<!DOCTYPE)|(-*- xml -*-)/
    end

    content.unshift(line)

    if is_markdown 
      content.unshift("<markdown>")
      content.push("</markdown>")
    end

    mark_file_and_line_number(markup_file, line_no) if record_location

    until content.empty?
      line = content.shift
      handle(line)
    end
   
  end

  def handle(line)
    case line
    when %r{<pml[-:]ignore\s+file="(.*?)"\s*/>}
      # nothing

    when %r{<pml[-:]include\s+file="(.*?)"\s*record-location="no"/>}
      include($1.dup, false)
    when %r{<pml[-:]include\s+file="(.*?)"\s*/>}
      include($1.dup)
    when /pml:replace-with-include/
      puts line.sub(/pml:replace-with-include/, "pml:include")
    else
      puts(line)
    end
  end

  ######################################################################

  def process(*)
    seen_doctype = false

    while line = gets
      if !seen_doctype && (line =~ %r{<!DOCTYPE.*local/xml/markup\.dtd}) # only match the first DOCTYPE
        handle(line.sub(%r{local/xml/markup\.dtd}, File.join(BOOK_DIR, "local/xml/markup.dtd")))
        seen_doctype = true
        mark_line_number
      else
        handle(line)
      end
    end


    # while line = gets
    #   handle(line)
    # end
  end
end
