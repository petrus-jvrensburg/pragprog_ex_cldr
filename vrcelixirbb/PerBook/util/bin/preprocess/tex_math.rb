# encoding: utf-8

# Look for
#
# $$
# \frac{1}{2}
# $$
#
# or the equivalent
#
# <tmath>
# \frac{1}{2}
# </tmath>
#
# and convert into SVG (by first using ritex to convert to MathML and
# then calling SVGMath)
#
# Also look for inline math between <tmi> </tmi>

require "ritex"
require "tempfile"
require "open3"
require "thread"

SVGMATH = File.expand_path("../../../../Common/ThirdPartyTools/SVGMath-0.3.3/math2svg.py",
                           File.dirname(__FILE__))

class TexMath < Preprocessor
  module SvgFiles
    DIR = 'images/_pragprog'
    SVG_OP_DIR = File.expand_path("./#{DIR}")
    WRITER_SEMA4 = Mutex.new

    def self.write(count, data)
      WRITER_SEMA4.synchronize do
        name = file_name(count)
        File.open(name, "w") { |f| f.puts data }
        name
      end
    end

    def self.file_name(count)
      File.join(SVG_OP_DIR, "svg-#{count}.svg")
    end

    # the image_list for epubs needs the relative name, not the full name
    def self.relative_file_name(count)
      File.join(DIR, "svg-#{count}.svg")
    end

    def self.create_dir
      unless File.directory?(SVG_OP_DIR)
        Dir.mkdir(SVG_OP_DIR).inspect
      end
    end
  end

  ##################################################

  def initialize(*)
    super
  end

  def extract_baseline(svg)
    svg =~ %r/<svgmath:metrics .*\bbaseline="([\d.]+)"/
    $1
  end

  def dump(index, math, inline = false)
    parser = Ritex::Parser.new
    result = parser.parse(math)
    file = Tempfile.new("math")

    ## Debugging code
    #::STDOUT.puts %Q{
        #Original math:
        ##{math}

        #MathML:
        ##{result}
    #}
    ## end debugging code
    begin
      file.puts result
      file.close

      command = "python '#{SVGMATH}' '#{file.path}'"

      # The python script isn't sending a proper exit code.
      # Sadly, we'll have to read STDERR for something.
      begin
        svg, err, code = Open3.capture3(command)
      rescue
        STDERR.puts "======================"
        STDERR.puts $!.inspect
      end
      # fatal_error("#{math}\n\tError converting Math to SVG: #{svg}\n\nOriginal math:\n\t#{math}\n\nMathML:\n#{result}") unless $? == 0

      if err != ""
        fatal_error("
        Error converting Math to SVG: #{err}

        Original math:
        #{math}

        MathML:
        #{result}

        SVG (may be meaningless):
        #{svg}

        ")
      end

      baseline_opt =
        if baseline = extract_baseline(svg)
          # 2.1 seems to line up with our text baseline
          %{baseline-shift="-#{baseline.to_f + 2.1}" }
        else
          nil
        end

      SvgFiles.write(index, svg)
      file_name = SvgFiles.relative_file_name(index)

      if inline
        %{<inlineimage #{baseline_opt}fileref="#{file_name}"/>}
      else
        %{<imagedata align="center" fileref="#{file_name}"/>}
      end
    ensure
      file.unlink
    end
  end

  INLINE_RE = %r{<tmi>(.*?)</tmi>}m

  def process(input, output)
    math = nil
    SvgFiles.create_dir

    content = input.read

    # This actually also memoizes, as identical tmi's will
    # only be converted once

    inlines = []

    while match = INLINE_RE.match(content)
      math_inline = match[1]
      whole_thing = $&
      content.gsub!(whole_thing, "«tmi #{inlines.length}»")
      inlines << math_inline
    end

    results = {}
    semaphore = Mutex.new

    pids =
      inlines
        .each_with_index
        .map { |math, index|
        Thread.new(math, index) do |math, i|
          result = dump(i, math, true)
          semaphore.synchronize do
            results[i] = result
          end
        end
      }
        .each { |thread| thread.join }

    results.each do |index, replacement|
      content = content.gsub("«tmi #{index}»", replacement)
    end

    index = "block-000"

    content.gsub!(%r{^\s*(<tmath>|\$\$)!?\s*$(.*?)^\s*(</tmath>|\$\$)!?\s*$}m) do
      math = $2
      index.succ!
      dump(index, math)
    end

    content.split(/\n/).each { |line| output.puts line }
  rescue Exception => e
    STDERR.puts e.message
    STDERR.puts e.backtrace
    raise
  end
end
