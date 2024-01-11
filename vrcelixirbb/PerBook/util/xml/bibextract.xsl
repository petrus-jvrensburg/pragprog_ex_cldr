<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0"
>

  <xsl:variable name="bib" select="document('../../bibliography/bibliography.xml')/bibliography"/>

  <xsl:template match="bookname">
    <xsl:variable name="cite" select="@cite"/>
    <newbookname>
      <xsl:attribute name="label">
	<xsl:value-of select="$bib/bibentry[@key=$cite]/@label"/>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="text()">
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:for-each select="$bib/bibentry[@key=$cite]//booktitle">
	    <xsl:apply-templates>
	    </xsl:apply-templates>
	  </xsl:for-each>
	</xsl:otherwise>
      </xsl:choose>
    </newbookname>
  </xsl:template>

  <xsl:template match="bibliography">
    <newbibliography>
      <xsl:for-each select="$bib/bibentry">
	<xsl:copy>
	  <xsl:apply-templates/>
	</xsl:copy>
      </xsl:for-each>
    </newbibliography>
  </xsl:template>
  
  <xsl:template match="bibentry//*">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  

</xsl:stylesheet>