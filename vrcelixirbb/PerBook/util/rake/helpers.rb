# encoding: utf-8
# ==================
# = Helper methods =
# ==================

require 'tempfile'

def clone_directory(from, to)
  fail "#{from} is not a directory" unless File.directory?(from)
  if File.exist?(to)
    fail "#{to} is not a directory" unless File.directory?(to)
  else
    mkdir(to, :verbose => false)
  end
  Dir.foreach(from) do |name|
    next if name =~ /^\./
    src_name = File.join(from, name)
    dest_name = File.join(to, name)
    if File.directory?(src_name)
      clone_directory(src_name, dest_name)
    else
      copy_file src_name, dest_name
    end
  end
end

def find_local_or_shared(file_name)
  local = File.join(BOOK_DIR, "local", "xml", file_name)
  result = if File.exists?(local)
             local
           else
             ppstuff = File.join(XML_DIR, file_name)
             if File.exists?(ppstuff)
               ppstuff
             else
               File.join(COMMON_XML_DIR, file_name)
             end
           end
  if RUBY_PLATFORM =~ /mswin32/ && result =~ / /
    result = %{"#{result}"}
  end
  result
end

def xslt(transform, xml_file, options = {})
  jars = %w{ saxon9he.jar }.map do |jar|
    File.join(SAXON_DIR, jar)
  end.join(File::PATH_SEPARATOR)

  options = options.dup
  transform = find_local_or_shared("#{transform}") unless transform =~ %r{^(\w:)?/}
  to = options.delete(:to)
  pipe = options.delete(:pipe)

  redirect =  if to
                redirect  = " >#{to}"
              elsif pipe
                redirect  = " | #{pipe}"
              else
                ""
              end

  xsltparams = %{in.dir="#{Dir.pwd}/" }

  options.each do |name, value|
    xsltparams << %{#{name}="#{value}" }
  end

  log = Tempfile.new("xslt-log")

  def log.path
    "#{BOOK_DIR}/xslt-output.log"
  end

  memory = defined?(SAXON_RAM) ? SAXON_RAM : 1024

  safe_sh %{java -Xmx#{memory}m -Xms#{memory}m -cp "#{jars}" net.sf.saxon.Transform -xsl:"#{transform}" -s:"#{xml_file}"  #{xsltparams}  2>"#{log.path}" #{redirect} } do
    rm(to, :verbose => true) if to

    STDERR.puts "=" * 50
    STDERR.puts File.read(log.path)
    exit! 99
  end

  File.foreach(log.path) do |line|
    if !line.valid_encoding?
      line = "@@@@ invalid encoding in #{line.inspect}"
    end
    line = line.sub(/^.*\*\*\*\* /, '')
    #line.tr!("\xd4\xd5", "`'")    # no idea why these get mangled
    if line =~ /Missing template for (.*)/
      fail($&)
    end
    if RUBY_PLATFORM =~ /mswin32/
      STDERR.puts ">> " +  line
    else
      STDERR.puts "\033[1;31m#{line}\033[0m"
    end
  end

end


def svn(cmd, options = {})
  options[:verbose] = true
  safe_sh("svn #{cmd}", options)
end


def safe_sh(*cmd, &block)
  options = (Hash === cmd.last) ? cmd.pop : {}
  rake_check_options options, :noop, :verbose, :err_ok
  puts_in_bold cmd.join(" ") if options[:verbose] || ENV["VERBOSE"]
  unless options[:noop]
    show_command = cmd.join(" ")
    show_command = show_command[0,72] + "…"
    res = system(*cmd)
    unless res
      status = $?
      yield(res, status) if block_given?
      unless options[:err_ok]
        fail "Command failed with status (#{status.exitstatus}): [#{show_command}]"
      end
    end
  end
end

def puts_in_bold(msg)
  if RUBY_PLATFORM =~ /mswin32/ || RUBY_DESCRIPTION =~ /windows/i
    puts "\n>> " +  msg
  else
    puts "\033[1;32m#{msg}\033[0m"
  end
end

def highlight_error(msg)
  if RUBY_PLATFORM =~ /mswin32/ || RUBY_DESCRIPTION =~ /windows/i
    msg
  else
    "\033[1;31m#{msg}\033[0m"
  end
end

def highlight_info(msg)
  if RUBY_PLATFORM =~ /mswin32/ || RUBY_DESCRIPTION =~ /windows/i
    msg
  else
    "\033[1;32m#{msg}\033[0m"
  end
end

def highlight_debug(msg)
  if RUBY_PLATFORM =~ /mswin32/ || RUBY_DESCRIPTION =~ /windows/i
    msg
  else
    "\033[1;35m#{msg}\033[0m"
  end
end
