<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   version="2.0"
>

  <xsl:template name="sanitize-id">
    <xsl:param name="the-id"/>
    <xsl:call-template name="string-replace">
      <xsl:with-param name="string"  select="$the-id"/>
      <xsl:with-param name="from">:</xsl:with-param>
      <xsl:with-param name="to">-</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="add-id">
    <xsl:if test="@id">
      <xsl:attribute name="id">
	<xsl:call-template name="sanitize-id">
	  <xsl:with-param name="the-id" select="@id"/>
	</xsl:call-template>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="add-or-generate-id">
    <xsl:choose>
      <xsl:when test="@id"><xsl:call-template name="add-id"/></xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
