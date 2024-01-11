<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">            

  <xsl:param name="color.our-keystroke-background-shade">rgb(200, 200, 230)</xsl:param>
  <xsl:param name="color.our-text-background-shade">rgb(220, 220, 250)</xsl:param>
  <xsl:param name="color.our-light-line">rgb(190, 190, 210)</xsl:param>
  <xsl:param name="color.our-mid-line">rgb(150, 150, 180)</xsl:param>
  <xsl:param name="color.our-dark-line">rgb(50, 50, 105)</xsl:param>
  <xsl:param name="color.our-mid-text">rgb(120, 120, 140)</xsl:param>
  <xsl:param name="color.our-mid-heading-text">rgb(40, 40, 140)</xsl:param>
  <xsl:param name="color.our-midgray-text">rgb(90, 90, 90)</xsl:param>
  <xsl:param name="color.our-dark-text">rgb(50, 50, 65)</xsl:param>
  <xsl:param name="color.code-lozenge-background">rgb(200, 235, 220)</xsl:param>
  <xsl:param name="color.code-shaded-background">rgb(210, 225, 235)</xsl:param>
  <xsl:param name="color.ad-cover-border">rgb(180, 180, 180)</xsl:param>
  <!-- For screen, the svg color is identical to the non-svg color -->
  <xsl:param name="color.our-mid-line-svg">rgb(150, 150, 180)</xsl:param>
  <xsl:param name="color.our-tip">rgb(102, 170, 170)</xsl:param>

  <xsl:param name="color.hyperlink">rgb(10, 10, 150)</xsl:param>

  <!-- code -->

  <xsl:param name="color.code-marginalia">
    <xsl:value-of select="$color.our-mid-text"/>
  </xsl:param>
  
  <xsl:attribute-set name="code-lozenge">
    <xsl:attribute name="color">rgb(40, 90, 70)</xsl:attribute>
    <xsl:attribute name="background">
      <xsl:value-of select="$color.code-lozenge-background"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="cokw">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color">rgb(144, 17, 125)</xsl:attribute> 
  </xsl:attribute-set>


 <xsl:attribute-set name="coprompt">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
   <xsl:attribute name="color">rgb(10, 120, 0)</xsl:attribute>
 </xsl:attribute-set>

  <xsl:attribute-set name="costring">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="color">rgb(25, 17, 144)</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="cotag">
    <xsl:attribute name="color">rgb(100, 17, 114)</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="cocomment">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="color">rgb(15, 124, 15)</xsl:attribute>
  </xsl:attribute-set>


  <!-- hyperlinks -->

  <xsl:attribute-set name="hyperlink-color">
    <xsl:attribute name="color"><xsl:value-of select="$color.hyperlink"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="hyperlink">
    <xsl:attribute name="border-bottom">1pt dotted #6666aa</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$color.hyperlink"/></xsl:attribute>
  </xsl:attribute-set>


  <!-- Error and other indications -->


  <xsl:attribute-set name="highlight.missing-biblio">
    <xsl:attribute name="background">red</xsl:attribute>
    <xsl:attribute name="color">white</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.missing-xref">
    <xsl:attribute name="background">red</xsl:attribute>
    <xsl:attribute name="color">white</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.author">
    <xsl:attribute name="color">green</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.authorq">
    <xsl:attribute name="color">green</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.ce">
    <xsl:attribute name="color">purple</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.ed">
    <xsl:attribute name="color">blue</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.missing">
    <xsl:attribute name="font-size">75%</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color">red</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="highlight.permissions">
    <xsl:attribute name="background">darkgreen</xsl:attribute>
    <xsl:attribute name="color">white</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size">80%</xsl:attribute>
  </xsl:attribute-set>



  <!-- Shade attributes. -->

  <xsl:template name="color-from-shade">
    <xsl:param name="shade"/>

    <xsl:choose>
      <xsl:when test="$shade = 'white'">white</xsl:when>
      <xsl:when test="$shade = 'red'">red</xsl:when>
      <xsl:when test="$shade = 'green'">green</xsl:when>
      <xsl:when test="$shade = 'yellow'">yellow</xsl:when>
      <xsl:when test="$shade = 'blue'">blue</xsl:when>
      <xsl:when test="$shade = 'magenta'">magenta</xsl:when>
      <xsl:when test="$shade = 'cyan'">cyan</xsl:when>
      <xsl:when test="$shade = 'black'">black</xsl:when>
      <xsl:when test="$shade = 'light'">rgb(200,220,240)</xsl:when>
      <xsl:when test="$shade = 'dark'">rgb(50,50,100)</xsl:when>
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
  
  <xsl:param name="color.table-zebra-stripe">rgb(210, 255, 240)</xsl:param>

  <xsl:param name="color.table-inner-line">
    <xsl:value-of select="$color.our-light-line"/>
  </xsl:param>
  
  <xsl:param name="color.table-outer-line">
    <xsl:value-of select="$color.our-mid-line"/>
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
