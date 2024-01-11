# Update a book to use the new Rake build mechanism    
                       
require 'rubygems'
require 'erb'     
require 'hpricot'
require 'fileutils'
include FileUtils

RAKEFILE = 
%{NAME  = "<%= params['NAME'] %>"    # eg:  JAERLANG, RAILS  -*- ruby -*-

# Used by the barcode software
ISBN   = "<%= params.val('ISBN', 'x-xxxxxxx-xxx')  %>"
UPC    = "<%= params.val('UPC', 'xxxxxxxxxxxx')   %>"
PRICE  = "<%= params.val('PRICE', '9999').tr('.', '') %>"


# This stanza is for the creation of the code .zip and .tgz files.
# It's also used for the .mobi file
TITLE  = %{<%= params['TITLE'] %>}
AUTHOR = %{<%= author_surnames %>}

CODE_IGNORE_LIST = %{<%= params['CODE_IGNORE_LIST'] %>}

# EXTRA_STYLESHEET = "relative_path_to_css"
# EXTRA_BIB_FILES  = "-b bibfile.bib -b another.bib"

# What format ebooks can we generate
EBOOKS = [ :pdf, :epub, :mobi ]

require "../PPStuff/util/rake/main.rb"
}

def determine_book_directory
  dirs = Dir.pwd.split("/")
  while dirs.last !~ /^titles|published$/ && !dirs.empty?
    last = dirs.pop
  end
  fail "No idea where I am" if dirs.empty?
  return last, File.join(dirs, last)
end                 
   
def check_for(top, files)
  files.each do |file|
    name = File.join(top, file)
    if File.exist?(file)
      puts "\nThere's an existing #{file}. I'm prudently bailing...\n\n"
      exit
    end
  end
end

def check_everythings_ok(top)
  check_for(top, 
            %w{Book/Rakefile Book/local/xml/ppb2mobi.xsl Book/local/xml/ppb2ops.xsl}
            )
end

def create_rakefile(name, top)
  makefile = File.read(File.join(top, "Book/Makefile"))
  makefile = makefile.gsub(/\s*\\\s*\n\s+/m, ' ')
  params = parse(makefile)
  author_surnames = get_author_surnames(top)                   
  params['NAME'] = name.upcase
  def params.val(key, default) 
    return default unless self.has_key?(key)
    val = self[key]
    val = default if val == ""
    val
  end                          
  rakefile = ERB.new(RAKEFILE).result(binding)
  filename = File.join(top, "Book/Rakefile") 
  File.open(filename, "w") {|f| f.puts rakefile}
  system("svn add #{filename}")
end                       
                   
# look for NAME=VALUE strings in a makefile, returning a hash
def parse(makefile)
	result = {}
	makefile.scan(/^([A-Z_]+)=(.*)/) do |name, value|
		value = value.strip
		value = $1 if value =~ /^"(.*)"$/
		result[name] = value
	end
	result
end         

def get_author_surnames(top)
	names = []
	xml = Hpricot(File.read(File.join(top, 'Book/book.pml')))
	(xml/'//authors/person/name').each do |c|
		names << c.inner_html.split.last
	end                               
	names.join(", ")
end                                                    

def copy_in_local_xsl(top)
	src  = File.expand_path("../../titles/_template/Book/local/xml", top)
	dest = File.expand_path("Book/local/xml", top)
	%w{ ppb2mobi.xsl ppb2ops.xsl }.each do |file|
		 dest_file = File.join(dest, file)
		 cp File.join(src, file), dest_file, :verbose => true
		 system("svn add #{dest_file}")
	end
end                    

def link_to_rake_tasks(top)
  src  = "../../../../titles/_MASTER/PPStuff/util/rake"
  dest = File.expand_path("PPStuff/util/rake", top)
  if File.exist?(dest)
    puts "\n\nThere's already a #{dest} directory. I won't overwrite it"
  else
    ln_s src, dest, :verbose => true	   
    system("svn add #{dest}")                                  	
  end
end


def move_old_makefile
  Dir.chdir('Book') do
    system("svn mv Makefile OldMakefile")
  end
end

##################################################

name, top = determine_book_directory
                                                      
Dir.chdir(top)

check_everythings_ok(top)

create_rakefile(name, top)
copy_in_local_xsl(top)
link_to_rake_tasks(top)
move_old_makefile

