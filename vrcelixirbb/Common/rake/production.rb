# encoding: utf-8

# Rake tasks for Dave and Andy

# We're run in the book's Book/ directory. We'll often need the higher level directory
# (so if we're run in trevan/Book, we want to know about trevan/
#

BOOKSHELF = "https://svn.pragprog.com/Bookshelf"

BOOK_TOP = BOOK_DIR.dup
fail "Must be run in the Book/ directory" unless BOOK_TOP.sub!(%r{/Book$}, '')

namespace :production do

#  desc "Update the page count in pip"
#  task :pip_page_count do # => [:paper] do
#    pages = `gs  -q -dNODISPLAY  -c "(book-paper.pdf) (r) file runpdfbegin pdfpagecount = #quit"`.chomp
#    if $?.success?
#       cmd = %{ssh prod 'cd apps/admin/current && } +
#        %{RAILS_ENV=production ~/.rbenv/shims/ruby script/rails runner } +
#        %{"CmdLine::UpdatePageCount.run(%{#{BOOK_CODE}}, #{pages})"'}
#      sh cmd
#      if $?.success?
#        puts "Page count set to #{pages} in pip"
#      else
#        puts "Update failed"
#      end
#    else
#      puts "Couldn't determinate page count"
#    end
#
#  end

  # # #####################################################
  # desc "validate that a book is ready to enter production"
  # # #####################################################

  # task :validate => :clean do

  #   puts "\n\nDoing a clean build… (This is silent—be patient)\n\n"

  #   sh "rake book.dvi >/tmp/build.log 2>&1" do
  #     puts "The build currently fails. I guess that means it isn't ready for production"
  #     exit 1
  #   end

  #   sh "#{PRODUCTION_VALIDATE} </tmp/build.log"
  # end



  if BOOK_TOP =~ %r{/titles/}

    ################################################################################
    desc "Remove the svn:external links from a title and move it into production"
    ################################################################################

    task :move_to_production do # => :validate do

      source_dir = File.basename(BOOK_TOP)

      unless NAME == source_dir
        fail "The name of this directory (#{source_dir}) is not the same as the name in the Rakefile (#{NAME})"
      end

      Dir.chdir(BOOK_TOP) do

        svn "--version"

        svn "up"

        %w{ . PerBook Common PPStuff }.each do |dir|
          target_dir = File.join(BOOK_TOP, dir)
          if File.directory?(dir)
            puts "Save away #{dir}"
            svn %{commit -m "Save away prior to cutting the cord" "#{target_dir}"}
          end
        end


        # Remove all externals from Book directory. Some books no longer have externals,
        # so this may fail.
        svn "propdel svn:externals Book", :err_ok => true

        svn "propget svn:externals . > _props_"
        externals = File.read("_props_")
        externals.sub!(/PerBook.*\n/, '')

        File.open("_props_", "w") {|f| f.puts externals }

        svn %{propset --file _props_ svn:externals .}

        rm_f "_props_"

        svn "up"
        svn "commit -m 'resync to get directory current'"

        rm_rf %w{PerBook  Book/AuthorInfo}
      end

      source = File.join(BOOKSHELF, 'titles',     NAME)
      target = File.join(BOOKSHELF, 'published', NAME)

      svn "mv -m 'create production version' #{source} #{target}"

      Dir.chdir "../../../published" do
        svn "up #{NAME}"
      end

      Dir.chdir File.join("../../../published", NAME) do
        ln_s "../../titles/_M2/PerBook", "PerBook"
        svn "add PerBook"
        svn "commit -m 'Add symbolic link to shared PerBook'"
      end

      puts "\n\nThis book has been moved into production. Once you've confirmed all is ok"
      puts "you can remove the (now orphaned) directory #{BOOK_TOP}"
      puts "\n***** RIGHT NOW, YOU ARE STILL IN THE OLD DIRECTORY *****\n\n"
      puts "You need to cd ../../../published/#{NAME} to get where you want"
    end

  end
end


