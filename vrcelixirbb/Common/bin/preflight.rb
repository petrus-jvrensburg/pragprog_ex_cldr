# Script to check links in PML documents
#
#  ruby preflight book.xml
#
# URLs with the attribute assume-valid="yes" are not checked

require 'bundler/setup'
require 'ansi/code'
require_relative "./preflight/url_scanner.rb"
require_relative "./preflight/images.rb"
require_relative "./preflight/bookinfo.rb"

def ERROR(msg)
  puts ANSI.red{msg}
end

def INFO(msg)
  puts ANSI.green{msg}
end

def WARN(msg)
  puts ANSI.yellow{ ANSI.bold { msg }}
end

def ERROR_HEADER(msg)
  puts ANSI.red{ ANSI.underscore { msg.upcase }}
end

def WARN_HEADER(msg)
  puts ANSI.yellow { ANSI.underscore { msg.upcase }}
end

def error_list(heading, items)
  unless items.empty?
    puts
    ERROR_HEADER(heading)
    items.each do |item|
      ERROR("• #{item}")
    end
  end
end

def warning_list(heading, items)
  unless items.empty?
    WARN_HEADER(heading)
    items.each do |item|
      WARN("• #{item}")
    end
  end
end

def try_to_require(name)
  begin
    require(name)
  rescue  LoadError => e
    system("gem install #{name}")
  end
end

try_to_require 'ox'
try_to_require 'faraday'
begin
  require 'ox'
  require 'faraday'
rescue LoadError => e
  INFO(%{\n\n
    When I tried to run, I found I needed to install some
    support code. Unfortunately, that means you need to repeat
    the command you just ran (hint: try uparrow then enter)\n\n})
  exit 1
end


def usage
  File.read(__FILE__) =~ /((^\#.*\n)+)/
  puts $1.gsub(/^#/, '')
  exit 1
end

# Parses the document for all urls found within <url> tags, and
# all images in imagedata tags


class Extractor < ::Ox::Sax
  attr_reader :urls
  attr_reader :images

  def initialize
    @in_url = false
    @in_image = false
    @urls = []
    @images = []
  end

  def start_element(name)
    if !@in_url && name == :url
      @in_url = {}
    elsif !@in_image && name == :imagedata
      @in_image = {}
    end
  end

  def end_element(name)
    if @in_url && name == :url
      @urls << @in_url
      @in_url = false
    elsif @in_image
      @images << @in_image
      @in_image = false
    end
  end

  def text(txt)
    if @in_url
      @in_url["url"] = txt
    end
  end

  def attr(name, value)
    if @in_url
      if name == "assume_valid" && value == "yes"
        @in_url = false
        return
      end
      if name == "protocol"
        @in_url["protocol"] = value
      end
    end

    if @in_image
      @in_image[name] = value
    end
  end

end

metadata, errors = validate_bookinfo()
error_list("Errors in BOOKINFO", errors)

xml_file = ARGV.shift || usage()
extractor = Extractor.new
File.open(xml_file) do |file|
  Ox.sax_parse(extractor, file)
end

INFO "\nValidating URLs"

url_scanner = UrlScanner.new(extractor.urls)
url_scanner.validate_links

warning_list("Notes about URLs", url_scanner.notes)
error_list("Errors in URLs", url_scanner.errors)

if url_scanner.errors.empty? && url_scanner.notes.empty?
  puts "No issues with URLs"
end

INFO "\n\nValidating Images"
image_warnings, image_errors = validate_images(extractor.images, metadata["booktype"])

if image_errors.empty? && image_warnings.empty?
  INFO "No issues with images"
else
  warning_list("Notes about images", image_warnings)
  error_list("Errors in images", image_errors)
end

INFO "\n\nDone preflight checking\n\n"


