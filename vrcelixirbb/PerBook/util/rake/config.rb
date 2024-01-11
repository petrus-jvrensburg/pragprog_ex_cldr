# -*- coding: utf-8 -*-
# ===========================================================
# = Parameters that can be overridden from the environment  =
# ===========================================================

# Convert /Users/Dave/BS2/titles/FDSTR/Book to 'fdstr'
# TODO: have this in just one place
BOOK_CODE = File.basename(File.dirname(Dir.pwd)).downcase

# Where to find the Sites/ directory on the local machine
PP_SITE_DIR = ENV['PP_SITE_DIR'] || File.expand_path("../../../../Work/Sites")

# The book's own directory (which is where the Rakefile is)
BOOK_DIR = Dir.pwd

JAVA_HOME = ENV['JAVA_HOME'] or fail("The JAVA_HOME environment variable is not set")
XEP_HOME  = File.expand_path("../../../Common/ThirdPartyTools/XEP", File.dirname(__FILE__))

# ======================================
# = Files and directories under PPBook =
# ======================================
TOP_DIR        = File.expand_path("..", BOOK_DIR)

PERBOOK        = File.join(TOP_DIR,  "PerBook")
COMMON         = File.join(TOP_DIR,  "Common")

BIB_DIR        = File.join(PERBOOK,  "bibliography")
UTIL_DIR       = File.join(PERBOOK,  'util')
BIBTOOLS_DIR   = File.join(UTIL_DIR, 'bibtools')
BIN_DIR        = File.join(UTIL_DIR, 'bin')
XML_DIR        = File.join(UTIL_DIR, 'xml')
COMMON_XML_DIR = File.join(COMMON, 'xml')
FO_DIR         = File.join(XML_DIR,  'fo')
TARGETS_DIR    = File.join(FO_DIR,   '_targets')

PUBLISH_CODE    = File.join(BIN_DIR, 'publish_code.rb')
UPLOAD_CODE     = File.join(BIN_DIR, 'upload_code.rb')
#UPLOAD_EXTRACTS = File.join(BIN_DIR, 'upload_extracts.rb')
PAD_XEP              = File.join(BIN_DIR, 'pad-xep.rb')
FIX_XREFS_IN_EXTRACT = File.join(BIN_DIR, 'fix_xrefs_in_extract.rb')
PREFLIGHT_IMAGES     = File.join(BIN_DIR, "preflight_images.rb")
OTHER_FO_FILES       = Dir.glob(File.join(FO_DIR, '*.xsl'))
BUILD_INDEX          = File.join(UTIL_DIR, "indextools/build_index.rb")
STATS_COLLECTOR      = File.join(UTIL_DIR, "stats/collector.rb")
PREPROCESSORS        = File.join(UTIL_DIR, "bin/preprocess")
PML_CODE             = File.join(PREPROCESSORS, "highlight/lib/pml_code.rb")
ROUGE_CODE           = File.join(PREPROCESSORS, "rouge_code/lib/rouge_code.rb")


CREATE_EXTRACT_FOS   = File.join(FO_DIR, "extract_fo.xsl")
CREATE_EXTRACT_EPUBS = File.join(COMMON, "xml/epub/extract_epub.xsl")
CREATE_EXTRACT_MOBIS = File.join(COMMON, "xml/mobi/extract_mobi.xsl")

REMOVE_INDEX_XSL     = File.join(XML_DIR, "remove-indexing.xsl")

#Module.constants.each do |c|
#  v = Module.const_get c
#  if v =~ /_lab/
#    printf "%20s %s\n", c, v
#  end
#end

task :tidy => [ :pdf_tidy, :epub_tidy, :local_tidy ]


SAXON_DIR = File.join(COMMON, "ThirdPartyTools", "saxon", "SaxonHE9-6-0-8J")


VALIDATOR_CLASSPATH = File.join(COMMON, "bin", "pml_validator")

JRUBY_DIR = File.join(COMMON, "ThirdPartyTools", "jruby-1.7.22")

jruby = File.join(JRUBY_DIR, "bin", "jruby")
if RUBY_PLATFORM =~ /mswin32/
  jruby << ".bat"
end


if jruby =~ /\s/
  JRUBY = %{"#{jruby}"}
else
  JRUBY = jruby
end

CLEANUP          =  %{ #{JRUBY} "#{BIN_DIR}/tidyop.rb"}
CLEANUP_QUIET    =  %{ #{JRUBY} "#{BIN_DIR}/tidyop.rb" --quiet}

# This is a hack—We want to use Nokogiri, but if you're using rvm, it sets GEM_HOME
# which means that jruby will load from your mri version of Nokogiri. So, we'll add Nokogiri's
# gem directly to our include path, and bypass gems altogther

NOKOGIRI_DIR = File.join(JRUBY_DIR, "lib/ruby/gems/1.8/gems/nokogiri-1.5.0-java/lib")

# Same for CODERAY, used by the highlighting

CODERAY_DIR  = File.join(JRUBY_DIR, "lib/ruby/gems/1.8/gems/coderay-0.9.7/lib")


CHECK_URLS          = File.join(COMMON, "bin", "native_url_validator.rb")


GS = File.directory?("/usr") ? "gs" : "gswin32c"



#IMAGES =	FileList['images/**/*.eps*'].ext("png")

# ============================
# = Configuration parameters =
# ============================

#EMBED_SKIP_LEADING = "code/"

AUTHOR_BOOK_FORMATS = [ "book.pdf" ] unless defined?(AUTHOR_BOOK_FORMATS)

