<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            

  <xsl:template match="pdf">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="if[@target='pdf']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="if[@target!='pdf']">
  </xsl:template>

  <xsl:template match="if-inline[@target='pdf' and @hyphenate='yes']">
    <fo:inline hyphenation-remain-character-count="2">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  
  <xsl:template match="if-inline[@target='pdf' and not(@hyphenate='yes')]">
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="if-inline[@target!='pdf']">
  </xsl:template>

  <xsl:template match="hz"><fo:inline letter-spacing="{concat(@points,'pt')}"><xsl:apply-templates/></fo:inline></xsl:template>

</xsl:stylesheet>
