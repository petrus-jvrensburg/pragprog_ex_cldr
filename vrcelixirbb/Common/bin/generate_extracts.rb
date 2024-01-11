# encoding: utf-8

require 'nokogiri' 

TEMPLATE = %{
<!DOCTYPE html5>
<html>
</html>
}


    
class HtmlChapter 
  
  attr_reader :header
  
  def initialize(filename)
    @doc = Nokogiri::HTML.parse(File.read(filename))
    find_header
  end          
  
  def each_extract
    @doc.css("div[ppextract]").each do |extract|
      yield extract
    end
  end
  
  def homepage
    homepage = @header.css('link[rel="homepage"]').first
    fail "No homepage link" unless homepage 
    homepage['href']
  end        
  
  def title
    title = @header.css('meta[name="book-title"]').first
    fail "No title meta tag" unless title
    title['content']
  end
    
  def author
    author = @header.css('meta[name="book-author"]').first
    fail "No author meta tag" unless author
    author['content']
  end
    
    
  private
  
  def find_header
    @header = @doc.css("head")
  end
end

class Extractor

  def initialize(filename)
    @html = HtmlChapter.new(filename)
  end 
  
  def create_extracts
    @html.each_extract do |extract|
      create_document_containing(extract)
    end
  end  
  
  # can't build as a nokogiri document, because the library seems to have reentrancy problems...
  def create_document_containing(extract)
    result = "<!DOCTYPE html>\n<html>\n"
    result << @html.header.to_html
    result << "<body>\n"
    result << standard_blurb
    result << extract.to_html
    result << "</body>\n</html>\n"
    puts result
  end
  
  class Holder
    attr_accessor :homepage, :book_code, :author, :title
    def binding
      super
    end
  end
  
  def standard_blurb
    homepage = @html.homepage
    unless homepage =~ %r{titles/(\w+)}
      fail "Can't find book code in homepage: #{homepage}"
    end
    book_code = $1
    title = @html.title
    author = @html.author

    builder = Nokogiri::HTML::Builder.new do |intro|
      intro.div(:class => "extract-header") do 
        intro.div(:class => "cover-image") do
          intro.a(:href => homepage) do
            intro.img(:src => "http://www.pragprog.com/images/covers/190x228/#{book_code}",
      	              :alt => "Cover image for #{title}")
          end
        end
        
        intro.div(:class => "blurb") do
          intro.p do
            intro.text %{The following is an extract from the Pragmatic Bookshelf title}
            intro.span(:class => "book-title") do
              intro.text title
            end
            intro.text " by "
            intro.span(:class => "author") do
              intro.text author
            end
            intro.text "."
          end

          intro.p(%{
             This extract is formatted in HTML, and so has a different layout
             to the book itself. To some extent this layout depends on how
             your browser is set up. Note that this extract may contain
             color—the printed book will be grayscale.})

          intro.p do
            intro.text "Visit the book's "
            intro.a(:href => homepage) do
              intro.text "home page"
            end
            intro.text " for more information and to purchase this title." 
          end
        end
      end
    end
    intro = builder.to_html.sub(/<!DOCTYPE.*?\n/, '')
    intro
  end
  
end                              

ARGV.each do |filename|
  Extractor.new(filename).create_extracts
end