# encoding: utf-8

# unless defined?(RUBY_PLATFORM) && RUBY_PLATFORM == "java"
#
#   puts "\nYou no longer run update_ads manually.\n\n"
#   puts "Instead, just run:\n\n"
#   puts "   ./rake update_ads\n\n"
#   puts "in the Book/ directory\n\n"
#   exit(1)
# end

# Require a gem by seeing if it's installed. If it is, great.
# If not,  install it.
def require_or_install(gem)
  begin
    Gem::Specification.find_by_name(gem)
  rescue Gem::LoadError => e
    puts "Installing missing gem #{gem}"
    `gem install #{gem}`
    Gem.clear_paths  # so the new gems show up
  end
  require gem
end

require 'rubygems'
require 'open-uri'
require 'rexml/document'
require 'net/http'
require 'bigdecimal'
require_or_install 'builder'
require_or_install 'RedCloth'

class CatalogEntry < Hash
  def initialize(xmldoc)
    xmldoc.each_element do |element|
      if element.text
        self[element.name] = element.text
      end
    end
  end
end

def entry_text_for(product)
  xml = Builder::XmlMarkup.new(:indent => 2)
  result = xml.ad do |ad|
    ad.bookcode(product["code"])
    ad.title(product["title"])
    ad.subtitle(product["subtitle"])
    ad.tag!("author-list", product["author"])
    ad.isbn13(product["isbn13"])
    ad.pagecount(product["pagecount"])
    price = product["channel_price_usd"]
    unless price =~ /^\d/
      puts %{*** Invalid channel price for #{product["code"]}}
    else
      price = BigDecimal(price)
      if price == price.to_i
        price = sprintf("%d", price)
      else
        price = sprintf("%1.2f", price)
      end
    end
    ad.price(price)
    ad.blurb do |blurb|
      content = RedCloth.new(product["highlight_description"]).to_html

      content.gsub!(%r{<code>},  "<ic>")
      content.gsub!(%r{</code>}, "</ic>")

      content.gsub!(%r{<br />}, '')
      content.gsub!(%r{em>}, 'emph>')
      content.gsub!(%r{<span class=".*?">}, "")
      content.gsub!(%r{<a .*?>}, '')
      content.gsub!(%r{</a>}, '')
      content.gsub!(%r{</?strong>}, '')
      content.gsub!(%r{</span>}, '')
      content.gsub!(%r{\r?\n}, ' ')
      content.gsub!(%r{<p>}, "\n    <p>\n      ")
      content.gsub!(%r{</p>}, "\n    </p>\n")
      content.gsub!(%r{&mdash;}, "–")
      blurb << content
    end
  end
  result
end

def ad_file_name(code)
  File.join("ads", "#{code}.pml")
end

def write_entry_for(product)
  new_content = entry_text_for(product)
  code = product["code"]
  output_name = ad_file_name(code)
  # code_label = "#{code}:".ljust(15)
  if File.exist?(output_name)
    old_content = File.read(output_name)
    if old_content == new_content
      # puts "#{code_label} unchanged"
    else
     #  puts "#{code_label} file #{output_name} exists. No change was made."
    end
  else
    File.open(output_name, "w") {|f| f.puts new_content }
    # puts "#{code_label} created"
  end
end

# require 'openssl'
# OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)

def fetch_products
 # xml = URI.open("https://admin.pragprog.com/api/products.xml").read
 # REXML::Document.new(xml)

  uri = URI("https://admin.pragprog.com/api/products.xml")

  req = Net::HTTP::Get.new(uri)
  req.basic_auth ENV["API_USER"], ENV["API_PW"]
 # req.basic_auth "pragsadmin", "bulbul-diocese-mislead-HUCKSTER"
  res = Net::HTTP.start(uri.hostname, uri.port,
    :use_ssl => true) {|http|
    http.request(req)
  }
  if res.code.to_i != 200
    raise "HTML Error #{res.code} #{res.body}"
  end

  REXML::Document.new(res.body)
end

# quick sanity check
unless File.directory?("ads")
  fail "You have to run this in Common/backmatter"
end

fetch_products.each_element("products/product[type='Title']") do |product|
  write_entry_for(CatalogEntry.new(product))
end
