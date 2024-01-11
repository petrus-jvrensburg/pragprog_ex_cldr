<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="2.0"
>

  <xsl:include href="../../titles/_MASTER/PPStuff/util/xml/string-replace.xsl"/>
  <xsl:include href="common.xsl"/>
  <xsl:include href="../../titles/_MASTER/PPStuff/util/xml/string-replace.xsl"/>
  
  <xsl:include href="xhtml-transforms.xsl"/>

  <xsl:param name="year">1999</xsl:param>

  <xsl:output method="html"/>



<!--
  <xsl:strip-space elements="*" />
  <xsl:preserve-space elements="codeline"/>
-->
  <xsl:template name="extra-headers">
    <link rel="stylesheet" type="text/css" href="css/html-only.css"/>
    <link rel="homepage" type="text/html">
      <xsl:attribute name="href">
	<xsl:text>https://pragprog.com/</xsl:text>
	<!--<xsl:value-of select="/book/bookinfo/backsheet/homepageurl"/>  -->
      </xsl:attribute>
    </link>
    <meta name="book-title">
      <xsl:attribute name="content">
	<xsl:value-of select="/book/bookinfo/booktitle"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="/book/bookinfo/booksubtitle"/>
      </xsl:attribute>
    </meta>
    <xsl:for-each select="/book/bookinfo/authors/person">
      <meta name="book-author">
	<xsl:attribute name="content">
	  <xsl:value-of select="name"/>
	</xsl:attribute>
      </meta>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="html-head">
    <xsl:param name="title"/>
	<head>
	  <meta charset="UTF-8"/>
	  <title>
	    <xsl:value-of select="$title"/>
	  </title>
	  <link rel="stylesheet" type="text/css" href="css/bookshelf.css" />
	  <xsl:call-template name="extra-headers"/>
	</head>
  </xsl:template>

  <xsl:template match="/book">
    <xsl:document method="html"  href="book.html"> 
      <html>
	<xsl:call-template name="html-head">
	  <xsl:with-param name="title">
	    <xsl:apply-templates select="bookinfo/booktitle"/>
	  </xsl:with-param>
	</xsl:call-template>
	<body>
	  <xsl:apply-templates select="bookinfo" mode="toc"/>
	  <div class="contents">
	    <h3>Table of Contents</h3>
	    <ul>
	      <xsl:apply-templates select="frontmatter" mode="toc"/>
	      <xsl:apply-templates select="mainmatter" mode="toc"/>
	    </ul>
	  </div>
	  <xsl:call-template name="add-copyright"/>
	</body>
      </html>
    </xsl:document>  

    <xsl:for-each select="//part|//chapter|//appendix|//contribution">
      <xsl:variable name="filename">
	<xsl:text>chap-</xsl:text>
        <xsl:number format="001" count="part|chapter|appendix|contribution" 
		    from="book" level="any"/>
	<xsl:text>.html</xsl:text>
      </xsl:variable>
      <xsl:document method="html" href="{$filename}"> 
	<html>
	  <xsl:call-template name="html-head">
	    <xsl:with-param name="title">
	      <xsl:apply-templates select="//bookinfo/booktitle"/>
	      <xsl:text>: </xsl:text>
	      <xsl:apply-templates select="title" mode="force"/>
	    </xsl:with-param>
	  </xsl:call-template>
	  <body>
	    <xsl:apply-templates select="."/>
	  </body>
	</html>
      </xsl:document>  
    </xsl:for-each>
    <xsl:call-template name="build-image-list"/>
   </xsl:template>

 <xsl:template match="*" mode="toc">
 </xsl:template>

  <xsl:template match="frontmatter" mode="toc">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>

  <xsl:template match="mainmatter" mode="toc">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>

<!-- remove match |contribution -->
  <xsl:template match="part|chapter|appendix" mode="toc">
    <li>
      <a>
	<xsl:attribute name="href">
	  <xsl:text>chap-</xsl:text>
	  <!-- remove count |contribution -->
          <xsl:number format="001" count="part|chapter|appendix" 
		      from="book" level="any"/>
	  <xsl:text>.html</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="target">
	  <xsl:text>chapter</xsl:text>
	</xsl:attribute>
	<xsl:apply-templates select="title" mode="force"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="bookinfo" mode="toc">
    <div class="bookinfo">
      <div class="booktitle">
	<xsl:apply-templates select="booktitle"/>
      </div>
      <div class="booksubtitle">
	<xsl:apply-templates select="booksubtitle"/>
      </div>
      <xsl:apply-templates select="authors"/>
    </div>
  </xsl:template>

  <xsl:template match="praisepage" mode="toc">
  </xsl:template>


  <!-- Authors are handled differently in OPS and HTML. In HTML, we add to the book -->

  <xsl:template match="authors">
    <div class="authors">
      <xsl:apply-templates mode="force"/>
    </div>
  </xsl:template>

 
  <xsl:template match="person" mode="force">
    <div class="author">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="name">
    <div class="authorname">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="affiliation">
    <div class="authoraffiliation">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="jobtitle"/>

  <xsl:template match="missing">
    <span class="missing">
      <xsl:text>Missing: </xsl:text>
      <xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template name="add-copyright">
    <div class="copyright">
      <xsl:text>Copyright &#169; </xsl:text>
      <xsl:value-of select="$year"/>
      <xsl:text>, The Pragmatic Bookshelf.</xsl:text>
    </div>
  </xsl:template>

  <xsl:template name="xxxasks">
    <xsl:param name="label"/>
    <xsl:param name="image"/>
    <div class="xxxsays">
      <xsl:call-template name="add-id"/>
      <div class="heading">
	<div class="persons-picture">
	  <img>
	    <xsl:attribute name="src">
	      <xsl:value-of select="$image"/>
	    </xsl:attribute>
	    <xsl:attribute name="alt">
	      <xsl:value-of select="$label"/>
	    </xsl:attribute>
	  </img>
	</div>
	<div class="label">
	  <xsl:value-of select="$label"/>
	</div>
	<div class="title">
	  <xsl:apply-templates select="./title" mode="force"/>
	</div>
      </div>

      <div class="body">
	<xsl:apply-templates/>
	<xsl:for-each select=".//footnote | .//footnoteref">
          <blockquote class="footnote">
	    <xsl:apply-templates/>
          </blockquote>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>


  <!-- Report errors on all other tags... -->
  <xsl:template match="*">
    <xsl:message>
      Unhandled tag: <xsl:value-of select="local-name()"/>
    </xsl:message>
  </xsl:template>
</xsl:stylesheet>
