<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mbp="http://mobipocket.com/mbp"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="mbp"
    version="2.0"
    >

  <!-- cross references -->

  <xsl:template match="part" mode="xref.name">
    <xsl:text>Part </xsl:text>
    <xsl:number format="1" count="part" from="book" level="any"/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="chapter" mode="xref.name">
    <xsl:if test="not(ancestor::frontmatter)">
      <xsl:text>Chapter </xsl:text>
      <xsl:number format="1" count="chapter" from="book/mainmatter" level="any"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="appendix" mode="xref.name">
    <xsl:text>Appendix </xsl:text>
    <xsl:number format="1" count="appendix" from="book" level="any"/>
    <xsl:text>, </xsl:text>
  </xsl:template>
  
  <xsl:template match="sect1" mode="xref.name"/>    
  
  <xsl:template match="figure" mode="xref.name"> 
    <xsl:text>Figure </xsl:text>
    <xsl:number format="1" count="figure[child::title]" from="book" level="any"/>
    <xsl:text>, </xsl:text>
  </xsl:template>
  
  <xsl:template match="table" mode="xref.name">
    <xsl:if test="child::title">
      <xsl:text>Table </xsl:text>
      <xsl:number format="1" count="table[child::title]" from="book" level="any"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="recipe" mode="xref.name">
    <xsl:value-of select="concat($recipetitle,' ')"/>
    <xsl:number format="1" count="recipe" from="book" level="any"/>
    <xsl:text>, </xsl:text>
  </xsl:template>
  
  <xsl:template match="tip" mode="xref.name">
    <xsl:text>Tip </xsl:text>
    <xsl:number format="1" count="tip" from="book" level="any"/>
    <xsl:text>, </xsl:text>
  </xsl:template>
  
  <xsl:template match="bibsection" mode="xref.name"/>
  
  <xsl:template match="sect2|sect3|sect4" mode="xref.name"/>  

  <xsl:template match="p " mode="xref.name"/>
  
  <xsl:template match="sidebar" mode="xref.name"/>
  
  <xsl:template match="joeasks" mode="xref.name"/>
  
  <xsl:template match="story" mode="xref.name"/>
  
  <xsl:template match="processedcode" mode="xref.name"><a><xsl:attribute name="href">
    <xsl:text>#</xsl:text>
    <xsl:call-template name="sanitize-id">
      <xsl:with-param name="the-id"  select="@id"/>
    </xsl:call-template>
    </xsl:attribute>&#8203;<xsl:text>code</xsl:text>&#8203;</a>
  </xsl:template> 
  
  <xsl:template match="processedcode" mode="xref.title"/>

  <xsl:template match="imagedata" mode="xref.title">here</xsl:template>

  <xsl:template match="imagedata" mode="xref.name"/>
  
  <xsl:template match="*" mode="xref.name">
    <xsl:message terminate="yes">
      <xsl:text>&#10;&#10;===========================================&#10;&#10;</xsl:text>
      <xsl:text>You have a cross reference to “</xsl:text>
      <xsl:value-of select="@id" />”<xsl:text>.&#10;</xsl:text>
      <xsl:text>This is a &lt;</xsl:text>
      <xsl:value-of select="local-name(.)" />
      <xsl:text>&gt; tag. Unfortunately, I haven't yet been shown&#10;</xsl:text>
      <xsl:text>how to name such a tag in a cross reference, so I'm going to have to&#10;</xsl:text>
      <xsl:text>stop now. Dave can fix this up in no time…</xsl:text>
      <xsl:text>&#10;&#10;===========================================&#10;&#10;</xsl:text>
    </xsl:message>
  </xsl:template>

  <!-- most xrefs don't have a title -->
  <xsl:template match="*" mode="xref.title"><xsl:if test="./title"><xsl:element name="em"><xsl:apply-templates select="./title" mode="force"/></xsl:element></xsl:if></xsl:template>
  <xsl:template match="figure" mode="xref.title"><xsl:if test="./title"><xsl:element name="em"><xsl:apply-templates select="./title" mode="figure"/></xsl:element></xsl:if></xsl:template>

  <xsl:template match="ref | titleref">
    <xsl:variable name="linkend">
      <xsl:value-of select="@linkend"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="//*[@id=$linkend]">
        <xsl:choose>
          <xsl:when test="//*[@id=$linkend][not(ancestor-or-self::*[@stubout='yes'])]">
            <xsl:for-each select="//*[@id=$linkend]">
              <xsl:call-template name="do-xref">
	        <xsl:with-param name="id">
	          <xsl:value-of select="$linkend"/>
	        </xsl:with-param>
              </xsl:call-template>	
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <span style="font-style:italic;">(as yet) unwritten content</span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>
          <xsl:text>[Can't find reference to: </xsl:text>
          <xsl:value-of select="@linkend"/>
          <xsl:text>]</xsl:text>
	</xsl:message>
	<xsl:text>(missing cross reference target…)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="xref" name="ref">
    <xsl:variable name="linkend">
      <xsl:value-of select="@linkend"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="//*[@id=$linkend]">
        <xsl:choose>
          <xsl:when test="//*[@id=$linkend][ancestor::*[not(@stubout='yes')]]">
            <a>
	      <xsl:attribute name="href">
	        <xsl:text>#</xsl:text>
	        <xsl:call-template name="sanitize-id">
	          <xsl:with-param name="the-id"  select="$linkend"/>
	        </xsl:call-template>
	      </xsl:attribute>
              <xsl:choose>
                <xsl:when test="not(child::node())">
                  <xsl:text>here</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates />
                </xsl:otherwise>
              </xsl:choose>
              
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span style="font-style:italic;">(as yet) unwritten content</span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>
          <xsl:text>[Can't find reference to: </xsl:text>
          <xsl:value-of select="@linkend"/>
          <xsl:text>]</xsl:text>
	</xsl:message>
	<xsl:text>(missing cross reference target…)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="cref">
    <xsl:variable name="linkend" select="@linkend"/>
    <xsl:variable name="target" select="generate-id(//codeline[descendant-or-self::*[@id = $linkend]])"/>
    
    <xsl:choose>
      <xsl:when test="$target">
	<xsl:value-of select="count(//codeline[generate-id() = $target]/preceding-sibling::codeline) + 1" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">
          <xsl:text>[code refererence </xsl:text>
          <xsl:value-of select="@linkend"/>
          <xsl:text> could not be found]</xsl:text>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="coref">
    <xsl:variable name="linkend">
      <xsl:value-of select="@linkend"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="//*[@id=$linkend]">
	<xsl:for-each select="//*[@id=$linkend]">
	  <xsl:call-template name="callout-number">
	    <xsl:with-param name="number" select="@calloutno" />
	  </xsl:call-template>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message terminate="yes">
          <xsl:text>[XREF: </xsl:text>
          <xsl:value-of select="@linkend"/>
          <xsl:text>]</xsl:text>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="do-xref">
    <xsl:param name="id"/>
    <xsl:apply-templates select="." mode="xref.name" />
    <a><xsl:attribute name="href">
      <!--      <xsl:call-template name="filename"/>  -->
      <xsl:text>#</xsl:text>
      <xsl:call-template name="sanitize-id">
	<xsl:with-param name="the-id"  select="$id"/>
      </xsl:call-template>
    </xsl:attribute>&#8203;<xsl:apply-templates xml:space="default" select="." mode="xref.title" />&#8203;</a>
  </xsl:template>

</xsl:stylesheet>
