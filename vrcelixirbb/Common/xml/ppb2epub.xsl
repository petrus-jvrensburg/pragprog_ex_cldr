<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:redirect="http://xml.apache.org/xalan/redirect"
    version="2.0"
    >
  <!-- remove for Saxon (consistency issue)
       <xsl:output indent="no"/>-->
  <xsl:preserve-space elements="codeline"/>
  <xsl:output indent="no"/>

  <xsl:param name="bookcode">unset</xsl:param>
  <xsl:param name="year">1999</xsl:param>
  <xsl:param name="in.dir">!!missing!!</xsl:param>
  <xsl:param name="force.jpg.images"/>
  <xsl:param name="format">epub</xsl:param>
  <xsl:param name="extracts"/>
  <xsl:param name="cjk">no</xsl:param>
  <xsl:param name="unicode">no</xsl:param>
  <xsl:param name="dtm.modified">!!missing!!</xsl:param>


  <xsl:param name="recipetitle">
    <xsl:choose>
      <xsl:when test="//book/options/recipetitle">
        <xsl:value-of select="//book/options/recipetitle/@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Recipe</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="bib" select="document('../../Book/bib_extract.xml')/bib-extract"/>

  <xsl:include href="lib/pml_only_tags.xsl"/>
  <xsl:include href="lib/string-replace.xsl"/>
  <xsl:include href="lib/common.xsl"/>
  <xsl:include href="lib/xrefs.xsl"/>

  <xsl:include href="epub/backmatter.xsl"/>
  <xsl:include href="epub/backpage.xsl"/>
  <xsl:include href="epub/bibliography.xsl"/>
  <xsl:include href="epub/blocks.xsl"/>
  <xsl:include href="epub/characters.xsl"/>
  <xsl:include href="epub/code.xsl"/>
  <xsl:include href="epub/footnotes.xsl"/>
  <xsl:include href="epub/front-matter.xsl"/>
  <xsl:include href="epub/inline.xsl"/>
  <xsl:include href="epub/kseq.xsl"/>
  <xsl:include href="epub/lists.xsl"/>
  <xsl:include href="epub/praisepage.xsl"/>
  <xsl:include href="epub/sectioning.xsl"/>
  <xsl:include href="epub/tables.xsl"/>
  <xsl:include href="epub/toc.xsl"/>
  <xsl:include href="epub/extract.xsl"/>
  <xsl:include href="pocket-guide-ops.xsl"/>

  <xsl:template match="if">
    <xsl:if test="@target='epub'">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="pdf">
  </xsl:template>


  <xsl:template match="tablestyle"/>



  <xsl:template name="extra-headers"/>

  <!-- overridden in local/ -->
  <xsl:template name="extra-opf-images"/>

  <xsl:template name="opf-image">
    <xsl:param name="file"/>
    <xsl:param name="id"/>
    <xsl:element name="item">
      <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$file"/></xsl:attribute>
      <xsl:attribute name="media-type">image/jpeg</xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template name="before-chapter-hook">
  </xsl:template>


  <xsl:template match="/book">
    <xsl:call-template name="create-content.opf"/>
    <xsl:call-template name="create-toc.ncx"/>
