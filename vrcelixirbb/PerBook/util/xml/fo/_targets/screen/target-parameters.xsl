<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">            


  <xsl:param name="target.for-screen">yes</xsl:param>
  <xsl:param name="target.recto-verso-headings">no</xsl:param>
  <xsl:param name="target.chapters-start-recto">yes</xsl:param>
  <xsl:param name="slash-kern">0pt</xsl:param>
  <!-- 
       because they're unnumbered, we don't need to force a recto page in the stuff before the preface
  -->
      
  <xsl:attribute-set name="end-on-page-before-chapter-start-in-frontmatter"/>

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
  
  <xsl:attribute-set name="end-on-even">
    <xsl:attribute name="force-page-count">
        <xsl:text>end-on-even</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>


  <xsl:attribute-set name="guide-task-page-sequence">
    <xsl:attribute name="force-page-count">
        <xsl:text>end-on-odd</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  
  <xsl:attribute-set name="end-on-page-before-chapter-start-in-frontmatter">
    <xsl:attribute name="force-page-count">
      <xsl:call-template name="where-do-chapters-end"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- make the following rule empty to remove the blank verso before a chapter -->
  <xsl:attribute-set name="end-on-page-before-chapter-start">
    <xsl:attribute name="force-page-count">
      <xsl:choose>
        <xsl:when test="$target.recto-verso-headings='yes'">
          <xsl:text>end-on-odd</xsl:text>
        </xsl:when>
        <xsl:otherwise>no-force</xsl:otherwise>
      </xsl:choose>
      
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:include href="display-attributes.xsl"/>
  <xsl:include href="links.xsl"/>
  
</xsl:stylesheet>
