# ebook support stuff
EMBEDCODEPNG      = File.join(COMMON, 'bin/code2png.rb')
BIBEXTRACT        = File.join(COMMON, 'bin/bibextract.rb')
SPLIT_SINGLE_HTML = File.join(COMMON, 'bin/split.rb')

CONVERT_IMAGES  = File.join(COMMON, "bin/create_images_for_xhtml.rb")

#EPUBCHECK_JAR   = File.join(COMMON,
#                            "ThirdPartyTools/epubcheck-4.0.0-alpha11/epubcheck.jar")

EPUBCHECK_JAR   = File.join(COMMON,
                            "ThirdPartyTools/epubcheck-4.2.6/epubcheck.jar")
HTML2MOBI       = File.join(COMMON,
                            "ThirdPartyTools/mobiperl-0.0.41/html2mobi")

FONTS_DIR		= File.join(COMMON, 'fonts')
EXTRA_FONTS_DIR		= File.join(COMMON, 'extra_fonts')

HTML_XSL        = File.join(COMMON, 'xml/ppb2html.xsl')
EPUB_XSL        = File.join(COMMON, 'xml/ppb2epub.xsl')
MOBI_XSL        = File.join(COMMON, 'xml/ppb2mobi.xsl')

EPUB_DIR       = "epub-book"
HTML_DIR       = "html-book"
MOBI_DIR       = "mobi-book"
MOBI_CODE_IMAGES_DIR = File.join(MOBI_DIR, "images/code")


templates = File.join(COMMON, "templates")
EPUB_TEMPLATE_DIR = File.join(templates, "epub_template")
HTML_TEMPLATE_DIR = File.join(templates, "html_template")
MOBI_TEMPLATE_DIR = File.join(templates, "mobi_template")

# This is where the PDFs we sell life (/Bookshelf/PDFS)
PDF_DIR = File.expand_path("../../PDFS", TOP_DIR)


# =========================================================
# = Files and directories in the Book's tree (not PPBook) =
# =========================================================

LOCAL_EPUB_XSL = "local/xml/ppb2epub.xsl"
LOCAL_HTML_XSL = "local/tex/ppb2html.xsl"
