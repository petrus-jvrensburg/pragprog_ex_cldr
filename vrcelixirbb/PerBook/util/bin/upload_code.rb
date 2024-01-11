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

$:.unshift File.dirname(__FILE__)
require 'uploader_lib'

def usage
  STDERR.print File.readlines(__FILE__)[0,3]
  exit(1)
end


archive  = ARGV.shift || usage
site_dir = ARGV.shift || usage

archive = archive.downcase

tgz = archive + "-code.tgz"
zip = archive + "-code.zip"


uploader = UploaderLib.new(site_dir, archive)
uploader.check_exists(tgz)
uploader.check_exists(zip)

uploader.create_and_add(['code'])

# Copy the two code archives across
uploader.copy_in(tgz,  File.join('code', tgz))
uploader.copy_in(zip,  File.join('code', zip))

# Expand the tgz file in place, then add the whole mess to svn
uploader.in_dir do
  uploader.sh "tar xzf code/#{tgz}"
  uploader.sh "svn add --force ."
end

uploader.commit("Add code for #{archive}")
uploader.sync
