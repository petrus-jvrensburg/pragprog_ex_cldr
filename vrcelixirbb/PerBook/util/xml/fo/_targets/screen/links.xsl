<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:exsl="http://exslt.org/common"
                version="1.0">            
<xsl:output indent="no"/>

  <xsl:template name="external-link">
    <xsl:param name="url"/>
    <xsl:param name="text"/>
    <fo:basic-link xsl:use-attribute-sets="inline-code-font"	
	font-style="italic"
	color="#2222aa"
    >
      <xsl:attribute name="external-destination">
	<xsl:text>url(</xsl:text>
	<xsl:value-of select="$url"/>
	<xsl:text>)</xsl:text>
      </xsl:attribute>
  <!-- SAXON change: exsl:object-type() does not exist; need to test whether this is even necessary any more. -->
    <!-- <xsl:choose>
	<xsl:when test="exsl:object-type($text) = 'RTF' or exsl:object-type($text) = 'node-set'">
	  <xsl:copy-of select="$text"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$text"/>          
	</xsl:otherwise>
      </xsl:choose> --> 
  <xsl:value-of select="$text"/>    
    </fo:basic-link>
  </xsl:template>


  <xsl:template name="livecode-link"><xsl:param name="text"/><xsl:param name="link"/><fo:basic-link color="#2222aa">
      <xsl:attribute name="external-destination">
	<xsl:text>url(http://media.pragprog.com/titles/</xsl:text>
	<xsl:value-of select="/book/bookinfo/@code"/>
	<xsl:text>/code/</xsl:text>
	<xsl:value-of select="$link"/>
	<xsl:text>)</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$text"/>          
    </fo:basic-link></xsl:template>


  <xsl:template name="internal-link">
    <xsl:param name="dest"/><xsl:param name="text"/>
    <fo:basic-link internal-destination="{$dest}" xsl:use-attribute-sets="hyperlink">
      <!-- SAXON change: exsl:object-type() does not exist; need to test whether this is even necessary any more. -->
    <!--   <xsl:choose><xsl:when test="exsl:object-type($text) = 'RTF' or exsl:object-type($text) = 'node-set'">
        <xsl:copy-of xml:space="default" select="$text"/>
      </xsl:when><xsl:otherwise><xsl:value-of select="normalize-space($text)"/>
      </xsl:otherwise></xsl:choose> -->
      
         <xsl:for-each select="$text/node()">
           <xsl:choose>
            <xsl:when test="self::text()">
               <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="url">   
    <fo:basic-link xsl:use-attribute-sets="hyperlink inline-code-font">
      <xsl:attribute name="external-destination">
        <xsl:text>url(</xsl:text>
      <xsl:if test="string-length(substring-before(.,':')) = 0">
        <xsl:choose>
          <xsl:when test="string-length(@protocol) &gt; 0">
            <xsl:value-of select="@protocol"/>
          </xsl:when>
          <xsl:otherwise><xsl:text>http://</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:value-of select="."/> 
        <xsl:text>)</xsl:text>
      </xsl:attribute>
      <!-- Add the slash-kern to kern the double-slashes, then add zwsp after single slashes to aid linebreaks. -->
      <xsl:choose>
        <xsl:when test="contains(.,'://')">
          <xsl:value-of select="substring-before(.,'://')"/>
          <xsl:text>:/</xsl:text><fo:inline padding-left="{$slash-kern}"><xsl:text>/</xsl:text></fo:inline>
          <xsl:call-template name="add-zero-width-spaces">
            <xsl:with-param name="string" select="substring-after(.,'://')"/>
            <xsl:with-param name="char" select="'/'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="add-zero-width-spaces">
            <xsl:with-param name="string" select="."/>
            <xsl:with-param name="char" select="'/'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </fo:basic-link>
  </xsl:template>
  
  <xsl:template name="add-zero-width-spaces">
    <xsl:param name="string"/>
    <xsl:param name="output-string"/>
    <xsl:param name="char"/>
    
    <xsl:choose>
      <xsl:when test="contains($string,$char)">
        <xsl:call-template name="add-zero-width-spaces">
          <xsl:with-param name="string" select="substring-after($string,$char)"/>
          <xsl:with-param name="output-string" select="concat($output-string,substring-before($string,$char),$char,'&#x200b;')"/>
          <xsl:with-param name="char" select="$char"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($output-string,$string)"/>
      </xsl:otherwise>
    </xsl:choose>   
  </xsl:template>   

  <xsl:template name="double-slash">
    <xsl:text>//</xsl:text>
  </xsl:template>

</xsl:stylesheet>


