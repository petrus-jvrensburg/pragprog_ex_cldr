<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
version="2.0"> 

<xsl:param name="praise.font.size">
          <xsl:choose>
            <xsl:when test="$booktype = 'airport' ">8.5pt</xsl:when>
            <xsl:otherwise>9</xsl:otherwise>
          </xsl:choose>
</xsl:param>

<xsl:template name="do-praise-page">
  <fo:page-sequence xsl:use-attribute-sets="end-on-even" master-reference="praise" format="i" initial-page-number="1">
    <xsl:call-template name="blank-page-setup"/>
    <fo:flow flow-name="xsl-region-body">
      <fo:block>
        <xsl:apply-templates select="frontmatter/praisepage"/>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="praisepage">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="praisetitle">
  <fo:block xsl:use-attribute-sets="heading-font"
  margin-bottom="12pt"
  text-align="center"
  font-weight="bold"
  font-size="120%">
  <xsl:apply-templates />
</fo:block>
</xsl:template>

<xsl:template match="praisetitle/booksectname">
  <fo:block font-size="110%" font-style="italic">
    <xsl:apply-templates />
  </fo:block>
</xsl:template>


<xsl:template match="praiseentry">
  <fo:block font-size="{$praise.font.size}" space-before="11pt" keep-together.within-page="2">
    <xsl:apply-templates />
  </fo:block>
</xsl:template>

<xsl:template match="praiseentry/praise">
  <fo:block-container margin-left="0pt" margin-right="0pt" text-align="left">
    <xsl:apply-templates />
  </fo:block-container>
</xsl:template>


<xsl:template match="praiseentry/person">
  <fo:list-block margin-top="-4pt" provisional-distance-between-starts="1.5em"> 
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block font-family="{$symbol.font.family}">
          <xsl:text>&#x27a4;</xsl:text>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block font-weight="bold">
          <xsl:apply-templates select="name"/>
        </fo:block>
        <xsl:if test="jobtitle or affiliation">
          <fo:block text-align="left">
            <xsl:if test="jobtitle">
              <xsl:apply-templates select="jobtitle"/>
              <xsl:if test="affiliation">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:if>
            <xsl:if test="affiliation">
              <xsl:apply-templates select="affiliation"/>
            </xsl:if>
          </fo:block>
        </xsl:if>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>

<xsl:template match="praiseentry/person/name">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="praiseentry/person/jobtitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="praiseentry/person/affiliation">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
