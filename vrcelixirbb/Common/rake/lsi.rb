## encoding: utf-8

# handle the LSI creation and upload
#
# we're in Shared/, not PPStuff, because this isn't accessible to
# authors

namespace :lsi do

  task :setup do
    @isbn_tag="isbn13"
    if @use_hardcover_isbn
      @isbn_tag="isbn13-hardcover"
    end
    info = File.read("../bookinfo.pml")
    isbn = if info =~ /<#{Regexp.quote(@isbn_tag)}>(.*?)<\/#{Regexp.quote(@isbn_tag)}>/
             $1.tr "-", ""
           else
             raise "Can't find ISBN tag #{@isbn_tag} in bookinfo"
           end

    @target_name = "#{isbn}_print.pdf"
  end

  desc "build a PDF in the correct format for LSI printing"
  task :create => ["lsi:setup", :paper] do
    cp "book-paper.pdf", @target_name
  end

  desc "build and upload a POD book"
  task :upload => ["lsi:setup", :create] do
    upload_file(@target_name, @target_name)
  end

  desc "build and upload a POD book (hardcover/casebound)"
  task :upload_hardcover => [:use_hardcover, "lsi:setup", :create] do
    upload_file(@target_name, @target_name)
  end  

  task :use_hardcover do
    @use_hardcover_isbn = true
  end

  private

  def upload_file(src, dest)
    sh %{ftp -u "ftp://ormdd_pragmatic@ftp.oreilly.com/" #{src.inspect}}
  end

end
