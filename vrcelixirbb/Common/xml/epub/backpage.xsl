<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0">

  <!-- Added backmatter and related elements. -->
  <xsl:template match="backpage">
  </xsl:template>

  <xsl:template match="ad">
    <h3>
      <xsl:value-of select="title"/>
    </h3>
      <div class="cover-image">
        <a href="http://pragmaticprogrammer.com/titles/{bookcode}">
    <img src="images/_covers/{concat(bookcode,'.jpg')}" alt="{booktitle}"/>
        </a>
      </div>
      <p><xsl:value-of select="blurb/p"/></p>
      <p><xsl:value-of select="author-list"/></p>
      <p>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="pagecount"/>
        <xsl:text> pages)</xsl:text>
        <xsl:text> ISBN: </xsl:text>
        <xsl:value-of select="isbn13"/>
        <xsl:text> $</xsl:text>
        <xsl:value-of select="price"/>
      </p>
  </xsl:template>

  <xsl:template match="coupon">
    <div class="backmatter-cover">
    <xsl:if test="string-length(title) &gt; 0">
      <xsl:apply-templates select="title" mode="force"/>
    </xsl:if>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="adpage">
    <xsl:if test="@codes">
  <!-- SAXON change: <xsl:for-each select="str:tokenize(@codes, ' ')"> -->
  <xsl:for-each select="tokenize(@codes, ' ')">
	<div class="backmatter-cover">
	  <xsl:variable name="path">
	    <xsl:text>../../../Common/backmatter/ads/</xsl:text>
	    <xsl:value-of select="."/>
	    <xsl:text>.pml</xsl:text>
	  </xsl:variable>
	  <xsl:apply-templates select="document($path)/ad"/>
	  </div>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ads[child::adpage]">
    <h2>You May Be Interested In…</h2>
    <p>
      <em>Select a cover for more information</em>
    </p>
    <div class="backmatter-covers">
      <xsl:apply-templates/>
    </div>
    <hr class="backmatter-end"/>
  </xsl:template>


</xsl:stylesheet>
