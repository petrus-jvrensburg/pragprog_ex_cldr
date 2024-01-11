# encoding: utf-8

# Build the PDF from an XML file using fo
#
# Use either
#
#     rake paper
# or
#     rake screen

require 'helpers'


if ENV["TYPE"]
  STDERR.puts %{
    It looks like you've set TYPE= in your environment. That's the old
    way of building ebooks. In the groovy new world,  use

       rake  paper | screen | epub | mobi | sitb

    Use "rake -T" for a full list of tasks

   }
  exit 1
end

def fo_dependencies(base, target, options={})
  deps = [ base ]
  deps << "bib_extract.xml" unless options[:omit_bib]
  deps << find_local_or_shared("ppb2fo-#{target}.xsl")
  deps.concat(OTHER_FO_FILES)
end



desc "Create a PDF suitable for a paper book"
task :paper => %w{ book-paper.pdf } do
  puts_in_bold "\nThe book is in book-paper.pdf\n"
end


desc "Create a PDF suitable for online reading"
task :screen => 'book-screen.pdf' do
  puts_in_bold "\nThe book is in book-screen.pdf\n"
end

desc "Create a PDF of chapters set to solo."
task :chapter => %w{ clean set-chapter-flag book-screen.pdf } do
  puts_in_bold "\nThe chapter is in book-screen.pdf\n"
end

desc "Create extracts"
task :extracts => %w{ clean set-extract-flag book-screen.fo } do
  xslt(CREATE_EXTRACT_FOS, "book-screen.fo")
  pdfs = []
  Dir.glob("extract-*fo").each do |fo|
    pdf = fo.sub(/\.fo$/, ".pdf")
    fo_to_pdf(fo, pdf)
    pdfs << pdf
  end
  puts_in_bold "Output is in #{pdfs.join(', ')}"
end

desc "Create a PDF suitable for a Amazon SITB book"
task :sitb => %w{ clean set-sitb-flag book-paper.pdf } do
  new_filename = File.read('isbn.txt')
  File.rename('book-paper.pdf', new_filename)
  File.delete('isbn.txt')
  puts_in_bold "\nThe SITB book is in #{new_filename}.\n"
end

desc "Update covers"
task :update_covers do
  raise "Set your PPCOVERS variable" unless ENV["PPCOVERS"]
  Dir.chdir ENV["PPCOVERS"] do
    puts_in_bold "\nUpdating covers...\n"
    svn "up"
  end
end

# this shells out to ruby in order to recover the GEM environment
desc "Update the backmatter ads"
task :update_ads => :update_covers do
  Dir.chdir "../Common/backmatter" do
    system_ruby = `which ruby`.chomp  # use the system ruby, not jruby because jruby isn't handling quotes right.
    # ruby "update_ads.rb"
    safe_sh "#{system_ruby} update_ads.rb"
  end
end

task :final => %w{ update_ads clean paper } do
end

