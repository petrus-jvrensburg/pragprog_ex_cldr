<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            

  <xsl:template match="ktab">
    <fo:inline font-family="Apple Keyboard">A</fo:inline>
  </xsl:template>

  <xsl:template match="kshift">
    <fo:inline font-family="Apple Keyboard">B</fo:inline>
  </xsl:template>

  <xsl:template match="kcontrol">
    <fo:inline font-family="Apple Keyboard">C</fo:inline>
  </xsl:template>

  <xsl:template match="kcommand">
    <fo:inline font-family="Apple Keyboard">D</fo:inline>
  </xsl:template>

  <xsl:template match="koption">
    <fo:inline font-family="Apple Keyboard">E</fo:inline>
  </xsl:template>

  <xsl:template match="kreturn">
    <fo:inline font-family="Apple Keyboard">F</fo:inline>
  </xsl:template>

  <xsl:template match="kreturn2">
    <fo:inline font-family="Apple Keyboard">G</fo:inline>
  </xsl:template>

  <xsl:template match="klinebreak">
    <fo:inline font-family="Apple Keyboard">H</fo:inline>
  </xsl:template>
 
  <xsl:template match="kenter">
    <fo:inline font-family="Apple Keyboard">I</fo:inline>
  </xsl:template>

  <xsl:template match="kdelete">
    <fo:inline font-family="Apple Keyboard">J</fo:inline>
  </xsl:template>

  <xsl:template match="kesc">
    <fo:inline font-family="Apple Keyboard">K</fo:inline>
  </xsl:template>

  <xsl:template match="kcapslock">
    <fo:inline font-family="Apple Keyboard">L</fo:inline>
  </xsl:template>

  <xsl:template match="kapple">
    <fo:inline font-family="Apple Keyboard">M</fo:inline>
  </xsl:template>

  <!-- remove
<xsl:template match="keject">
    <fo:inline font-family="Apple Keyboard">N</fo:inline>
  </xsl:template>  -->

  <xsl:template match="kpower">
    <fo:inline font-family="Apple Keyboard">O</fo:inline>
  </xsl:template>

  <xsl:template match="kbacktab">
    <fo:inline font-family="Apple Keyboard">P</fo:inline>
  </xsl:template>

  <xsl:template match="kpageup">
    <fo:inline font-family="Apple Keyboard">Q</fo:inline>
  </xsl:template>

  <xsl:template match="kpagedown">
    <fo:inline font-family="Apple Keyboard">R</fo:inline>
  </xsl:template>

  <xsl:template match="khome">
    <fo:inline font-family="Apple Keyboard">S</fo:inline>
  </xsl:template>

  <xsl:template match="kend">
    <fo:inline font-family="Apple Keyboard">T</fo:inline>
  </xsl:template>

  <xsl:template match="kforwarddelete">
    <fo:inline font-family="Apple Keyboard">U</fo:inline>
  </xsl:template>

  <xsl:template match="khelp">
    <fo:inline font-family="Apple Keyboard">V</fo:inline>
  </xsl:template>

  <xsl:template match="vspace">
    <fo:inline font-family="Deja Vu Serif">&#x2423;</fo:inline>
  </xsl:template>



  <xsl:template match="kup">
     <fo:inline font-family="Arial">&#8593;</fo:inline>  
  </xsl:template>

  <xsl:template match="kdown">
    <fo:inline font-family="Arial">&#8595;</fo:inline> 
  </xsl:template>

  <xsl:template match="kleft">
    <fo:inline font-family="Arial">&#8592;</fo:inline> 
  </xsl:template>

  <xsl:template match="kright">&#x200b;<fo:inline font-family="Arial">&#x200b;&#8594;&#x200b;</fo:inline>&#x200b;</xsl:template>



  <xsl:template match="F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12">
    <fo:inline font-family="{$sans.font.family}"><xsl:value-of select="local-name()"/></fo:inline>
  </xsl:template>

  <xsl:template match="kseq">
    <fo:inline>&#8203;<xsl:apply-templates/></fo:inline>
  </xsl:template>

</xsl:stylesheet>
