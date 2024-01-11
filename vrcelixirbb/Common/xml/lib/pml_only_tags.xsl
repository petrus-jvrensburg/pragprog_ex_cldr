<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   version="2.0"
>

  <xsl:template match="code | interact | ruby | ii | iii ">
    <xsl:text>The </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text> tag should not be here.</xsl:text>
  </xsl:template>

</xsl:stylesheet>
