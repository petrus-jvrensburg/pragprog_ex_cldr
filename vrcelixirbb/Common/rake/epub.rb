# -*- coding: utf-8 -*-

# These are the tasks specific to epubs

require 'open3'


desc "Build the book in epub format"
task :epub => "book.epub" do
  puts_in_bold "\nThe book is in book.epub\n"
end



file LOCAL_EPUB_XSL
file EPUB_XSL

namespace :dt do
  task :xml do
    params = { :year => Time.now.year }
    Dir.chdir EPUB_DIR do
      xslt('ppb2epub.xsl', File.join('../', "book.xml"), params)
    end
  end

  task :split do
    Dir.chdir EPUB_DIR do
      sh %{#{JRUBY} -I "#{NOKOGIRI_DIR}" "#{SPLIT_SINGLE_HTML}"}
    end
  end
end

rule ".epub" => [ '.xml',  'bib_extract.xml', LOCAL_EPUB_XSL, EPUB_XSL ] do |t| #, :extra_images ] do |t|
  tidy_ebook_directory(EPUB_DIR, EPUB_TEMPLATE_DIR, true)

  target = File.expand_path(t.name)

  params = { year: Time.now.year, bookcode: BOOK_CODE }
  uncomment = []

  if defined?(EXTRA_FONTS) && EXTRA_FONTS
    EXTRA_FONTS.each do |fonts|
      case fonts.to_s
      when "japanese"
        cp File.join(FONTS_DIR,"mplus-1c-regular.ttf"), File.join(EPUB_DIR,"fonts")
        params['cjk'] = 'yes'
        uncomment << "japanese"
      when "unicode_symbols"
        cp File.join(FONTS_DIR,"Quivira.ttf"), File.join(EPUB_DIR,"fonts")
        params['unicode'] = 'yes'
        uncomment << "unicode"
      end
    end
  end

  update_css(uncomment) unless uncomment.empty?

  if defined?(FORCE_JPG_IMAGES) && FORCE_JPG_IMAGES
    params['force.jpg.images'] = 1
  end

  params['dtm.modified'] = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S%:z")

  Dir.chdir EPUB_DIR do
    xslt('ppb2epub.xsl', File.join('../', t.source), params)
  end

  convert_images(EPUB_DIR, "epub-xl")

  Dir.glob("#{EPUB_DIR}/images/_pragprog/*.svg").each do |f|
    puts f
    File.delete(f)
  end

  rm_f target
  Dir.chdir EPUB_DIR do
    sh %{#{JRUBY} -I "#{NOKOGIRI_DIR}" "#{SPLIT_SINGLE_HTML}"}
    create_epub_zip(target)
  end

  html_contents = File.read("#{EPUB_DIR}/book.html")
  if (html_contents =~ /pragprog-fail/)
    raise "See messages above for unsupported tag names."
  end


  puts_in_bold "Validating..."
  sh "java -jar #{EPUBCHECK_JAR} #{target}" do |ok, res|
    if !ok
       puts_in_bold "Check validation failures with Dave"
       abort "Validation failed"
    end
  end
end


task :epub_tidy do
  files = FileList.new(*%w{
        image_list book.epub book.cited-xml
        book.xml-mobi book.cited-xml-mobi book.mobi
  })

  files.add(FileList.new("*.xml").ext('tex'))
  files = files.existing
  rm(files, :force => true) unless files.empty?
  [ EPUB_DIR, HTML_DIR , MOBI_DIR, "epub_images" ].each do |dir|
    rm_rf(dir) if File.directory?(dir)
  end
end



desc "Create epub extracts"
task "epub_extracts" => [ 'book.xml',  'bib_extract.xml', LOCAL_EPUB_XSL, EPUB_XSL ] do |t|

  # creates book.html...
  xslt('ppb2epub.xsl', "book.xml", :year => Time.now.year, :extracts => "yes")

  # Fix some strange xalan problem with the doctype
  book = File.read("book.html")
  File.open("book.html", "w") {|f| f.puts book.sub(/<!DOCTYPE.*\n/, '')}

  # For historical reasons...
  mv "../image_list", "."

  # Now create the extracts
  xslt(CREATE_EXTRACT_EPUBS, "book.html")

  # For each extract, create the corresponding epub
  Dir.glob("extract-*.html").each do |extract_html|
    target = File.expand_path(extract_html.sub(/\.html$/, '.epub'))

    puts_in_bold "Building #{target}"

    tidy_ebook_directory(EPUB_DIR, EPUB_TEMPLATE_DIR, true)
    convert_images(EPUB_DIR, "epub-xl")

    # find the extract name
    content = File.read(extract_html, 4096)
    extract_name = "extract"
    if content =~ /<meta name="extract-name" content="(.*?)"/
      extract_name = $1
    end
    mv extract_html, File.join(EPUB_DIR, "book.html")
    cp "content.opf", EPUB_DIR
    cp "toc.ncx", EPUB_DIR
    rm_f target

    Dir.chdir EPUB_DIR do
      opf = File.read("content.opf")
      opf.sub!(%r{<\/dc:title>}, " [#{extract_name}]</dc:title>")
      File.open("content.opf", "w") {|f| f.puts opf}

      sh %{#{JRUBY} -I "#{NOKOGIRI_DIR}" "#{SPLIT_SINGLE_HTML}"}
      create_epub_zip(target)
    end
    validate_epub(target)
  end

  exit

##  convert_mages(EPUB_DIR, "epub-xl")
#  rm_f target
end

task :epub_validate do
  validate_epub("book.epub")
end

def validate_epub(target)
  puts_in_bold "Validating..."
  sh "java -jar #{EPUBCHECK_JAR} #{target}"  do |ok, res|
    puts_in_bold "Check validation failures with David"
  end
end

def copy_output_stream(stream, prefix = "")
  while line = stream.gets
    puts "#{prefix}#{line}"
  end
end

def create_epub_zip(target)
  files = Dir["**/**"]
  files.delete("book.html")
  files.delete("xslt-output.log")
  files.delete("mimetype")
  files.unshift "mimetype"
  cmd = %{zip -@rX9 "#{target}"}

  puts_in_bold(cmd)
  Open3.popen3(cmd) do |stdin, stdout, stderr|
    t1 = Thread.new { copy_output_stream(stdout, "") }
    t2 = Thread.new { copy_output_stream(stderr, "ERROR: ") }
    files.each {|file_name| stdin.puts file_name }
    stdin.close
    t1.join
    t2.join
  end

  status = $?

  if defined?(Process::WaitThread)
    status = $?.value
  end

  fail "Could not zip contents" unless status.success?
end

def update_css(uncomment)
  css_file = File.join(EPUB_DIR, "css/bookshelf.css")
  css = File.read(css_file)
  uncomment.each do |line_type|
    pattern = %r{^/?\*\*\* #{line_type}.*?\*\*\*/?}m
    css.gsub(pattern, '')
  end
  File.open(css_file, "w") {|f| f.puts css}
end
