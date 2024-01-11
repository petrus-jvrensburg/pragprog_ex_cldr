<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" media-type="text/xml" encoding="UTF-8" />
  <xsl:strip-space elements="root output-type element"/>
  
  <xsl:param name="schema"/>
  <xsl:param name="pdf-dir"/>
  
  <xsl:variable name="newline">
<xsl:text>
</xsl:text>
 </xsl:variable>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="root">
    <xsl:element name="root">
      <xsl:element name="output-type">
        <xsl:attribute name="name"> 
          <xsl:value-of select="'all'"/>
        </xsl:attribute>
        <xsl:apply-templates select="descendant::element" mode="all"/>
      </xsl:element>
      <xsl:apply-templates select="output-type"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="output-type">
    <xsl:element name="output-type">
      <xsl:attribute name="name"> 
        <xsl:value-of select="@name"/>
      </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element">
    <xsl:variable name="name">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:if test="not(preceding-sibling::element[. = $name])">
      <xsl:if test="not(document(concat('file:///',$schema))/descendant::*[name() = 'element'][@name = $name])">
        <xsl:element name="element"><xsl:value-of select="normalize-space($name)"/></xsl:element>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="element" mode="all">
    <xsl:variable name="name">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:if test="not(preceding::element[. = $name])">
      <xsl:if test="not(document(concat('file:///',$schema))/descendant::*[name() = 'element'][@name = $name])">
        <xsl:element name="element"><xsl:value-of select="normalize-space($name)"/></xsl:element>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
