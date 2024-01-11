<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- SAXON change: UTF to utf, for consistency. -->
  <xsl:output method="text" indent="no" encoding="utf-8" />
   
  <xsl:template match="/">
    <xsl:for-each select="//figure[not(//ref/@linkend = @id)]">
      <xsl:if test="position()=1">
	<xsl:text>&#10;The following figures are not referenced from the body of the text.&#10;</xsl:text>
	<xsl:text>(our style is that every figure must have at least one reference to it)&#10;&#10;</xsl:text>
      </xsl:if>
      <xsl:text>     id=</xsl:text>
      <xsl:value-of select="@id"/>: <xsl:value-of select="title"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  
</xsl:stylesheet>
