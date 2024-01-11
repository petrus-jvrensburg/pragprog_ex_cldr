# Script to check links in PML documents
#
#  ruby url_validator book.xml
#
# URLs with the attribute assume-valid="yes" are not checked

# Scans URLs in PML files to ensure they're valid.
class UrlScanner

  # these are the codes we think are OK.
  SUCCESS_CODES = [200,301,302,308]

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


  # Takes a list of URLs
  def initialize(urls)
    @errors = []
    @notes  = []
    @logger = Logger.new(true)
    @urls = urls
  end

  def validate_links()
    @urls.each do |info|
      check_link(info["protocol"], info["url"])
    end
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
        url = "https://#{url}"
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
        options = {
          request: {
            open_timeout: 10,
            timeout: 10,
          },
        }


        Faraday.new(options) do |connection|

          response = connection.head(url)
          # puts "#{response.status}: #{url}"

          # Some web servers give a 403 or 405 on HEAD requests
          # if response == nil || response.status == 403 || response.status == 405
          #   request = request.get(options)
          #   response = request.head()
          # end

          unless successful?(response.status)
            error(url, "error #{response.status} (#{response.class})")
          end
        end
      rescue Exception => e
        error(url, "Could not be checked. Verify manually. Reason: #{e}")
      end
    end
  end
end
