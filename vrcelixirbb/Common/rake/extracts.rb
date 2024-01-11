
# =================
# Creating Extracts
# =================

namespace "extracts" do


  # ==========================================
  desc "Create local copies of extracts"
  # ==========================================
  task "create" do #=> [ 'book.html' ] do
    Dir.chdir HTML_DIR do
      chapters_to_extract = `grep -l 'ppextract="yes"' chap*html`.split
      if chapters_to_extract.empty?
        fail "No chapters have extracts available"
      end
      chapters_to_extract.each do |ch|
        extract_name = ch.sub(/\.html/, '-extract.html')
        xslt('html2extract.xsl', ch, :pipe => "ruby #{FIX_XREFS_IN_EXTRACT} #{ch} >#{extract_name}")
      end
    end
  end


# # ==========================================
# desc "Upload extracts to media.pragprog.com"
# # ==========================================
# task "upload" do
#   Dir.chdir HTML_DIR do
#     ruby "#{UPLOAD_EXTRACTS} #{BOOK_CODE} #{PP_SITE_DIR}"
#     upload_cmd = %{ssh prod 'cd apps/store/current && } +
#                    %{RAILS_ENV=production script/runner "CmdLine::UpdateToc.run(%{#{BOOK_CODE}})"'}
#     xslt("ppb2toc.xsl", "../book.cited-xml", "book-code" => BOOK_CODE, :pipe => upload_cmd)
#   end
# end

end

