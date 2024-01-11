# -*- coding: utf-8 -*-

EBOOKS = [ :pdf ] unless defined?(EBOOKS)
ebook_targets = EBOOKS.map do |format| 
  case format.to_s
  when "pdf"
    "book-screen.pdf"
  else
    "book.#{format}"
  end
end

published_ebook_files = []

ebook_targets.each do |src|
  dest = File.join(PDF_DIR, src.sub(/book(-screen)?/, "#{BOOK_CODE}-p-00"))
  published_ebook_files << dest
  file(dest => src) { cp src, dest, :verbose => true }
end

# ------------------------------------------------
desc "Build all supported ebook formats (#{ebook_targets.join(', ')} for this book)"
# ------------------------------------------------
task :ebooks => ebook_targets do
  puts "\n\nMade: #{ebook_targets.join(', ')}"
end

namespace "publish" do
  # ------------------------------------------------
  desc "Publish ebooks by copying them to the PDFs directory"
  # ------------------------------------------------
  task :ebooks => [ :clean, :update_svn ].concat(published_ebook_files) do
    Dir.chdir(PDF_DIR) do
      sh "svn up", :verbose => true
      sh "svn add --force #{BOOK_CODE}*", :verbose => true
      sh "svn commit -m 'Releasing #{BOOK_CODE}'", :verbose => true
      sh "rake sync", :verbose => true
    end
  end
  
  # ------------------------------------------------
  desc "Push a new beta, including tbe ebooks, code, and the POD (is appropriate)"
  # ------------------------------------------------ 
  task :all =>  %w{ code:publish code:upload publish:ebooks } do
    if File.exist?("BETA_ON_PAPER")
      sh "rake pod:create"
      sh "rake pod:upload"
    end
    puts "\n\n#{BOOK_CODE} published"
  end
end

task :update_svn do
  Dir.chdir(PDF_DIR) do
    sh "svn up", :verbose => true
  end
end

