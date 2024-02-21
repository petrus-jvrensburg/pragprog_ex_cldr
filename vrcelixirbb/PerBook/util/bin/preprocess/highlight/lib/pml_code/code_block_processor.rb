# encoding: utf-8

require_relative 'highlight'

Encoding.default_external = "utf-8" if defined?(Encoding)

class PmlCode
  class CodeBlockProcessor

    # Valid arguments to a <code> element, and their default values
    DEFAULT_ARGS = {
      'style'       => 'normal',        # 'shaded' draws code in shaded box
      'end'         => nil,             # where to end
      'end-exclude' => nil,             # where to end (but exclude that line)
      'file'        => nil,             # name of file to read from
      'forcenumber' => nil,             # do we number lines  (NOT TO BE USED BY AUTHORS)
      'highlight'   => 'yes',           # do we honor START_HIGHLIGHT
      'id'          => nil,             # so we can cross reference to this code
      'language'    => nil,             # determine the code fragment's language
      'part'        => nil,             # which part of file to read
	    'size'        => nil,             # size of font used in code
      'start'       => nil,             # pattern to start matching
      'showname'    => 'yes',
      'verbatim'    => "no",               # don't strip START: and END: comments
      'add-id'      => "yes"            # if no, omit id= in output. Used when adding the same code twice
    }

    # These options are passed through to the xml output
    PML_ATTRS = %w{ cite forcenumber id language  shaded showname size style url }


    attr_reader :code   # for testing

    def initialize(first_line, infile, preprocessor)
      @infile = infile
      @code_options = parse_options(first_line)
      @preprocessor = preprocessor
    end

    # split out to make testable
    def process
      code = load_code

      highlighter = PmlCode::Highlight.new(code, @code_options['language'], @code_options, @preprocessor)
      code = highlighter.to_pml
      result = [
        start_processed_code,
        "\n",
        code,
        "</processedcode>\n"
      ].join
    end


    def parse_options(line)
      # make sure we have the full first line
      until line =~ />/
        newline = @infile.gets
        fail "Couldn't find and of <code... line" unless newline
        line << newline
      end

      fail line
      line =~ /<([-\w]+)/
      @closing_tag = $1

      options = DEFAULT_ARGS.dup

      options['language'] = 'ruby' if @closing_tag == 'ruby'

      possible_language = options["class"]  # for fenced code blocks from Kramdown
      if possible_language && possible_language =! /language-(.*)/
        options["language"] = $1
        options["class"] = nil
      end

      STDERR.puts "-----\n\n\n#{line}\n\n\n-----"
      if line =~ %r{^(\s*)<(nested-code|code|result|ruby|interact)\s+(.*)/?>}m
        arg_text = $3
        arg_text.scan(/([-\w]+)=(["'])(.*?)\2/) do |name, unused, val|
          unless DEFAULT_ARGS.has_key?(name)
            fail "Invalid argument to <code>: '#{name}'"
          end
          options[name] = val
        end
      end

      options['inline_code'] = (line !~ %r{/(code)?>})

      if options['inline_code']
        fail "Can't have file= and also have inline code" if options['file']
      else
        fail "Missing source file= in #{line.inspect}" unless options['file']
        unless options['language']
          if options['file'] =~ /\.([\w\d]+)$/
            options['language'] = $1
          end
        end
      end

      # We put the lozenge out if a file name is given and showname is not 'no'.
      # Showname can also be set to a filename, which forces that
      # name to be used. This is only intended to be used by other preprocessors.

      options['showname'] ||= 'yes'

      if options['file'].nil?
        options['showname'] = 'no'
      end

      # if options['inline_code'] && options['showname'] != 'no'
      #   options['file'] = showname
      #   options['livecode'] = true
      #   options['showname'] = 'yes'
      # end

      if options['showname'] != 'no'
        file_name = options['file'].sub(%r{^code/}, '')
        options['url'] = file_name
      #  if file_name.length > 80
      #    STDERR.puts "File name '#{file_name}' truncated"
      #    file_name = file_name[0, 40] + " . . . " + file_name[-40..-1]
      #  end
        options['showname'] = file_name if options['showname'] == 'yes'
      end

      options
    end

    def load_code
      if @code_options['inline_code']
        code = read_inline_code
      else
        code = read_code_from_file(@code_options['file'])
      end
      code = extract_parts_from(code)
      code.shift   until code.empty? || code[0]  !~ /^\s*$/
      code.pop     until code.empty? || code[-1] !~ /^\s*$/
      normalize(code)
      code.join("\n")
    end

    def read_inline_code
      res = []
      has_cdata = false
      start = @infile.lineno
      while line = @infile.gets
        break if line =~ %r{^\s*</#{@closing_tag}>}
        res << line
        has_cdata = true if @code_options['verbatim'] == 'no' && line =~ /!\[CDATA\[/i
      end
      fail "Unterminated <code> block starting on line #{start}" unless line
      res = remove_cdata_from(res) if has_cdata
      res
    end

    def remove_cdata_from(code)
      return code if !code[0] || code[0] !~ /<!\[CDATA\[/i

      res = []
      line = code.shift.sub(/<!\[CDATA\[/i, '')
      res << line unless line =~ /^\s*$/
      looking_for_end = true

      code.each do |line|
        if looking_for_end && line.sub!(/\]\]>/, '')
          looking_for_end = false
          res << line unless line =~ /^\s*$/
        else
          res << line
        end
      end
      res
    end


    def read_code_from_file(filename)
      fail("Code file '#{filename}' is not in the code/ directory") unless filename =~ %r{^code/}
      open_opts = if RUBY_VERSION =~ /^1.9/
                    "r:utf-8"
                  else
                    "r"
                  end

      File.open(filename, open_opts) {|f| content = f.readlines; f.close; content }
    rescue Exception => e
      if e.kind_of? Errno::EACCES
        STDERR.puts "Retrying #{filename} after access failure"
        sleep 0.2
        File.open(filename, open_opts) {|f| content = f.readlines; f.close; content }
      else
        raise
      end
    end

    def extract_parts_from(code)
      part = @code_options['part']
      res = []

      if @code_options['start']
        start_regexp = Regexp.new(@code_options['start'])
        end_regexp = @code_options['end'] || @code_options['end-exclude']
        fail "start= but no end=/end-exclude=" unless end_regexp
        end_regexp = Regexp.new(end_regexp)
      else
        start_regexp = nil
      end

      # if there's a part or start argument, we aren't copying initially
      copying = !(part || start_regexp)
      code.each do |line|

        line.chomp!

        # expand tabs!
        1 while line.sub!(/\t+/) { ' ' * ($&.length*8 - $`.length % 8) }
        line.rstrip!

        if part
          if line =~ /(\s*).*START:\s*#{part}([^-a-zA-Z0-9_.]|$)/
            copying = true
            next
          end

          if line =~ /END:\s*#{part}([^-a-zA-Z0-9_.]|$)/
            copying = false
            next
          end
        end

        if start_regexp
          if line =~ start_regexp
            copying = true
          end

          if copying && @code_options["end-exclude"] && line =~ end_regexp
            copying = false
            next
          end
        end

        if copying
          if @code_options['verbatim'] == "yes" || line !~ /START:|END:/
            res << line
          end
        end

        if start_regexp && copying && line =~ end_regexp
          copying = false
        end

      end

      fail("Can't find part '#{part}'") if part  && res.empty?

      # -- can't do that here -- have to strip #START_HIGHLIGHT first
      # Now reduce all lines to their natural left margin
      #bring_to_margin(res)
      res
    end


    # Bring our code to a common margin
    def normalize(code_lines)
      leading_spaces = nil
      code_lines.each do |line|
        unless line =~ /^\s*$/
          line =~ /(^ *)/
          leading_spaces = $1.length if leading_spaces == nil || $1.length < leading_spaces
        end
      end

      if leading_spaces
        pattern = Regexp.new("^" + " "*leading_spaces)
        code_lines.each {|line| line.sub!(pattern, '') }
      end

      code_lines
    end

    # create the <processedcode> header including all the options
    def start_processed_code
      res = [ '<processedcode' ]
      PML_ATTRS.each do |attr|
        value = @code_options[attr]
        if value && (attr == 'file' || attr == 'url')
          value = value.sub(%r{^code/}, '')
        end
        res << %{ #{attr}="#{value}"} if value
      end
      res << '>'
      res.join
    end

  end
end
