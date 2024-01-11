<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
version="1.0">

<xsl:attribute-set name="page-header-font">
  <xsl:attribute name="font-family"><xsl:value-of select="$page.header.font.family"/></xsl:attribute>
  <xsl:attribute name="font-size">8pt</xsl:attribute>
  <xsl:attribute name="color"><xsl:value-of select="$color.our-dark-text"></xsl:value-of></xsl:attribute>
</xsl:attribute-set>


<xsl:template name="setup-page-headers">
  <!-- try to make it more obvious when a book contains over-long code lines -->
  <xsl:choose>
    <xsl:when test="//codeline[@toolong='yes']">
      <fo:static-content flow-name="even-header">
        <fo:block text-align-last="left"
          xsl:use-attribute-sets="page-header-font"
          color="rgb(255, 255, 255)"
          background="rgb(100, 30, 30)">
        <xsl:if test="ancestor-or-self::chapter 
          or ancestor-or-self::appendix 
          or ancestor-or-self::recipe 
          or ancestor-or-self::bibsection 
          ">
        <xsl:attribute name="start-indent">
          <xsl:value-of select="$flow-indent"/>
        </xsl:attribute>
      </xsl:if>
      <fo:inline><fo:page-number/></fo:inline>
      <fo:inline font-size="12pt"> • </fo:inline>
      <fo:inline font-style="normal">
        <xsl:text>This book contains code that's too wide. Look in the build log for details and fix.</xsl:text>
      </fo:inline>
    </fo:block>
  </fo:static-content>
</xsl:when>
<xsl:otherwise>
  <fo:static-content flow-name="even-header">
    <fo:block text-align-last="right"	xsl:use-attribute-sets="page-header-font">
      <xsl:if test="ancestor-or-self::chapter 
        or ancestor-or-self::appendix 
        or ancestor-or-self::recipe 
        or ancestor-or-self::bibsection 
        or self::part 
        ">
      <xsl:attribute name="end-indent">
        <xsl:value-of select="concat($flow-indent.number + $region-body-offset-inner.number,'in')"/>
      </xsl:attribute>
    </xsl:if> 
    <fo:inline font-style="normal" font-variant="small-caps">
      <fo:retrieve-marker>
        <xsl:attribute name="retrieve-class-name">
          <xsl:choose>
            <xsl:when test="ancestor-or-self::chapter 
              or ancestor-or-self::appendix 
              or ancestor-or-self::recipe 
              or ancestor-or-self::bibsection">chapter-name</xsl:when>
            <xsl:when test="self::part">part-name</xsl:when>
            <xsl:otherwise>chapter-name</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </fo:retrieve-marker>
    </fo:inline>
    <fo:inline font-size="12pt"> • </fo:inline>
    <fo:inline><fo:page-number/></fo:inline>
  </fo:block>  
</fo:static-content>
</xsl:otherwise>
    </xsl:choose>

    <fo:static-content flow-name="odd-header">
      <fo:block text-align-last="right"	xsl:use-attribute-sets="page-header-font">
        <xsl:if test="ancestor-or-self::chapter 
          or ancestor-or-self::appendix 
          or ancestor-or-self::recipe 
          or ancestor-or-self::bibsection 
          or self::part 
          ">
        <xsl:attribute name="end-indent">
          <xsl:value-of select="concat($flow-indent.number + $region-body-offset-outer.number,'in')"/>
        </xsl:attribute>
      </xsl:if>
      <fo:inline font-style="normal" font-variant="small-caps">
        <fo:retrieve-marker retrieve-class-name="section-name"/>
      </fo:inline>
      <fo:inline font-size="12pt"> • </fo:inline>
      <fo:inline><fo:page-number/></fo:inline>
    </fo:block>
  </fo:static-content>


  <fo:static-content flow-name="xsl-footnote-separator">
    <fo:block color="{$color.our-mid-heading-text}">
      <xsl:attribute name="start-indent">
        <xsl:choose>
          <xsl:when test="ancestor-or-self::task">0pt</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$flow-indent"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <fo:leader leader-pattern="rule"
        leader-length="15%"
        rule-style="solid"
        rule-thickness="0.25pt"/>
    </fo:block>
  </fo:static-content>