<!--    <xsl:call-template name="create-toc.xhtml"/> -->
    <xsl:call-template name="create-book.html"/>
    <xsl:call-template name="build-image-list"/>
  </xsl:template>

  <xsl:template name="create-toc.xhtml">
    <xsl:result-document href="{'toc.xhtml'}"
                         indent="yes"
                         method="xml">

      <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
        <head>
          <meta charset="utf-8"/>
        </head>
        <body epub:type="frontmatter">
          <xsl:call-template name="generate-toc"/>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="create-content.opf">
    <xsl:result-document href="{'content.opf'}"
                         indent="yes"
                         method="xml">
      <package version="3.0"
	       unique-identifier="PragmaticBook"
	       xmlns="http://www.idpf.org/2007/opf">
	<metadata
	    xmlns:opf="http://www.idpf.org/2007/opf"
	    xmlns:dc="http://purl.org/dc/elements/1.1/">
	  <dc:language>
	    <xsl:text>en</xsl:text>
	  </dc:language>

	  <dc:title>
	    <xsl:apply-templates select="bookinfo/booktitle" mode="plain-text"/>
	  </dc:title>

	  <xsl:apply-templates select="bookinfo/authors" mode="opf"/>

	  <dc:publisher>
	    <xsl:text>The Pragmatic Bookshelf, LLC</xsl:text>
	  </dc:publisher>

	  <dc:rights>
	    <xsl:apply-templates select="bookinfo/copyright"/>
	  </dc:rights>

          <dc:subject>Pragmatic Bookshelf</dc:subject>

          <dc:identifier id="PragmaticBook">
            <xsl:apply-templates select="bookinfo/isbn13"/>
	  </dc:identifier>
          <meta name="cover" content="cover-image" />
          <meta content="cover-image"  name="cover"/>
          <meta property="dcterms:modified">2011-01-01T12:00:00Z</meta>

	</metadata>
	<manifest>
	  <item id="bookshelf-css"
		href="css/bookshelf.css"
		media-type="text/css"/>

          <item id="book_local-css"
		href="css/book_local.css"
		media-type="text/css"/>

          <item id="cover"
		href="cover.xhtml"
                media-type="application/xhtml+xml"
                />

          <!-- <item id="toc" -->
          <!--       href="toc.xhtml" -->
          <!--       media-type="application/xhtml+xml" -->
          <!--       properties="nav"/> -->

          <item id="UbuntuSans"
                href="fonts/Ubuntu-M.ttf"
                media-type="application/vnd.ms-opentype"/>

          <item id="UbuntuSansBold"
                href="fonts/Ubuntu-B.ttf"
                media-type="application/vnd.ms-opentype"/>

          <item id="UbuntuSansOblique"
                href="fonts/Ubuntu-MI.ttf"
                media-type="application/vnd.ms-opentype"/>

          <item id="UbuntuSansBoldOblique"
                href="fonts/Ubuntu-BI.ttf"
                media-type="application/vnd.ms-opentype"/>



	  <item id="UbuntuMono"
                href="fonts/UbuntuMono-R.ttf"
                media-type="application/vnd.ms-opentype"/>

          <item id="UbuntuMonoOblique"
                href="fonts/UbuntuMono-RI.ttf"
                media-type="application/vnd.ms-opentype"/>

          <item id="UbuntuMonoBold"
                href="fonts/UbuntuMono-B.ttf"
                media-type="application/vnd.ms-opentype"/>

          <item id="UbuntuMonoBoldOblique"
                href="fonts/UbuntuMono-BI.ttf"
                media-type="application/vnd.ms-opentype"/>


          <item id="UbuntuFontCopyright"
                href="fonts/copyright.txt"
                media-type="text/plain"/>
          
          <item id="UbuntuFontLicence"
                href="fonts/LICENCE.txt"
                media-type="text/plain"/>
          
          <!-- <item id="DroidSerif" -->
	  <!--       href="fonts/DroidSerif.woff" -->
          <!--       media-type="application/vnd.ms-opentype"/> -->
          <!--  -->
	  <!-- <item id="DroidSerif-Italic" -->
	  <!--       href="fonts/DroidSerif-Italic.woff" -->
          <!--       media-type="application/vnd.ms-opentype"/> -->
          <!--  -->
	  <!-- <item id="DroidSerifBold" -->
	  <!--       href="fonts/DroidSerif-Bold.woff" -->
          <!--       media-type="application/vnd.ms-opentype"/> -->
          <!--  -->
	  <!-- <item id="DroidSerif-BoldItalic" -->
	  <!--       href="fonts/DroidSerif-BoldItalic.woff" -->
          <!--       media-type="application/font-woff"/> -->

	  <xsl:if test="$cjk = 'yes'">
	    <item id="Mincho"
	          href="fonts/mplus-1c-regular.ttf"
	          media-type="application/font-woff"/>
	  </xsl:if>

	  <xsl:if test="$unicode = 'yes'">
	    <item id="Quivira"
	          href="fonts/Quivira.ttf"
	          media-type="application/font-woff"/>
	  </xsl:if>

	  <item id="cover-image"
		href="images/cover.jpg"
		media-type="image/jpeg"
                properties="cover-image"/>

	  <item id="apple-image"
	        href="images/apple-logo-black.jpg"
		media-type="image/jpeg"/>

	  <item id="h1-underline"
	        href="images/h1-underline.gif"
		media-type="image/gif"/>

	  <item id="joe-image"
		href="images/joe.jpg"
		media-type="image/jpeg"/>

	  <item id="wiggly-image"
		href="images/WigglyRoad.jpg"
		media-type="image/jpeg"/>

	  <item id="ncx"
		href="toc.ncx"
		media-type="application/x-dtbncx+xml"/>

	  <xsl:call-template name="extra-opf-images"/>

	  <html-items/>

	  <!-- now add the images. the magic condiion eliminates duplicates -->

	  <xsl:for-each select="//imagedata[not(@fileref=following::imagedata/@fileref)]">
	    <xsl:if test="not(contains(@fileref, 'joe.eps') or contains(@fileref, 'WigglyRoad'))">
	      <xsl:call-template name="create-image-item">
		<xsl:with-param name="image">
		  <xsl:call-template name="get-image-name"/>
		</xsl:with-param>
	      </xsl:call-template>
	    </xsl:if>
	  </xsl:for-each>

          <xsl:for-each select="//inlineimage[not(@fileref=following::inlineimage/@fileref)]">
            <xsl:call-template name="create-image-item">
              <xsl:with-param name="image">
                <xsl:call-template name="get-image-name"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>

          <!-- Add the graphics for ad covers -->

	  <xsl:for-each select="//adpage">
	    <!-- SAXON change: <xsl:for-each select="str:tokenize(@codes, ' ')"> -->
	    <xsl:for-each select="tokenize(@codes, ' ')">
	      <xsl:variable name="code" select="."/>
	      <item>
		<xsl:attribute name="id">
		  <xsl:text>cover-</xsl:text>
		  <xsl:value-of select="$code"/>
		</xsl:attribute>
		<xsl:variable name="image">
		  <xsl:text>images/_covers/</xsl:text>
		  <xsl:value-of select="$code"/>
		  <xsl:text>.jpg</xsl:text>
		</xsl:variable>
		<xsl:attribute name="href">
		  <xsl:value-of select="$image"/>
		</xsl:attribute>
		<xsl:attribute name="media-type">
		  <xsl:text>image/jpeg</xsl:text>
		</xsl:attribute>
	      </item>
	    </xsl:for-each>
	  </xsl:for-each>
          <!-- Add the headshots for "said" -->
          <xsl:for-each select="//said[not(@by=following::said/@by)]">
	    <item>
	      <xsl:attribute name="id">
		<xsl:text>said</xsl:text>
		<xsl:number format="1" count="said"
			    from="/" level="any"/>
	      </xsl:attribute>
	      <xsl:attribute name="href">
                <xsl:text>images/</xsl:text>
                <xsl:call-template name="name-to-headshot-name"/>
              </xsl:attribute>
	      <xsl:attribute name="media-type">
		<xsl:text>image/png</xsl:text>
	      </xsl:attribute>
	    </item>
          </xsl:for-each>
	</manifest>
	<spine toc="ncx">
	  <itemref idref="cover"/>
	  <spine-items/>
 	</spine>
	<guide>
          <reference type="cover" title="Cover" href="cover.xhtml" />
	</guide>
      </package>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="name-to-headshot-name">
    <xsl:text>headshots/</xsl:text>
    <xsl:value-of select="translate(@by, 'áéó', 'aeo')"/>
    <xsl:text>.png</xsl:text>
  </xsl:template>

  <xsl:template name="create-toc.ncx">
    <xsl:result-document href="{'toc.ncx'}">
      <ncx version="2005-1"
           xmlns="http://www.daisy.org/z3986/2005/ncx/">

	<head>
	  <meta name="dtb:uid">
	    <xsl:attribute name="content"><xsl:value-of select="bookinfo/isbn13"/></xsl:attribute>
	  </meta>
	  <meta name="dtb:depth" content="1"/>
	  <meta name="dtb:totalPageCount" content="0"/>
	  <meta name="dtb:maxPageNumber" content="0"/>
	</head>
	<docTitle>
	  <text>
	    <xsl:apply-templates select="/book/bookinfo/booktitle" mode="plain-text"/>
	  </text>
	</docTitle>
	<xsl:element name="navMap">
	  <!--
	      Filled in by Ruby
	  -->
	</xsl:element>
      </ncx>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="create-image-item">
    <xsl:param name="image"/>
    <item xmlns="http://www.idpf.org/2007/opf">
      <xsl:attribute name="id">
	<xsl:text>img</xsl:text>
        <xsl:number format="1" count="imagedata | inlineimage"
		    from="/" level="any"/>
	<xsl:if test="contains($image, '.svg')">
	  <xsl:text>s</xsl:text>
	</xsl:if>
      </xsl:attribute>
      <xsl:attribute name="href">
	<xsl:value-of select="$image"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
	<xsl:variable name="ext">
	  <xsl:value-of select="substring($image, string-length($image) - 2)"/>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="$ext = 'jpg'">
	    <xsl:text>image/jpeg</xsl:text>
	  </xsl:when>
	  <xsl:when test="$ext = 'jpeg'">
	    <xsl:text>image/jpeg</xsl:text>
	  </xsl:when>
	  <xsl:when test="$ext = 'svg'">
	    <xsl:text>image/svg+xml</xsl:text>
	  </xsl:when>
	  <xsl:when test="$ext = 'png'">
	    <xsl:text>image/png</xsl:text>
	  </xsl:when>
	  <xsl:when test="$ext = 'gif'">
	    <xsl:text>image/gif</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      Don't know mime type for <xsl:value-of select="$image"/>
	    </xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
    </item>
  </xsl:template>

  <xsl:template name="create-book.html">
    <xsl:result-document href="book.html" method="xhtml">
      <html>
        <head>
          <title>
	    <xsl:apply-templates select="bookinfo/booktitle" mode="plain-text"/>
	  </title>
	  <xsl:element name="link">
	    <xsl:attribute name="rel">stylesheet</xsl:attribute>
	    <xsl:attribute name="type">text/css</xsl:attribute>
	    <xsl:attribute name="href">css/bookshelf.css</xsl:attribute>
	  </xsl:element>
	  <xsl:element name="link">
	    <xsl:attribute name="rel">stylesheet</xsl:attribute>
	    <xsl:attribute name="type">text/css</xsl:attribute>
	    <xsl:attribute name="href">css/book_local.css</xsl:attribute>
	  </xsl:element>
	  <xsl:call-template name="extra-headers"/>
          <meta name="bookcode">
	    <xsl:attribute name="content">
	      <xsl:value-of select="//bookinfo/@code"/>
	    </xsl:attribute>
	  </meta>
	</head>
        <body>
          <xsl:choose>
	    <xsl:when test="$extracts = 'yes'">
	      <div class="extract-title">
		<xsl:apply-templates select="bookinfo" mode="toc"/>
	      </div>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="bookinfo" mode="toc"/>
            </xsl:otherwise>
	  </xsl:choose>

          <xsl:if test="frontmatter/dedication">
            <div class="dedication pp-chunk">
              <xsl:call-template name="do-dedication-page"/>
            </div>
          </xsl:if>

<!--
          <h1 class="table-of-contents">Table of Contents</h1>

	  <xsl:apply-templates select="frontmatter" mode="toc"/>
	  <xsl:apply-templates select="mainmatter" mode="toc"/>
-->

          <xsl:call-template name="generate-toc"/>

          <xsl:call-template name="add-copyright"/>

	  <xsl:apply-templates select="frontmatter | mainmatter | backmatter "/>

	</body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="booktitle" mode="plain-text">
    <xsl:apply-templates mode="plain-text"/>
  </xsl:template>

  <xsl:template match="booktitle/newline" mode="plain-text">
    <xsl:text>&#32;</xsl:text>
  </xsl:template>

  <!-- Report errors on all other tags... -->
  <xsl:template match="*">
    <xsl:message terminate="yes">
      <xsl:text>Missing template for </xsl:text><xsl:value-of select="local-name()"/>
      <xsl:value-of select=".."/>
    </xsl:message>
  </xsl:template>

  <xsl:template match="*" mode="ncx"/>

</xsl:stylesheet>
