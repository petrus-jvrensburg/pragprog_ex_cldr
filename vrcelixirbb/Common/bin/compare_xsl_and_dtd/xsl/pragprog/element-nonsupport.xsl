<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:key name="elements" match="element" use="@name"/>
  
  <xsl:template match="/root">
ELEMENTS NOT SUPPORTED, GROUPED BY OUTPUT TYPE

All Output Types:
    <xsl:for-each select="//element">
      <xsl:variable name="name">
        <xsl:value-of select="@name"/>
      </xsl:variable>
      <xsl:if test="not(preceding::element[@name = $name]) and not(*) and not(//element[@name = $name]/*)">
        <xsl:text>
</xsl:text><xsl:value-of select="$name"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>    
  </xsl:template>
  
  <xsl:template match="ouput-type">
    <xsl:text>

OUTPUT TYPE: </xsl:text><xsl:value-of select="@name"/>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="element">
    <xsl:if test="not(*)"><xsl:text>     
    </xsl:text><xsl:value-of select="@name"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
    
  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text()"/>
  



</xsl:stylesheet>
