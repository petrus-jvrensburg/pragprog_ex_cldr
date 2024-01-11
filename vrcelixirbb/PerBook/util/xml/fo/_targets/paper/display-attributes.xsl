<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:param name="color.our-keystroke-background-shade">rgb-icc(220, 220, 220, #Grayscale, 0.83)</xsl:param>
  <xsl:param name="color.our-text-background-shade">rgb-icc(220, 220, 220, #Grayscale, 0.83)</xsl:param>
  <xsl:param name="color.our-light-line">rgb-icc(191, 191, 191, #Grayscale, 0.75)</xsl:param>
  <xsl:param name="color.our-mid-line">rgb-icc(168, 168, 168, #Grayscale, 0.67)</xsl:param>
  <xsl:param name="color.our-dark-line">rgb-icc(128, 128, 128, #Grayscale, 0.5)</xsl:param>
  <xsl:param name="color.our-mid-text">rgb-icc(128, 128, 128, #Grayscale, 0.5)</xsl:param>
  <xsl:param name="color.our-midgray-text">rgb-icc(128, 128, 128, #Grayscale, 0.5)</xsl:param>
  <xsl:param name="color.our-mid-heading-text">rgb-icc(128, 128, 128, #Grayscale, 0.5)</xsl:param>
  <xsl:param name="color.our-dark-text">rgb-icc(80, 80, 80, #Grayscale, 0.3)</xsl:param>
  <xsl:param name="color.code-shaded-background">rgb-icc(220, 220, 220, #Grayscale, 0.83)</xsl:param>
  <xsl:param name="color.ad-cover-border">rgb-icc(168, 168, 168, #Grayscale, 0.67)</xsl:param>
  <xsl:param name="color.our-mid-line-svg">darkgray</xsl:param>
  <xsl:param name="color.code-marginalia">rgb-icc(128, 128, 128, #Grayscale, 0.5)</xsl:param>
  <xsl:param name="color.our-tip">rgb-icc(168, 168, 168, #Grayscale, 0.67)</xsl:param>

  <!-- code -->


  <xsl:attribute-set name="code-lozenge">
    <xsl:attribute name="color"><xsl:value-of select="$color.our-dark-text"/></xsl:attribute>
    <xsl:attribute name="background">
      <xsl:choose>
        <xsl:when test="ancestor::joeasks
                or ancestor::said
                or ancestor::sidebar">
         <xsl:value-of select="$color.our-light-line"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$color.our-text-background-shade"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:attribute>
  </xsl:attribute-set>


  <xsl:attribute-set name="cokw">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

 <xsl:attribute-set name="coprompt">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="costring">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="cotag">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$color.our-mid-text"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="cocomment">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

  <!-- hyperlinks -->

  <xsl:attribute-set name="hyperlink">
  </xsl:attribute-set>

  <!-- Error and other indications -->

  <xsl:attribute-set name="highlight.missing-biblio">
    <xsl:attribute name="background">lightgray</xsl:attribute>
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.missing-xref">
    <xsl:attribute name="background">lightgray</xsl:attribute>
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.author">
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.authorq">
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.ce">
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.ed">
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.missing">
    <xsl:attribute name="font-size">75%</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color">darkgray</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.permissions">
    <xsl:attribute name="background">lightgray</xsl:attribute>
    <xsl:attribute name="color">darkgray</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size">80%</xsl:attribute>
  </xsl:attribute-set>


<!-- Shade attributes. -->

  <xsl:template name="color-from-shade">
	<xsl:param name="shade"/>

	<xsl:choose>
	  <xsl:when test="$shade = 'white'"  >rgb-icc(255,255,255,#GrayScale,1.0)</xsl:when>
	  <xsl:when test="$shade = 'red'"    >rgb-icc(255,  0,  0,#GrayScale,0.2989)</xsl:when>
	  <xsl:when test="$shade = 'green'"  >rgb-icc(  0,255,  0,#GrayScale,0.5870)</xsl:when>
	  <xsl:when test="$shade = 'yellow'" >rgb-icc(255,255,  0,#GrayScale,0.8859)</xsl:when>
	  <xsl:when test="$shade = 'blue'"   >rgb-icc(  0,  0,255,#GrayScale,0.114)</xsl:when>
	  <xsl:when test="$shade = 'magenta'">rgb-icc(255,  0,255,#GrayScale,0.4129)</xsl:when>
	  <xsl:when test="$shade = 'cyan'"   >rgb-icc(  0,255,255,#GrayScale,0.701)</xsl:when>
	  <xsl:when test="$shade = 'black'"  >rgb-icc(0,0,0,#GrayScale,0.0)</xsl:when>
	  <xsl:when test="$shade = 'light'"  ><xsl:value-of select="$color.our-light-line"/></xsl:when>
	  <xsl:when test="$shade = 'dark'"   ><xsl:value-of select="$color.our-dark-text"/></xsl:when>
	  <xsl:otherwise><xsl:message terminate="yes">Unknown shade: <xsl:value-of select="$shade"/>.</xsl:message></xsl:otherwise>
	</xsl:choose>
  </xsl:template>


  <xsl:attribute-set name="figcaption.attrs">
    <xsl:attribute name="space-before">0pt</xsl:attribute>
    <xsl:attribute name="space-after">0pt</xsl:attribute>
    <xsl:attribute name="border-bottom">1.5pt solid rgb-icc(220, 220, 220, #Grayscale, 0.83)</xsl:attribute>
    <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
  </xsl:attribute-set>


  <xsl:param name="color.heading-underline">
      <xsl:value-of select="$color.our-light-line"/>
  </xsl:param>

  <xsl:param name="color.sidebar-body-background">
    <xsl:value-of select="$color.our-text-background-shade"/>
  </xsl:param>

  <xsl:param name="color.sidebar-border">
    <xsl:value-of select="$color.our-mid-line"/>
  </xsl:param>

  <xsl:param name="color.sidebar-border-svg">
    <xsl:value-of select="$color.our-mid-line-svg"/>
  </xsl:param>


  <xsl:param name="color.example-block">
    <xsl:value-of select="$color.our-text-background-shade"/>
  </xsl:param>

  <xsl:param name="color.keystroke-background">
    <xsl:value-of select="$color.our-text-background-shade"/>
  </xsl:param>

  <xsl:param name="color.table-zebra-stripe">
    <xsl:value-of select="$color.our-mid-line"/>
  </xsl:param>

  <xsl:param name="color.table-inner-line">
      <xsl:value-of select="$color.our-light-line"/>
  </xsl:param>

  <xsl:param name="color.table-outer-line">
      <xsl:value-of select="$color.our-dark-line"/>
  </xsl:param>

  <xsl:param name="color.keystroke-border">
    <xsl:value-of select="$color.our-dark-line"/>
  </xsl:param>

  <xsl:param name="color.index-alpha-heading">
    <xsl:value-of select="$color.our-dark-text"/>
  </xsl:param>


  <!-- title page -->

  <xsl:param name="color.imprint-name">
    <xsl:value-of select="$color.our-mid-text"/>
  </xsl:param>

  <xsl:param name="color.imprint-border-bottom">
    <xsl:value-of select="$color.our-mid-line"/>
  </xsl:param>


</xsl:stylesheet>
