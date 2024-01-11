<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:output indent="no"/>
  <!-- Return the ID for the current node, generating one if required -->
  <xsl:template name="get-or-generate-id">
    <xsl:choose>
      <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="xref" name="xref">
    <xsl:variable name="linkid"><xsl:value-of select="@linkend"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="//*[@id=$linkid][not(ancestor-or-self::*[@stubout='yes'])]">
        <xsl:call-template name="internal-link">
          <xsl:with-param name="dest"><xsl:value-of select="@linkend"/></xsl:with-param>
          <xsl:with-param name="text">&#x200b;<xsl:apply-templates /><fo:inline keep-with-previous.within-line="always"><xsl:if test="not(@thispage='yes')"><xsl:text> </xsl:text></xsl:if></fo:inline><xsl:if test="not(@thispage='yes')"><xsl:text>on page &#x200b;</xsl:text><fo:page-number-citation ref-id="{@linkend}"/></xsl:if></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline font-style="italic" color="red">the (as yet) unwritten content</fo:inline></xsl:otherwise>
      </xsl:choose>
    </xsl:template>


  <xsl:template match="ref">
    <xsl:variable name="linkid"><xsl:value-of select="@linkend"/></xsl:variable>
    <xsl:variable name="target" select="id(@linkend)[1]"/>
    <xsl:choose>
      <xsl:when test="$target and //*[@id=$linkid][not(ancestor-or-self::*[@stubout='yes'])]">
        <xsl:call-template name="internal-link">
          <xsl:with-param name="dest"><xsl:value-of select="@linkend"/></xsl:with-param>
          <xsl:with-param name="text">
          <xsl:call-template name="text-escapes">
            <xsl:with-param name="text">
              <xsl:apply-templates select="$target" mode="pref"/>
            </xsl:with-param>
          </xsl:call-template>
            <!--
                <fo:inline keep-with-previous.within-line="always">
              <xsl:if test="not(@thispage='yes') and //*[@id=$linkid][not(name() = 'processedcode')]"><xsl:text>,
            </xsl:text>
              </xsl:if>
              </fo:inline>
              -->
            <xsl:if test="not(@thispage='yes')">
              <xsl:text>on page &#x200b;</xsl:text>
              <fo:page-number-citation ref-id="{@linkend}"/>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline font-style="italic" color="red">
          <xsl:text>the (as yet) unwritten </xsl:text>
        </fo:inline>
        <fo:inline font-style="italic">
          <xsl:apply-templates select="$target" mode="pref"/>
        </fo:inline>
        <xsl:if test="not(//*[@id=$linkid])">
          <xsl:message>
            <xsl:text>***** cross reference: </xsl:text>
          <xsl:value-of select="@linkend"/>
          </xsl:message>
          <fo:inline xsl:use-attribute-sets="highlight.missing">
            <xsl:text>I don't know how to generate a cross reference to </xsl:text>
            <xsl:value-of select="@linkend"/>
          </fo:inline>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="titleref">
    <xsl:variable name="linkid"><xsl:value-of select="@linkend"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="//*[@id=$linkid][ancestor-or-self::*[not(@stubout='yes')]]"><fo:inline xsl:use-attribute-sets="hyperlink">
        <xsl:call-template name="internal-link">
	  <xsl:with-param name="dest"><xsl:value-of select="@linkend"/></xsl:with-param>
	  <xsl:with-param name="text">
	    <xsl:call-template name="get.xref.title"/>
	  </xsl:with-param>
        </xsl:call-template>
      </fo:inline></xsl:when>
    <xsl:otherwise><fo:inline font-style="italic" color="red">(as yet) unwritten content</fo:inline></xsl:otherwise></xsl:choose>
  </xsl:template>

  <!-- cross reference stuff -->
  <xsl:template name="add-id">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- the format of a pref depends a lot on the thing being referenced -->

  <!--
      <xsl:template match="*" mode="pref">
      <xsl:call-template name="add-sticky-note">
      <xsl:with-param name="color">red</xsl:with-param>
      <xsl:with-param name="prefix">Cross reference</xsl:with-param>
      <xsl:with-param name="content">
      <xsl:text>I don't know how to generate a cross reference to </xsl:text>
      <xsl:value-of select="local-name()"/>
      </xsl:with-param>
      </xsl:call-template>
      </xsl:template>
  -->
  <xsl:template match="part" mode="pref"><xsl:if test="not(ancestor::frontmatter)"><xsl:text>Part </xsl:text><xsl:number format="I" count="part" from="book/mainmatter" level="any"/><xsl:text>, </xsl:text>&#x200b;</xsl:if><xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="chapter" mode="pref"><xsl:if test="not(ancestor::frontmatter) and $omit.chapnums='no'"><xsl:text>Chapter </xsl:text><xsl:number format="1" count="chapter" from="book/mainmatter" level="any"/><xsl:text>, </xsl:text>&#x200b;</xsl:if><xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="appendix" mode="pref"><xsl:if test="$omit.chapnums='no'"><xsl:text>Appendix </xsl:text><xsl:number format="1" count="appendix" from="book" level="any"/><xsl:text>, </xsl:text>&#x200b;</xsl:if><xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="recipe" mode="pref"><xsl:value-of select="concat($recipetitle,' ')"/><xsl:number format="1" count="recipe" from="mainmatter" level="any"/><xsl:text>, </xsl:text>&#x200b;<xsl:apply-templates select="title" mode="italic.title"/>&#x200b;<xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="tip" mode="pref"><xsl:value-of select="'Tip '"/><xsl:number format="1" count="tip" from="mainmatter" level="any"/><xsl:text>, </xsl:text>&#x200b;<xsl:apply-templates select="title" mode="italic.title"/>&#x200b;</xsl:template>

  <xsl:template match="task" mode="pref"><xsl:value-of select="'Task '"/><xsl:number format="1" count="task" from="mainmatter" level="any"/><xsl:text>, </xsl:text>&#x200b;<xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="bibsection" mode="pref"><xsl:if test="not(ancestor::frontmatter) and $omit.chapnums='no'"></xsl:if><xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="sect1" mode="pref"><xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="sect2 | sect3 | sect4" mode="pref"><xsl:apply-templates select="title" mode="italic.title"/><xsl:text>, </xsl:text></xsl:template>

  <xsl:template match="table" mode="pref">
    <xsl:text>Table </xsl:text>
    <xsl:number format="1" count="table[child::title]" from="book" level="any"/>
    <xsl:text>, </xsl:text>&#x200b;
    <xsl:apply-templates select="title" mode="italic.title"/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="figure" mode="pref">
    <xsl:if test="not(./title)">
      <xsl:message>
        <xsl:text>Reference to figure </xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>: «ref» used, but no title. Use «xref»</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:text>Figure </xsl:text>
    <xsl:number format="1" count="figure[child::title][child::*[not(name() = 'title') and not(name() = 'table')]]" from="book" level="any"/>
    <xsl:text>, </xsl:text>&#x200b;
    <xsl:apply-templates select="title" mode="figure.title"/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="sidebar | joeasks | story | said" mode="pref">
    <xsl:apply-templates select="title" mode="italic.title"/>
    <xsl:text>, </xsl:text>&#x200b;
  </xsl:template>

  <xsl:template match="imagedata" mode="pref">
  </xsl:template>


  <xsl:template match="processedcode" mode="pref">
    <xsl:text>code&#x200a;</xsl:text>
  </xsl:template>

  <!-- title stuff -->

  <xsl:template match="p" mode="italic.title"></xsl:template>
  <xsl:template match="*" mode="italic.title">
    <fo:inline font-style="italic"><xsl:value-of select="normalize-space(text()[1])" /></fo:inline>
  </xsl:template>

  <xsl:template match="*" mode="figure.title"><fo:inline font-style="italic"><xsl:call-template name="remove-terminal-punctuation"><xsl:with-param name="title" select="normalize-space(.)"></xsl:with-param></xsl:call-template></fo:inline></xsl:template>

  <xsl:template name="remove-terminal-punctuation">
    <xsl:param name="title"/>
    <xsl:variable name="title-length">
      <xsl:value-of select="string-length($title)"/>
    </xsl:variable>
    <xsl:variable name="last-char">
      <xsl:value-of select="substring($title,$title-length)"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$last-char = ' '">
        <xsl:call-template name="remove-terminal-punctuation">
          <xsl:with-param name="title" select="substring($title,1,$title-length - 1)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$last-char = '.' or $last-char = ':'">
        <xsl:value-of select="substring($title,1,$title-length - 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get.xref.title">
    <xsl:variable name="target" select="id(@linkend)[1]"/>
    <xsl:choose>
      <xsl:when test="$target"><xsl:apply-templates select="$target/title" mode="italic.title"/></xsl:when>
      <xsl:otherwise>
        <xsl:text>the (as yet) unwritten </xsl:text><fo:inline font-style="italic">
	<xsl:value-of select="@linkend"/>
      </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
