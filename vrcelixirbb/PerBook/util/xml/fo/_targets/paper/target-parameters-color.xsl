<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:param name="target.for-screen">no</xsl:param>
  <xsl:param name="target.recto-verso-headings">yes</xsl:param>
  <xsl:param name="target.chapters-start-recto">yes</xsl:param>
  <xsl:param name="slash-kern">
      <xsl:choose>
        <xsl:when test="$booktype='pguide'">0pt</xsl:when>
        <xsl:otherwise>-1.75pt</xsl:otherwise>
      </xsl:choose>
   </xsl:param>

  <xsl:template name="where-do-chapters-end">
    <xsl:choose>
      <xsl:when test="//bookinfo/@chapter-start = 'verso'">
        <xsl:text>end-on-odd</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>end-on-even</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:attribute-set name="end-on-page-before-chapter-start">
    <xsl:attribute name="force-page-count">
      <xsl:call-template name="where-do-chapters-end"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="guide-task-page-sequence">
    <xsl:attribute name="force-page-count">
        <xsl:text>end-on-odd</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="end-on-even">
    <xsl:attribute name="force-page-count">
        <xsl:text>end-on-even</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:include href="display-attributes-color.xsl" />
  <xsl:include href="links.xsl"/>

</xsl:stylesheet>
