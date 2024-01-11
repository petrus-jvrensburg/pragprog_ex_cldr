# -*- coding: utf-8 -*-


# ------------------------------------------------
desc "Build the book in mobi format"
# ------------------------------------------------
task :mobi => "book.mobi" do
  puts_in_bold "\nThe book is in book.mobi\n"
end




rule ".mobi" => [ '.epub' ] do |t|
  puts_in_bold "Converting to mobi format..."

  sh "kindlegen #{t.source} #{ ENV['VERBOSE'] && '-verbose'}"

  # puts "Creating mobi with the ad page."
  # params['adpage'] = 'yes'
  # 
  # Dir.chdir MOBI_DIR do
  #   xslt('ppb2mobi.xsl', File.join('..', t.source), params)
  # end
  # 
  # Dir.chdir MOBI_DIR do
  #   sh "kindlegen content.opf -o book2.mobi #{ ENV['VERBOSE'] && '-verbose'}"
  #   mv "book2.mobi", "../book2.mobi"
  # end
end

# file MOBI_DIR do
#   tidy_ebook_directory(MOBI_DIR, MOBI_TEMPLATE_DIR)
# end
