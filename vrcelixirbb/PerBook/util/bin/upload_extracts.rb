# Usage:
#
#    upload_extracts.rb  <archive name>   <site dir>
#

require 'rubygems'
require 'hpricot'

$:.unshift File.dirname(__FILE__)
require 'uploader_lib'

def usage
  STDERR.print File.readlines(__FILE__)[0,3]
  exit(1)
end

archive  = ARGV.shift || usage
site_dir = ARGV.shift || usage
uploader = UploaderLib.new(site_dir, archive)

images = {}
extracts = Dir['*-extract.html']
fail("No extracts to upload") if extracts.empty?

extracts.each do |chapter|
  uploader.copy_in(chapter)
  content = File.read(chapter)
  doc = Hpricot(content)
  doc.search('img').map {|img| img['src']}.each do |src|
    images[src] = 1 if src !~ /^http:/
  end
end

# Now copy in the images
images.keys.each do |image|
  uploader.copy_in(image)
end

# globally needed images
%w{ images/joe.png images/h1-underline.gif }.each do |image|
  uploader.copy_in(image)  
end

# and the stylesheets
Dir['css/*.css'].each do |css|
  uploader.copy_in(css)
end

uploader.svn_add_force
uploader.commit("Add extracts for #{archive}")
uploader.sync


