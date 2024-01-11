# encoding: utf-8

require 'thread'


class Preprocessor


  # These run first

  PREPROCESSORS = []

  # this one runs at the end
  TRAILING_PREPROCESSORS = []


  class << self

    def remove_all
      PREPROCESSORS.clear
      TRAILING_PREPROCESSORS.clear
    end

    # This is the version to be used by authors
    def add_local(klass_name, list=PREPROCESSORS)
      klass_name, path = get_klass_and_path(klass_name, nil)
      path = File.join("local", "util", "#{path}.rb")
      unless File.exist?(path)
        warn("Cannot find a local preprocessor for #{klass_name} in #{path}")
        exit! 1
      end
      add_internal(path, klass_name, "", list)
    end

    def add_local_final(klass_name)
      add_local(klass_name, TRAILING_PREPROCESSORS)
    end


    def add_internal(path_or_klass,
                     klass_name=nil,
                     options="",
                     list = PREPROCESSORS)
      list << lookup_preprocessor(path_or_klass, klass_name, options)
    end

    def prepend_internal(path_or_klass,
                         klass_name=nil,
                         options="",
                         list = PREPROCESSORS)
      list.unshift lookup_preprocessor(path_or_klass, klass_name, options)
    end

    def use_rouge_for_highlighting
      Preprocessor.remove_final(PmlCode)
      Preprocessor.prepend_final("../PerBook/util/bin/preprocess/rouge_code/lib/rouge_code", "RougeCode")
    end


    def lookup_preprocessor(path_or_klass, klass_name, options)
      klass_name, path = get_klass_and_path(path_or_klass, klass_name)
      require path
      klass = Module.const_get(klass_name)
      unless klass < self
        STDERR.puts "Your preprocessor #{klass.name} is not a subclass of Preprocessor"
        exit 1
      end
      [ klass, options ]
    end


    def add_final(path_or_klass, klass_name=nil, options="")
      klass_name, path = get_klass_and_path(path_or_klass, klass_name)
      add_internal(path, klass_name, options, TRAILING_PREPROCESSORS)
    end

    def prepend_final(path_or_klass, klass_name=nil, options="")
      klass_name, path = get_klass_and_path(path_or_klass, klass_name)
      prepend_internal(path, klass_name, options, TRAILING_PREPROCESSORS)
    end


    def remove_final(class_name)
      TRAILING_PREPROCESSORS.delete_if do |klass, _|
        klass.name == class_name
      end
    end

    def add_syntax(name)
      path = File.join("local", "util", "syntax", "#{name}.rb")
      unless File.exist?(path)
        warn("Cannot find a syntax for #{path}")
        exit! 1
      end
      load(path)
    end

    def get_klass_and_path(path_or_klass, klass_name)
      if klass_name.nil?
        klass_name = path_or_klass
        path = klass_name.gsub(/([a-z0-9])([A-Z])/) { "#{$1}_#{$2}" }.downcase
      else
        path = path_or_klass
      end
      return klass_name, path
    end

    def preprocess(from_file, to_file)
      preprocessors = (PREPROCESSORS + TRAILING_PREPROCESSORS).
        map { |klass, options| klass.new(options) }

      puts_in_bold "Preprocessing with #{preprocessors.map {|pre| pre.class.name}.join(', ')}"
      list = preprocessors.dup
      preprocessor = list.shift
      list.each do |next_preprocessor|
        preprocessor.connect_to(next_preprocessor)
        preprocessor = next_preprocessor
      end


      File.open(from_file) do |ip|
        preprocessors.first.input = ip
        preprocessors.first.input_file_name = from_file
        File.open(to_file, "w") do |op|
          preprocessors.last.output = op
          preprocessors.each {|pp| pp.start}
        end
      end
    end
  end

  class InputWrapper
    attr_accessor :current_file_name
    attr_reader   :lineno

    def initialize(stream)
      @stream = stream
      @current_file_name = "unknown"
      @lineno = 0
    end

    def puts(line)
      @stream.puts line
    end

    if defined? Encoding
      UTF = Encoding.find("utf-8")
    else
      UTF = nil
    end

    def gets
      line = @stream.gets
      raise "#{line.encoding}  #{line}" if UTF && line && line.encoding != UTF
      if line && (line =~ /<\?location (.*?):(\d+) \?>/)
        @current_file_name = $1.dup
        @lineno = Integer($2)
      else
        @lineno += 1
      end
      line
    end

    def read
      @stream.read
    end

    def location
      "#{current_file_name}:#{lineno}"
    end
  end

  attr_writer :input
  attr_writer :output

  def initialize(options = {})
    self.input  = STDIN
    self.output = STDOUT
    @options    = options
  end

  def input=(stream)
    @input = InputWrapper.new(stream)
  end

  def input_file_name=(name)
    @input.current_file_name = name
  end

  def connect_to(next_processor)
    queue = create_queue
    @output = next_processor.input = queue
    @run_in_thread = true
  end


  def start
    if @run_in_thread
      Thread.new do
        log "Start in thread" if $DEBUG
        Thread.current.abort_on_exception = true
        process_wrapper
      end
    else
      log "Start inline" if $DEBUG
      process_wrapper
    end
  end

  def process_wrapper
    log("Starting") if $DEBUG
    process(@input, @output)
    @output.puts(nil) unless @output.kind_of?(IO) || @output.kind_of?(StringIO)
    log("Ending") if $DEBUG
  rescue Exception => e
    fatal_error("#{e.message}\n\n")  # {e.backtrace[0..3].join("\n")}")
  end

  def process(input, output)
    while line = input.gets
      output.puts map(line.chomp)
    end
  end


  def mark_line_number(lineno=@input.lineno)
    puts("<?location #{@input.current_file_name}:#{lineno} ?>")
  end


  def mark_file_and_line_number(file, lineno=@input.lineno)
    @input.current_file_name = file
    mark_line_number(lineno)
  end

  def record_line_numbers
    yield
    mark_line_number
  end

  def fatal_error(msg)
    log
    log
    log highlight_error("[#{@input.location}] #{msg}")
    exit!(99)
  end

  def error(msg)
    log
    log highlight_error("[#{@input.location}] #{msg}")
    log
  end

  def log(msg=nil)
    if msg
      STDERR.print "#{self.class.name}: #{msg}\n"
    else
      STDERR.puts
    end
  end

  # We keep track of the file name and line number from the original files
  def gets
    @input.gets
  end

  def puts(line)
    @output.puts(line.chomp)
  end

  def test(data)
    require 'stringio'
    count = 0
    data.split(/given:\s*/).each do |test_case|
      next if test_case =~ /\A\s*\Z/m
      if test_case =~ /([^\n]*)\n(.*?)^expect:\s*\n(.*)/m
        name = $1
        input  = StringIO.new($2.strip)
        output = StringIO.new(op="", "w")
        expected = $3.strip
        convertor = self.class.new
        convertor.input = input
        convertor.output = output
        convertor.process_wrapper
        op = op.strip
        unless strip(expected) == strip(op)
          warn "Expected: #{expected.inspect}"
          warn "Got:      #{op.inspect}"
          fail "Test #{name} failed"
        end
        count += 1
      else
        warn "================================"
        warn test_case
        fail "Badly formed test case"
      end
    end
    STDERR.puts "Tests passed: #{count}"
  end

  def strip(string)
    string.gsub(/^\s+/, '')
  end

private

  def create_queue
    queue = Queue.new
    queue.instance_variable_set(:@lineno, 0)
    def queue.gets
      @lineno += 1
      result = pop
      # if result && result.encoding.name != "UTF-8"
      #   STDERR.puts result.inspect
      #   STDERR.puts result.encoding.inspect
      # end
      result
    end
    def queue.puts(line)
      self << line
    end
    def queue.read
      data = []
      while line = gets
        data << line
      end
      data.join("\n")
    end
    def queue.lineno
      @lineno
    end
    queue
  end

end

