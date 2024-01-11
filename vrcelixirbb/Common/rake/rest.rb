# -*- coding: utf-8 -*-


# ------------------------------------------------
desc "Build the HTML version of the book"
# ------------------------------------------------
task "book.html" => "html-book/book.html"

file "html-book/book.html" => [ "book.xml", :tidy_html, HTML_XSL, LOCAL_HTML_XSL] do
  Dir.chdir HTML_DIR do
    xslt("ppb2epub.xsl", '../book.xml', :year => Time.now.year)
  end
  convert_images(HTML_DIR, "html")
  puts "\n\nResult is in html-book/book.html"
end
file HTML_XSL
file LOCAL_HTML_XSL

task :tidy_html do
  tidy_ebook_directory(HTML_DIR, HTML_TEMPLATE_DIR)
end

def concat_javascripts(scripts, destination)
  contents = scripts.map {|name| File.read(name) }
  File.open(destination, "w") {|op| op.puts contents }
end

def tidy_ebook_directory(dirname, template, need_extras=false)
  rm_rf dirname
  mkdir dirname
  clone_directory template, dirname
  if need_extras
    if defined?(EXTRA_STYLESHEET)
      cp EXTRA_STYLESHEET, File.join(dirname, "css/book_local.css")
    end
    if defined?(EXTRA_JAVASCRIPT)
      concat_javascripts(EXTRA_JAVASCRIPT, File.join(dirname, "scripts/book_local.js"))
    end
  end

  Dir["#{dirname}/**/.svn"].each do |svn_dir|
    rm_rf(svn_dir, :verbose => false) if File.directory?(svn_dir)
  end
end






# Create a cover. We require the fire images/cover.eps to be present.
def create_cover(dest_dir, profile_name)
  unless File.exist?("images/cover.jpg")
    puts "\n\nThe ebooks require that the book's cover image exists in the file"
    puts "images/cover.jpg\n\n "
    exit
  end
  sh %{convert images/cover.jpg -colorspace RGB -depth 8  -resample 100x100 -units PixelsPerInch -alpha Off -background white -flatten "#{File.join(dest_dir, "images", "cover.jpg")}"}
end


# -------------------------------------------------------------------
#
# Helpers

def convert_images(dest_dir, profile_name)
  create_cover(dest_dir, profile_name)
  convert_images_except_cover(dest_dir, profile_name)
end

def convert_images_except_cover(dest_dir, profile_name)
  if File.exist?("image_list")
    puts "Converting images..."
    ruby %{"#{CONVERT_IMAGES}" "#{dest_dir}" #{profile_name} image_list}
  end
end

# We could use nokogiri, but for now...
def get_title_from(source)
  content = IO.read(source, 4096)
  if content =~ %r{<booktitle>(.*?)</booktitle>}m
    title = $1.strip
    fail "Title contains markup--call Dave" if title =~ /[<&]/
    title
  else
    fail "Couldn't find <booktitle> in first 4k of #{source}"
  end
end
