<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:redirect="http://xml.apache.org/xalan/redirect"
  extension-element-prefixes="redirect"
  >
  <xsl:output method="xml" indent="no" 
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    />

  <xsl:param name="in.dir"/>

  <xsl:template match="/">
    <xsl:for-each select="descendant::*[@class='start_extract']">
     <xsl:variable name="extract_id">
        <xsl:value-of select="@id"/>
      </xsl:variable>
      <xsl:variable name="extract-file-name">
        <xsl:call-template name="safe-file-name">
          <xsl:with-param name="name">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="extract-path">
        <xsl:value-of select="concat($in.dir, 'extract-', $extract-file-name, '.html' )"/>
      </xsl:variable>
      <!-- SAXON change: use xsl:result-document instead of redirect:write -->
    <!--  <redirect:write select="$extract-path"> -->
     <xsl:result-document href="{$extract-path}">
       <xsl:element name="html">
          <xsl:for-each select="ancestor::*[local-name() = 'html']/@*">
            <xsl:attribute name="{local-name()}">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:for-each>

	  <head>
	    <xsl:copy-of select="//*[local-name(..)='head']"/>
	    <meta name="extract-name">
	      <xsl:attribute name="content">
		<xsl:value-of select="normalize-space(.)"/>
	      </xsl:attribute>
	    </meta>
	  </head>

          <xsl:element name="body">
            <xsl:copy-of select="//*[@class='extract-cover']"/>
            <xsl:for-each select="//*[@class='extract-title']">
              <xsl:copy-of select="*"/>
            </xsl:for-each>
            <xsl:for-each select="ancestor::*[not(ancestor::*)]">
              <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="extract_id" select="$extract_id"/>
              </xsl:apply-templates>
            </xsl:for-each>
            <h2>Buy This Book</h2>
            <div class="backmatter-cover">
              <xsl:variable name="bookcode">
                <xsl:value-of select="//*[local-name() = 'meta'][@name='bookcode']/@content"/>
              </xsl:variable>
              <xsl:text>This book is available on </xsl:text>
              <a href="https://pragprog.com/titles/{$bookcode}">our website</a>
              <xsl:text>.</xsl:text>
            </div>
          </xsl:element>
        </xsl:element>
     </xsl:result-document>
     <!--   </redirect:write> --> 
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:param name="extract_id"/>
    <xsl:choose>
      <xsl:when test="preceding::*[local-name()='div'][@class = 'start_extract'][@id = $extract_id]">
        <xsl:choose>
          <xsl:when test="following::*[local-name()='div'][@class = 'end_extract'][@idref = $extract_id]">
            <xsl:copy>
              <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="extract_id" select="$extract_id"/>
              </xsl:apply-templates>
            </xsl:copy>
          </xsl:when>
          <xsl:when test="descendant::*[local-name()='div'][@class = 'end_extract'][@idref = $extract_id]">
            <xsl:copy>
              <xsl:apply-templates select="@*|node()">
                <xsl:with-param name="extract_id" select="$extract_id"/>
              </xsl:apply-templates>
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates>
              <xsl:with-param name="extract_id" select="$extract_id"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates>
          <xsl:with-param name="extract_id" select="$extract_id"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*[@class='footnotes']">
    <xsl:param name="extract_id"/>
    <!-- first find out whether any footnotes fall within the current extract. -->
    <xsl:variable name="footnote-ids">
      <xsl:for-each select="descendant::*[local-name() = 'td'][@class = 'footnote-number']/*[local-name() = 'a']">
      <xsl:text>#</xsl:text>
        <xsl:value-of select="@id"/>
      </xsl:for-each>
      <xsl:text>#</xsl:text>
    </xsl:variable>
    <!-- if so, process the footnote entries. -->
    <xsl:if test="//*[local-name() = 'a'][contains($footnote-ids,concat(@href,'#'))]
      [preceding::*[local-name()='div'][@class = 'start_extract'][@id = $extract_id]]
      [following::*[local-name()='div'][@class = 'end_extract'][@idref = $extract_id]]">
      <xsl:element name="div">
        <xsl:attribute name="class">footnotes</xsl:attribute>
        <xsl:apply-templates select="@*|node()" mode="footnote">
          <xsl:with-param name="extract_id" select="$extract_id"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:if>
  </xsl:template> 
  
  <xsl:template match="@*|node()" mode="footnote">
    <xsl:param name="extract_id"/>
    
    <xsl:choose>
      <xsl:when test="self::*[local-name() = 'tr']">
        <!-- If the tr does not contain a footnote that falls 
        inside the extract, don't process it. This is the same
        test as the one for the entire footnotes section. -->
        <xsl:variable name="footnote-ids">
          <xsl:for-each select="descendant::*[local-name() = 'td'][@class = 'footnote-number']/*[local-name() = 'a']">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@id"/>
          </xsl:for-each>
          <xsl:text>#</xsl:text>
        </xsl:variable>
        <!-- If the extract contains this footnote, process this entry. -->
        <xsl:if test="//*[local-name() = 'a'][contains($footnote-ids,concat(@href,'#'))]
          [preceding::*[local-name()='div'][@class = 'start_extract'][@id = $extract_id]]
          [following::*[local-name()='div'][@class = 'end_extract'][@idref = $extract_id]]">
          <xsl:copy-of select="."/>
        </xsl:if>    
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" mode="footnote">
            <xsl:with-param name="extract_id" select="$extract_id"/>
          </xsl:apply-templates>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:variable name="valid-name-chars">
    <xsl:text>abcdefghijklmnopqrstuvwxyz0123456789-</xsl:text>
  </xsl:variable>

  <xsl:variable name="filler-char">
    <xsl:text>-----------------------------------------------------------------------------------------</xsl:text>
  </xsl:variable>

  <xsl:template name="safe-file-name">
    <xsl:param name="name"/>
    <xsl:variable name="lc-name">
      <xsl:value-of select="translate($name, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
    </xsl:variable>
    <xsl:variable name="invalid-chars">
      <xsl:value-of select="translate($lc-name, $valid-name-chars, '')"/>
    </xsl:variable>
    <xsl:value-of select="translate($lc-name, $invalid-chars, $filler-char)"/>
  </xsl:template>

</xsl:stylesheet>
