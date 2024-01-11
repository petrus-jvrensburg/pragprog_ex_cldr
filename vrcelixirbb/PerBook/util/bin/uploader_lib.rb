# Usage:
#
#    upload_code.rb  <archive name>   <site dir>
#
# We copy the files <archive_name>-code.tgz and .zip to
#
#   <site dir>/media.pragprog.com/pblic/titles/<archive name>/code
#
# and then expand out the tag file.
#
# We then check the code into SVN in the Site tree and resync it to the
# media server.
#
# We're invoked by the 'make upload_code' target of the standard Makefile
#

require 'fileutils'

class UploaderLib

  def initialize(site_dir, book_code)
    @book_code = book_code
    @site_dir = check_site_dir_structure(site_dir)
    @book_site = File.join(@site_dir, book_code)
    @code_dir  = File.join(@book_site, 'code')
    update_book_dir
  end
  
  def update_book_dir
    Dir.chdir(@site_dir) do
      sh "svn up #{@book_code}|| true"
    end
  end
  
  def check_exists(name, must_be_dir=false)
    unless File.exist?(name)
      STDERR.puts "Can't find file #{name}"
      exit(1)
    end
    if must_be_dir && !File.directory?(name)
      STDERR.puts "#{name} is not a directory"
      exit(1)
    end  
  end

  def create_and_add(extra_subdirs)
    dirs = [ @book_code ]
    unless extra_subdirs.empty?
      #puts "Extra subdirs is #{extra_subdirs}, type is #{extra_subdirs.class}"
      dirs = dirs.concat(extra_subdirs.map {|dir| File.join(@book_code, dir)})
    end

    Dir.chdir(@site_dir) do
      dirs.each do |dir|
        unless File.directory?(dir)
          Dir.mkdir(dir)
          sh "svn add #{dir}"
        end
      end
    end
  end

  # Copy file into our tree, but don't add to SVN
  def copy_in(file, target=file)
    target =  File.join(@book_site, target)
    FileUtils.mkdir_p(File.dirname(target), :verbose => true)
    FileUtils::Verbose::cp(file, target)
  end

  def in_dir
    Dir.chdir(@book_site) do
      yield
    end
  end

  def svn_add_force
    Dir.chdir(@book_site) do
      sh "svn add --force ."
    end
  end

  def commit(msg)
    Dir.chdir(@book_site) do
      sh "svn commit -m '#{msg}'"
    end
  end

  def sync
    Dir.chdir(@book_site) do
      puts "Syncing with media.pragprog.com"
      sh "rake sync"
    end
  end

  
  # Do a system() call and fail if it does
  def sh(cmd)
    puts "\n\n++++++ #{Dir.pwd}> #{cmd}\n\n"

    unless system(cmd)
      STDERR.puts "Exiting early"
      exit(1)
    end
    puts
  end


  private

  def check_site_dir_structure(site_dir)
    %w{ media.pragprog.com public titles }.each do |dir|
      site_dir = File.join(site_dir, dir)
      check_exists(site_dir, true)
    end
    site_dir
  end


end
