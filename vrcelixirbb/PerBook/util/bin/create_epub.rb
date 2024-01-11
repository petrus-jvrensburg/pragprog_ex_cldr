require 'fileutils'
require 'rubygems'

#gem 'builder'
require 'builder'

class EPub

  WDIR_NAME = "tmp_epub"
  METADIR_NAME = File.join(WDIR_NAME, "META-INF")
  IMAGEDIR_NAME = File.join(WDIR_NAME, "images")

  def create_working_directory
    delete_working_directory
    Dir.mkdir WDIR_NAME
    Dir.mkdir METADIR_NAME
    Dir.mkdir IMAGEDIR_NAME
  end

  def create_container_xml
    xml = ::Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    xml.container(:version =>"1.0", :xmlns => "urn:oasis:names:tc:opendocument:xmlns:container") do
      xml.rootfiles do
        xml.rootfile "full-path" => "content.opf", "media-type" => "application/oebps-package+xml"
      end
    end
    File.open(File.join(METADIR_NAME, "container.xml"), "w") {|f| f.puts xml.target! }
  end

  def zip_up_working_directory
  end

  def tidy_up
    puts "Not deleting working dir during debug"
    # delete_working_directory
  end

  private

  def delete_working_directory
    FileUtils.rmtree WDIR_NAME if File.exist?(WDIR_NAME)
  end
end

epub = EPub.new

epub.create_working_directory
epub.create_container_xml

epub.zip_up_working_directory
epub.tidy_up
