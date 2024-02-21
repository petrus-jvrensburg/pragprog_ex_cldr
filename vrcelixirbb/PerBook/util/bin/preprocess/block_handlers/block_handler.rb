require "cgi"

def validate_options(name, options, spec)
  options.each do |k, v|
    case spec[k]
    when nil
      fail "unknown option for #{name}: #{k.inspect}"
    when :string
      ;
    when :bool
      unless ["yes", "no"].include?(v.downcase)
        fail "#{name}: options #{k.inspect} should have the value \"yes\" or \"no\""
      end
    else
      fail "Internal error: unknown validator for block type #{name}: #{spec[k].inspect}"
    end
  end
end

class BlockHandler

  def escape(str)
    CGI::escapeHTML(str)
  end

  def initialize(options = {}, name=nil, valid_spec=nil)
    @options = options
    if name && valid_spec
      validate_options(name, @options, valid_spec)
    end
  end

  def handle_line(line, output)
    output.puts line
  end

end