</xsl:template>

<xsl:template name="setup-page-footers">
  <xsl:choose>
    <xsl:when test="$extracts='yes'">
      <fo:static-content flow-name="footer">
        <fo:block text-align="right" start-indent="1.2in"
        margin-top="0.375in"
        border-top="0.5pt solid #ccdddd"
        xsl:use-attribute-sets="page-header-font"
        font-size="7pt"
        >
        <xsl:text> • </xsl:text>
        Click
        <fo:basic-link>
          <xsl:attribute name="external-destination">
            <xsl:text>url(http://pragprog.com/titles/</xsl:text>
            <xsl:value-of select="$book-code"/>
            <xsl:text></xsl:text>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
          HERE
        </fo:basic-link>
        to purchase this book now.
        <fo:basic-link>
          <xsl:attribute name="external-destination">
            <xsl:text>url(http://forums.pragprog.com/forums/</xsl:text>
            <xsl:value-of select="$book-code"/>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
          discuss
        </fo:basic-link>
      </fo:block>
    </fo:static-content>

  </xsl:when>
  <xsl:otherwise>

    <fo:static-content flow-name="footer">
      <xsl:if test="$booktype != 'airport'">
        <fo:block text-align="right" start-indent="1.2in"
        margin-top="0.375in"
        border-top="0.5pt solid #ccdddd"
        color="#77aaaa"
        xsl:use-attribute-sets="page-header-font"
        font-size="7pt"
        >
        <fo:basic-link>
          <xsl:attribute name="external-destination">
            <xsl:text>url(http://pragprog.com/titles/</xsl:text>
            <xsl:value-of select="$book-code"/>
            <xsl:text>/errata/add</xsl:text>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
          report erratum
        </fo:basic-link>

        <xsl:text> • </xsl:text>

        <fo:basic-link>
          <xsl:attribute name="external-destination">
            <xsl:text>url(http://forums.pragprog.com/forums/</xsl:text>
            <xsl:value-of select="$book-code"/>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
          discuss
        </fo:basic-link>
      </fo:block>
    </xsl:if>
  </fo:static-content>
</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="blank-page-setup">
    <fo:static-content flow-name="blank">
      <xsl:variable name="margin">
        <xsl:value-of select="($page.width.number - 1.15) div 2.0"/>in
      </xsl:variable>
      <fo:block
      margin-top="3in"
      line-stacking-strategy="max-height" 
      text-align="center">
      <fo:external-graphic src="url(../PerBook/util/images/single_gerbil_on_white.jpg)"/> 
      <fo:block-container
      margin-left="{$margin}" 
      margin-right="{$margin}"
      color="#77aaaa"
      xsl:use-attribute-sets="page-header-font"
      font-size="7pt">
      <fo:block 	    margin-bottom="6pt">
        We've left this page blank to make the page numbers the
        same in the electronic and paper books.
      </fo:block>
      <fo:block 	    margin-bottom="6pt">
        We tried just leaving it out, but then people wrote us to ask about
        the missing pages.
      </fo:block>
      <fo:block>
        Anyway, Eddy the Gerbil wanted to say “hello.”
      </fo:block>

    </fo:block-container>

  </fo:block>
</fo:static-content>
  </xsl:template>

  <xsl:template name="copyright-masthead">
    <xsl:variable name="img-width">
      <xsl:choose>
        <xsl:when test="$booktype = 'airport'">2.5in</xsl:when>
        <xsl:otherwise>4in</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:external-graphic  content-width="{$img-width}" 
    src="url(../PerBook/util/images/Bookshelf_4in.png)"/>
  </xsl:template>

  <xsl:template name="cover-image">
    <xsl:value-of select="$covers-root-dir"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="bookcode"/>
    <xsl:text>/images/</xsl:text>
    <xsl:value-of select="bookcode"/>
    <xsl:text>_72dpi.jpg</xsl:text>
  </xsl:template>


</xsl:stylesheet>