rule ".pdf" => ".fo" do |t|
  options = {}
  convert_images_for_press if t.name == "book-paper.pdf"
  fo_to_pdf(t.source, t.name, options)
  if t.name == "book-screen.pdf" && defined?(COMPRESS_PDF) && COMPRESS_PDF
    puts_in_bold "Compressing book-screen.pdf"
    mv "book-screen.pdf", "tmp.pdf"
    args = %w{-q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true
              -dSubsetFonts=true -dColorImageDownsampleType=/Subsample -dColorImageResolution=300
              -dGrayImageDownsampleType=/Subsample -dGrayImageResolution=300
              -dMonoImageDownsampleType=/Subsample -dMonoImageResolution=300
              -dPrinted=false
              -sOutputFile=book-screen.pdf tmp.pdf}.join(" ")
    safe_sh(%{#{GS} #{args}})
    rm "tmp.pdf"
  end
  if t.name == "book-screen.pdf" && defined?(SUPERCOMPRESS_PDF) && SUPERCOMPRESS_PDF
    puts_in_bold "Supercompressing book-screen.pdf"
    mv "book-screen.pdf", "tmp.pdf"
    args = %w{-q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dEmbedAllFonts=true
              -dSubsetFonts=true -dColorImageDownsampleType=/Subsample -dColorImageResolution=200
              -dGrayImageDownsampleType=/Subsample -dGrayImageResolution=200
              -dMonoImageDownsampleType=/Subsample -dMonoImageResolution=200
              -dPrinted=false
			  -r300dpi
              -sOutputFile=book-screen.pdf tmp.pdf}.join(" ")
    safe_sh(%{#{GS} #{args}})
    rm "tmp.pdf"
  end
end

task('book-paper.fo'  => fo_dependencies('book.xml', 'paper')) do |t|
  if defined?(PRINT_COLOR) && PRINT_COLOR.to_s == "color"
    BUILD_OPTIONS["color"] = "yes"
  end
  xml_to_fo('paper', 'book.xml', t.name)
end

task('book-screen.fo' => fo_dependencies('book.xml', 'screen')) do |t|
  xml_to_fo('screen', 'book.xml', t.name)
end

# legacy for the continuous build system
task "book.pdf" => [ :clean, :screen ] do
  cp "book-screen.pdf", "book.pdf"
end

#rule(".fo" => fo_dependencies('.xml', 'paper')) { |t| xml_to_fo('paper', t.source, t.name) }

FileList.new('*.pml').ext.each do |file|
  next if file == "book"
  task("#{file}.fo" => fo_dependencies("#{file}.xml", 'screen', :omit_bib => true)) do |t|
    xml_to_fo('screen', "#{file}.xml", t.name)
  end
end

task 'pdf_tidy' do
  files = FileList.new('*.fo', '*.xml', "xslt*.log", "book.xep").existing
  rm(files, :force => true) unless files.empty?

  unless ENV["DAVE_CHEAT"]
    %w{ images/_pragprog _bw }.each do |dir|
      rm_rf(dir) if File.directory?(dir)
    end
  end
end


def xml_to_fo(target, source, fo_name)
  puts_in_bold "Converting into printable form…"
  extra_args = { :to => fo_name }.merge(BUILD_OPTIONS)
  if defined?(PRINT_COLOR) && PRINT_COLOR.to_s == "color" && target == 'paper'
    target = 'paper-color'
  end
  xslt("ppb2fo-#{target}.xsl", source, extra_args)
end

def fo_to_pdf(fo, pdf, options={})

  puts_in_bold "Generating PDF…"
  classpath = [
    "#{XEP_HOME}/lib/xep.jar",
    "#{XEP_HOME}/lib/saxon.jar",
    "#{XEP_HOME}/lib/xt.jar"].join(File::PATH_SEPARATOR)

  quiet = ENV["VERBOSE"] ? "" : "-quiet "

  xep_cmd =
     %{"#{File.join(JAVA_HOME, 'bin', 'java')}" -Xmx784m  -cp "#{classpath}" } +
     %{-Dcom.renderx.xep.CONFIG="#{XEP_HOME}/xep.xml" } +
     %{com.renderx.xep.XSLDriver #{quiet} }

  # Need to add blank pages up to a multiple of 8 if we're targeting print
  if options[:pad]
    safe_sh %{#{xep_cmd} -fo "#{fo}" -xep book.xep}
    safe_sh "ruby #{PAD_XEP} #{options[:pad]} book.xep"
    safe_sh %{#{xep_cmd} -xep book.xep -pdf "#{pdf}"}
  else
    safe_sh %{#{xep_cmd} -fo "#{fo}" -pdf "#{pdf}"}
  end

end


def convert_images_for_press

#  return if ENV["DAVE_CHEAT"]

  puts_in_bold "Converting images"

  il = File.open("image_list") or fail("Can't find image_list")
  already_done = {}

  il.each do |line|
    from, to, scale = line.chomp.split(/[\t@]/)
    unless already_done[from]
      convert_one_image(from, to, scale)
      already_done[from] = to
    end
  end
end

def convert_one_image(from, to, scale)
  puts from

  dir = File.dirname(to)
  mkdir_p(dir) unless File.directory?(dir)


  return if File.exist?(to) && File.mtime(from) < File.mtime(to)

  if defined?(PRINT_COLOR) && PRINT_COLOR.to_s == "color"
     cp from, to
  else
    case from
      when /\.(jpg|jpeg|png|gif|tif)$/i
        safe_sh(%{convert "#{from}" -channel RGBA -colorspace gray "#{to}"})
      when /\.pdf$/i
 	    safe_sh(%{#{GS} -q -o "#{to}" -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress             -dHaveTransparency=false -sColorConversionStrategy=Gray } +
        %{-sColorConversionStrategyForImages=Gray -sProcessColorModel=DeviceGray -dCompatibilityLevel=1.4  -dPDFUseOldCMS=true } +
         %{-dNOPAUSE -dBATCH "#{from}"})
      when /\.svg$/i
        cp from, to
      else
        fail "Don't know how to convert the image #{from}"
      end
  end

 end
