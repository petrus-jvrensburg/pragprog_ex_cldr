# Take the trace output of LaTeX and tidy it up
#
 

QUIET = ARGV.shift == "--quiet"


while line = gets
  line = line.sub(/^.*\*\*\*\* /, '')
  if RUBY_PLATFORM =~ /mswin32/ || RUBY_DESCRIPTION =~ /windows/i
    STDERR.puts ">> " +  line
  else
    STDERR.puts "\033[1;31m#{line.chomp}\033[0m"
  end
end
