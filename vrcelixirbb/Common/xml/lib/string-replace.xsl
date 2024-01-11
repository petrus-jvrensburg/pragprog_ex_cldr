<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="2.0"
>
  <xsl:template name="string-replace">
    <xsl:param name="string"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    
     <xsl:analyze-string select="$string" regex="{$from}">
      <xsl:matching-substring>
         <xsl:copy-of select="$to"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
         <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string> 

    <!--
     <xsl:choose>
      <xsl:when test="contains($string, $from)">
	<xsl:variable name="before" select="substring-before($string, $from)"/>
	<xsl:variable name="after"  select="substring-after($string, $from)"/>
	<xsl:variable name="prefix" select="concat($before, $to)"/>
	<xsl:value-of select="$before"/>
	<xsl:copy-of select="$to"/>
	<xsl:call-template name="string-replace">
	  <xsl:with-param name="string" select="$after"/>
	  <xsl:with-param name="from" select="$from"/>
	  <xsl:with-param name="to">
	    <xsl:copy-of select="$to"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when> 
      <xsl:otherwise>
	<xsl:value-of select="$string"/>  
      </xsl:otherwise>
      </xsl:choose>      -->
    
    
  </xsl:template>
</xsl:stylesheet>