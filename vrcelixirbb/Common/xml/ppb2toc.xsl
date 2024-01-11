<xsl:stylesheet  
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
   version="1.0"> 

  <xsl:output method="text"/>

  <xsl:param name="book-code">xxx</xsl:param>
  <xsl:param name="level">1</xsl:param>

  <xsl:template match="book">
    <xsl:choose>
      <xsl:when test="//part">
	<xsl:for-each select="//part">
	  <xsl:text>* *</xsl:text>
	    <xsl:value-of select="./title" />
	  <xsl:text>*&#10;</xsl:text>
	  <!-- remove select ./sorbet| -->
	  <xsl:for-each select="./recipe|./chapter|./appendix">
	    <xsl:call-template name="chapter">
	      <xsl:with-param name="prefix">*</xsl:with-param>
	    </xsl:call-template>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- remove select //sorbet| -->
	<xsl:for-each select="//recipe|//chapter|//appendix">	
	  <xsl:call-template name="chapter">
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="chapter">
    <xsl:param name="prefix"></xsl:param>
    <xsl:value-of select="$prefix"/>
    <xsl:text>* </xsl:text>
    <xsl:value-of select="./title" />
    <xsl:if test=".//ppextract">
      <xsl:variable name="extract-file">
	<xsl:text>chap-</xsl:text>
  <!-- remove count |contribution -->
	<xsl:number format="001" count="chapter|appendix" 
		    from="book" level="any"/>
	<xsl:text>-extract.html</xsl:text>
      </xsl:variable>
      <xsl:text> (&lt;a href="http://media.pragprog.com/titles/</xsl:text><!-- " -->
      <xsl:value-of select="$book-code"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$extract-file"/>
      <xsl:text>"&gt;extract&lt;/a&gt;)</xsl:text><!-- " -->
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="$level &gt; 0">
      <xsl:for-each select="./sect1">
	<xsl:call-template name="sect1">
	  <xsl:with-param name="prefix">
	    <xsl:value-of select="$prefix"/>
	    <xsl:text>**</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <xsl:template name="sect1">
    <xsl:param name="prefix"/>

    <xsl:value-of select="$prefix"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="./title"/>
    <xsl:text>&#10;</xsl:text>

    <xsl:if test="$level &gt; 1">
      <xsl:for-each select="./sect2">
	<xsl:call-template name="sect2">
	  <xsl:with-param name="prefix">
	    <xsl:value-of select="$prefix"/>
	    <xsl:text>*</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>



  <xsl:template name="sect2">
    <xsl:param name="prefix"/>

    <xsl:value-of select="$prefix"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="./title"/>
    <xsl:text>&#10;</xsl:text>

    <xsl:if test="$level &gt; 2">
      <xsl:for-each select="./sect3">
	<xsl:call-template name="sect3">
	  <xsl:with-param name="prefix">
	    <xsl:value-of select="$prefix"/>
	    <xsl:text>*</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <xsl:template name="sect3">
    <xsl:param name="prefix"/>

    <xsl:value-of select="$prefix"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="./title"/>
    <xsl:text>&#10;</xsl:text>

    <xsl:if test="$level &gt; 3">
      <xsl:for-each select="./sect4">
	<xsl:call-template name="sect4">
	  <xsl:with-param name="prefix">
	    <xsl:value-of select="$prefix"/>
	    <xsl:text>*</xsl:text>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <xsl:template name="sect4">
    <xsl:param name="prefix"/>

    <xsl:value-of select="$prefix"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="./title"/>
  </xsl:template>

  <!-- Report errors on all other tags... -->
  <xsl:template match="*">
    <xsl:message>
      Unhandled tag: <xsl:value-of select="local-name()"/>
    </xsl:message>
  </xsl:template>


</xsl:stylesheet>  
