<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:redirect="http://xml.apache.org/xalan/redirect"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="redirect"
                version="2.0">            
  
  <xsl:template name="build-image-list">
    <xsl:result-document href="image_list">
      <xsl:for-each select="//imagedata | //inlineimage">
        <xsl:apply-templates select="."  mode="list-image-names"/>
      </xsl:for-each>
      <xsl:for-each select="//said">
        <xsl:text>images/</xsl:text>
        <xsl:call-template name="name-to-headshot-name"/>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>_bw/images/</xsl:text>
        <xsl:call-template name="name-to-headshot-name"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:for-each>
      <xsl:for-each select="//adpage">
        <xsl:for-each select="tokenize(@codes,' ')"> 
          <xsl:value-of select="$covers-root-dir"/>
	  <xsl:text>/</xsl:text>	 
	  <xsl:value-of select="."/>
	  <xsl:text>/images/</xsl:text>
	  <xsl:value-of select="."/>
	  <xsl:text>_72dpi.jpg</xsl:text>
	  <xsl:text>&#9;</xsl:text>
          <xsl:text>_bw/images/</xsl:text>
	  <xsl:value-of select="."/>
	  <xsl:text>_72dpi.jpg&#10;</xsl:text>
	</xsl:for-each>
      </xsl:for-each>
      <xsl:variable name="extras">
        <xsl:call-template name="book-specific-image-list"/>
      </xsl:variable>

      <xsl:analyze-string select="$extras" regex="[^\s,]+">
        <xsl:matching-substring>
          <xsl:value-of select="."/>
          <xsl:text>&#9;</xsl:text>
          <xsl:call-template name="get-image-name">
            <xsl:with-param name="file">
              <xsl:value-of select="."/>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:text>&#10;</xsl:text>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
        </xsl:non-matching-substring>
       </xsl:analyze-string>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template name="book-specific-image-list" />
  
  <xsl:template match="imagedata | inlineimage" mode="list-image-names">
    <xsl:value-of select="@fileref"/>
    <xsl:text>&#9;</xsl:text>
    <xsl:call-template name="get-image-name"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="get-image-name">
    <xsl:param name="file">
      <xsl:value-of select="@fileref"/>
    </xsl:param>

    <xsl:text>_bw/</xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with($file, '../PerBook/util/images')">
        <xsl:text>_pragprog/</xsl:text>
        <xsl:value-of select="substring($file, 24)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$file"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
</xsl:stylesheet>
