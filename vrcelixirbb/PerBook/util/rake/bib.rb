# encoding: utf-8

# Create the bib_extract.xml file by looking for all the cites in the
# book and extracting and reformating entries for the main bibliography file

BIBLIOGRAPHY  = [
  File.join(BIB_DIR, "bibliography.xml"),
  File.join(BIB_DIR, "pp-books.xml")
]

if defined?(EXTRA_BIBLIOGRAPHIES)
  # For some reason, Array() doesn't work in JRuby
  extra = EXTRA_BIBLIOGRAPHIES
  extra = [ extra ] unless extra.respond_to?(:each)
  BIBLIOGRAPHY.concat(extra)
end


BIB_EXTRACTER = File.join(BIBTOOLS_DIR, "generate_bibliography.rb")

LOCAL_TIDY_LIST << "bib_extract.xml"

file "bib_extract.xml" => [ "book.xml", BIBLIOGRAPHY, BIB_EXTRACTER ].flatten do
  puts_in_bold "Building bibliography…"
  bibs = BIBLIOGRAPHY.map {|b| %("#{b}")}.join(" ")
  safe_sh %{#{JRUBY} -I "#{NOKOGIRI_DIR}" "#{BIB_EXTRACTER}" <book.xml #{bibs} >bib_extract.xml}
end
