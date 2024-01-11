<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            

  <xsl:template match="layout">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="kern">
    <xsl:variable name="left">
      <xsl:choose>
        <xsl:when test="@left"><xsl:value-of select="@left"/></xsl:when>
        <xsl:otherwise>0pt</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
   <xsl:variable name="right">
      <xsl:choose>
        <xsl:when test="@right"><xsl:value-of select="@right"/></xsl:when>
        <xsl:otherwise>0pt</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:inline margin-left="{$left}" margin-right="{$right}"><xsl:apply-templates></xsl:apply-templates></fo:inline>
  </xsl:template>
  
 <!--  <xsl:template match="extract"/>--> 

  <xsl:template name="draw-underlined-heading">
    <xsl:param name="title"/>
    <xsl:variable name="backup-line-height">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$line-height*$body.font.master"/>
      <xsl:text>pt</xsl:text>
    </xsl:variable>

    <fo:block
	font-weight="normal" 
	font-family="{$sans.font.family}" 
	font-size="30pt"
	font-stretch="condensed"
	space-after="0pt"
        margin-bottom="13pt"
        >
      <xsl:if test="@line!='no'">
        <xsl:attribute name="border-bottom">2pt solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">
          <xsl:value-of select="$color.heading-underline"/>
        </xsl:attribute>
        <xsl:attribute name="padding-bottom">
          <xsl:value-of select="$backup-line-height"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$title"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="add-or-generate-id">
    <xsl:choose>
      <xsl:when test="@id"><xsl:call-template name="add-id"/></xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="id">
	  <xsl:value-of select="generate-id(.)"/>
	</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
