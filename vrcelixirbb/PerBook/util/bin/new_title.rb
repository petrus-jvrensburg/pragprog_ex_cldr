#
# Create a new book's directory
#
#   ruby ../util/bin/new_title.rb  TITLE
#
#
require 'fileutils'
require 'rdoc/usage'
require 'find'

unless Dir.pwd.split(%r{/})[-1] == "titles"
  fail "Must be run in the Bookshelf/titles directory"
end

title = ARGV.shift || RDoc::usage(1)

Dir.mkdir(title)

dirs = []
files = []

Dir.chdir('template') do
  Find.find('.') do |f|
    f = f.sub(%r{\./}, '')
    if f =~ /CVS/
      Find.prune
      next
    end
    case 
    when File.directory?(f)
      dirs << f unless f == "."
    else
      files << f
    end
  end
end


# Now add everything
ENV['CVS_RSH'] = 'ssh'
system("cvs -q add #{title}")
Dir.chdir(title) do
  dirs.each do |dir|
    Dir.mkdir(dir)
    system("cvs add #{dir}")
  end

  files.each do |file|
    FileUtils::cp(File.join("../template", file), file)
  end

  makefile = File.read("Makefile")
  makefile.gsub!(/name/, title)
  File.open("Makefile", "w") {|f| f.write makefile}
  system("cvs add #{files.join(' ')}")

  system("cvs commit -m 'Add #{title}'")
end




