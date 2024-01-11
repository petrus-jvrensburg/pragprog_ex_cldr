<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xhtml="http://www.w3.org/1999/xhtml" 
   version="1.0"
>

  <xsl:output method="xml"/>

<!-- <xsl:template match="/">
  <xsl:apply-templates select="html" />
</xsl:template>
-->

<xsl:template match="node() | @*" mode="force">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()" mode="force"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xhtml:html">
  <xsl:copy>
    <xsl:apply-templates select="xhtml:head" mode="force"/> 
    <xsl:apply-templates select="xhtml:body"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xhtml:body">
  <xsl:copy>
    <xsl:call-template name="standard-header"/>
    <xsl:apply-templates select="xhtml:h1" mode="force"/> 
    <xsl:apply-templates select="//xhtml:div[@ppextract='yes']" mode="force"/>
    <xsl:apply-templates select="//xhtml:div[@class='copyright']" mode="force"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xhtml:span[@class='chapter-number']" mode="force">
  <span class="chapter-number">
    <xsl:text>Extracted from </xsl:text>
    <xsl:apply-templates mode="force"/>
  </span>
</xsl:template>

<xsl:template name="image-link">
  <xsl:variable name="home-page">
    <xsl:apply-templates select="//xhtml:link[@rel='homepage']" mode="header"/>
  </xsl:variable>
  <xsl:text>http://www.pragprog.com/images/covers/190x228/</xsl:text>
  <xsl:value-of select="substring-after($home-page, 'titles/')"/>
  <xsl:text>.jpg</xsl:text>
</xsl:template>

<xsl:template name="standard-header">
  <div class="extract-header">
    <div class="cover-image">
      <a>
	<xsl:attribute name="href">
	  <xsl:apply-templates select="//xhtml:link[@rel='homepage']" mode="header"/>
	</xsl:attribute>
	<img>
	  <xsl:attribute name="src">
	    <xsl:call-template name="image-link"/>
	  </xsl:attribute>
	  <xsl:attribute name="alt">
	    <xsl:apply-templates select="//xhtml:meta[@name='book-title']" mode="header"/>
	  </xsl:attribute>
	</img>
      </a>
    </div>
    <div class="blurb">
    <p>
      The following is an extract from the Pragmatic Bookshelf title
      <span class="book-title">
	<xsl:apply-templates select="//xhtml:meta[@name='book-title']" mode="header"/>
      </span>
      by
      <span class="book-author">
	<xsl:apply-templates select="//xhtml:meta[@name='book-author']" mode="header"/>.
      </span>
    </p>

    <p>
      This extract is formatted in HTML, and so has a different layout
      to the book itself. To some extent this layout depends on how
      your browser is set up. Note that this extract may contain
      color—the printed book will be grayscale.
    </p>

    <p>
      Visit the book's 
      <a>
	<xsl:attribute name="href">
	  <xsl:apply-templates select="//xhtml:link[@rel='homepage']" mode="header"/>
	</xsl:attribute>
	home page
      </a>
      to purchase this title.
    </p>
    </div>
    <div class="ruler"><span></span></div>
  </div>
</xsl:template>

<xsl:template match="xhtml:meta[@name='book-title']" mode="header">
  <xsl:value-of select="@content" mode="force"/>
</xsl:template>

<xsl:template match="xhtml:meta[@name='book-author']" mode="header">
  <xsl:value-of select="@content" mode="force"/>
</xsl:template>

<xsl:template match="xhtml:link" mode="header">
  <xsl:value-of select="@href" mode="force"/>
</xsl:template>

</xsl:stylesheet>
