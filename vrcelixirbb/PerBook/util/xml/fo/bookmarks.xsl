<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">  
  
   
  <xsl:template name="create-bookmarks">
    <fo:bookmark-tree>
      <fo:bookmark>
        <xsl:attribute name="internal-destination">
	  <xsl:for-each select="//book[1]">
	    <xsl:text>cover</xsl:text>
	    <xsl:call-template name="get-or-generate-id"/>
          </xsl:for-each>
        </xsl:attribute>
        <fo:bookmark-title font-weight="bold" >
          <xsl:text>Cover</xsl:text>
        </fo:bookmark-title>
      </fo:bookmark>
      <fo:bookmark>
	<xsl:attribute name="internal-destination">
	  <xsl:for-each select="//book[1]">
	    <xsl:text>toc</xsl:text>
	    <xsl:call-template name="get-or-generate-id"/>
	  </xsl:for-each>
	</xsl:attribute>
	<fo:bookmark-title font-weight="bold">
	  <xsl:text>Table of Contents</xsl:text>
	</fo:bookmark-title>
      </fo:bookmark> 
      <xsl:apply-templates select="/" mode="bookmark"/>
    </fo:bookmark-tree>
  </xsl:template>


  <xsl:template match="frontmatter|mainmatter" mode="bookmark">
    <xsl:apply-templates mode="bookmark"/>
  </xsl:template>
  
  <xsl:template match="part" mode="bookmark">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title font-weight="bold" color="green">
	<xsl:text>Part </xsl:text>
	<xsl:number count="part" from="/book" format="I"/>
	<xsl:text>—</xsl:text>
	<xsl:value-of select="./title" />
      </fo:bookmark-title>
      <xsl:apply-templates mode="bookmark"/>
    </fo:bookmark>
  </xsl:template>

  <xsl:template match="chapter" mode="bookmark">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
        <fo:bookmark-title font-weight="bold">
        <xsl:if test="not(ancestor::frontmatter) and $omit.chapnums='no'">
	       <xsl:number count="chapter" from="/book/mainmatter" level="any" format="1. "/>
        </xsl:if>
	<xsl:value-of select="./title" />
      </fo:bookmark-title>
         <xsl:if test="not(@stubout='yes')">
          <xsl:apply-templates mode="bookmark"/>
        </xsl:if>
    </fo:bookmark>
  </xsl:template>

  <xsl:template match="appendix" mode="bookmark">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title font-weight="bold">
        <xsl:if test="$omit.chapnums='no'">
	  <xsl:text>A</xsl:text>
	  <xsl:number count="appendix" from="/book/mainmatter" level="any" format="1. "/>
        </xsl:if>
	<xsl:value-of select="./title" />
      </fo:bookmark-title>
      <xsl:if test="not(@stubout='yes')">
	<xsl:apply-templates mode="bookmark"/>
      </xsl:if>
    </fo:bookmark>
  </xsl:template>
  
  <xsl:template match="bibsection" mode="bookmark">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title font-weight="bold">
	<xsl:text>Bibliography</xsl:text>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>

  <xsl:template match="index" mode="bookmark">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title font-weight="bold">
	<xsl:text>Index</xsl:text>
      </fo:bookmark-title>
      <xsl:apply-templates mode="bookmark"/>
    </fo:bookmark>
  </xsl:template>

  <xsl:template match="alpha-head" mode="bookmark">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title>
	<xsl:text>–&#160;</xsl:text>
	<xsl:value-of select="@heading"/>
	<xsl:text>&#160;–</xsl:text>
      </fo:bookmark-title>
    </fo:bookmark>
  </xsl:template>


  <xsl:template match="sect1" mode="bookmark">
    <xsl:if test="not(ancestor::backmatter) and not(@intoc='no')">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
	<xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title>
	<xsl:value-of select="./title" />
      </fo:bookmark-title>
    </fo:bookmark>
    </xsl:if>
  </xsl:template>

  <xsl:template match="recipe" mode="bookmark">
    <xsl:if test="not(@intoc='no')">
    <fo:bookmark>
      <xsl:attribute name="internal-destination">
        <xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title>
        <xsl:attribute name="font-weight">
          <xsl:choose>
            <xsl:when test="parent::book or parent::part">bold</xsl:when>
            <xsl:otherwise>normal</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="concat($recipetitle,' ')"/>
        <xsl:number count="recipe" from="/book" level="any" format="1. "/>
        <xsl:value-of select="./title" />
      </fo:bookmark-title>
      <xsl:if test="not(@stubout='yes')">
        <xsl:apply-templates mode="bookmark"/>
      </xsl:if>
    </fo:bookmark>    
    </xsl:if>
  </xsl:template>

  <xsl:template match="task" mode="bookmark">
    <xsl:if test="not(@intoc='no')">
     <fo:bookmark>
      <xsl:attribute name="internal-destination">
        <xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>
      <fo:bookmark-title>
        <xsl:attribute name="font-weight">
          <xsl:choose>
            <xsl:when test="parent::book or parent::part">bold</xsl:when>
            <xsl:otherwise>normal</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="$tasktitle"/><xsl:text> </xsl:text>
        <xsl:number count="task" from="/book" level="any" format="1. "/>
        <xsl:value-of select="./title" />
      </fo:bookmark-title>
      <xsl:apply-templates mode="bookmark"/>
    </fo:bookmark>    
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="bookmark"/>

</xsl:stylesheet>
