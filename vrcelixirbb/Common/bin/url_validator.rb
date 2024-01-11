# Script to check links in PML documents
#
#  ruby url_validator book.xml
#
# URLs with the attribute assume-valid="yes" are not checked

require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'net/https'



# ##########################################################################################
# # https://www.ruby-lang.org/en/news/2014/10/27/changing-default-settings-of-ext-openssl/ #
# ##########################################################################################
#
# module OpenSSL
#   module SSL
#     class SSLContext
#       remove_const(:DEFAULT_PARAMS)
#       DEFAULT_PARAMS = {
#         :ssl_version => "SSLv23",
#         :verify_mode => OpenSSL::SSL::VERIFY_PEER,
#         :ciphers => "ALL",
#         :options => -> {
#           opts = OpenSSL::SSL::OP_ALL
#           opts &= ~OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS if defined?(OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS)
#           opts |= OpenSSL::SSL::OP_NO_COMPRESSION if defined?(OpenSSL::SSL::OP_NO_COMPRESSION)
#           opts |= OpenSSL::SSL::OP_NO_SSLv2 if defined?(OpenSSL::SSL::OP_NO_SSLv2)
#           opts |= OpenSSL::SSL::OP_NO_SSLv3 if defined?(OpenSSL::SSL::OP_NO_SSLv3)
#           opts
#         }.call
#       }
#     end
#   end
# end
#

def usage
  File.read(__FILE__) =~ /((^\#.*\n)+)/
  STDERR.puts $1.gsub(/^#/, '')
  exit 1
end


# Scans URLs in PML files to ensure they're valid.
class UrlScanner

  # these are the codes we think are OK.
  SUCCESS_CODES = [200,301,302]

  USER_AGENT =  { 'User-Agent' => "Book Link Checker (dave@pragprog.com)" }
  attr_reader :errors, :notes

  class Logger

    def log(msg)
      if STDOUT.isatty
        print msg.ljust(@last_msg_length)
        @last_msg_length = msg.length
        print "\r"
        STDOUT.flush
      else
        puts msg
      end
    end

    def initialize(verbose)
      @last_msg_length = 0
      unless verbose
        def log; end
      end
    end
  end


  # Takes an options hash
  # scanner = PML::UrlScanner.new :document => "book.xml", :verbose => true
  def initialize(options)
    @errors = []
    @notes  = []
    @document  = options[:document]
    @logger = Logger.new(options[:verbose])
  end


  # Returns true if the status code passed in is
  # a successful URL. See the SUCCESS_CODES constant for valid codes.
  def successful?(code)
    SUCCESS_CODES.include? code.to_i
  end

  def error(url, message)
    @errors << sprintf("%-40s %s", url, message)
  end

  def note(url, message)
    @notes << sprintf("%-40s %s", url, message)
  end

  # Tests an individual link by sending a HEAD request and interpreting the
  # status code. Places errors in the errors array.
  def check_link(protocol, url)
    unless url =~ /^\w+:/
      if protocol
        url = "#{protocol}#{url}"
      else
        url = "http://#{url}"
      end
    end

    begin
      uri = URI.parse(url)
    rescue
      error(url, "Malformed URL")
      return
    end

    return if uri.host == "localhost" || uri.host == "127.0.0.1" || uri.host =~ /\.dev$/

    case uri.scheme
    when nil
      error(url, "is missing a protocol (such as http://)")
    when "mailto", "ftp", "ldap", "irc"
      note(url, "can't be checked, so I'm assuming it's OK")
    else
      begin
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 60
        http.use_ssl = true if uri.port == 443 # FIXME: there's no protocol method? Seems dumb.
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :TLSv1

        http.ciphers ||= [] # ciphers should have been set.
        http.ciphers << "ECDHE+RSA+AES128+SHA256"  # add ciphers

        request = Net::HTTP::Head.new(uri.request_uri, USER_AGENT)

        # why "rescue nil"? Because some sites seem to barf on head requests, and cause protocol.rb
        # to read past end-of-file
        response = http.request(request) rescue nil

        # Some web servers give a 403 or 405 on HEAD requests
        if response == nil || response.code == "403" || response.code == "405"
          request = Net::HTTP::Get.new(uri.request_uri, USER_AGENT)
          response = http.request(request)
        end

        unless successful?(response.code)
          error(url, "error #{response.code} (#{response.class})")
        end
      rescue OpenSSL::SSL::SSLError => e
        error(url, e.message) unless e.message =~ /handshake_failure/
      rescue Timeout::Error => e
        error(url, "Timeout")
      rescue SocketError => e
        error(url, "socket error #{e}")
      rescue Errno::ETIMEDOUT => e
        errors(url, "timed out")
      rescue Errno::ECONNRESET => e
        error(url, "Connection Reset")
      rescue Errno::ECONNREFUSED => e
        error(url, "Connection Refused")
      rescue NoMethodError => e
        error(url, "may be malformed")
      rescue java.lang.RuntimeException => e
        error(url, "Could not be checked. Verify manually. Reason: #{e}")
      end
    end
  end

  # Parses the document for all urls found within <url> tags, returns
  # an array containing unique URLs
  def links
    @links ||= Nokogiri::HTML(File.read(@document)).css('url').
               select {|u| u['assume-valid'] != "yes" }.
               map    {|u| [ u['protocol'], u.text ]}.
               uniq
  end

  # Iterates through all links in the document, validating them
  # and placing error messages in the errors array.
  def validate_links
    links.each do |protocol, url|
      @logger.log("Checking #{url}")
      status = check_link(protocol, url)
    end
  end
end

if ARGV[0]
  url_scanner = UrlScanner.new(:document => "book.xml", :verbose => true)
  url_scanner.validate_links
  STDERR.puts
  unless url_scanner.notes.empty?
    STDERR.puts "\n\nNotes:\n"
    STDERR.puts "="*50
    STDERR.puts url_scanner.notes
  end
  unless url_scanner.errors.empty?
    STDERR.puts "\n\nERRORS:\n"
    STDERR.puts "="*50
    STDERR.puts url_scanner.errors
    STDERR.puts "\n\n"
  end
  STDERR.puts "Done preflight checking\n\n"
  exit(url_scanner.errors.empty? ? 0 : 1)
else
  usage
end
