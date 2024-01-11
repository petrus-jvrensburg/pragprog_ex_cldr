<?xml version='1.0' encoding='UTF-8'?>
<!--
<!DOCTYPE xsl:stylesheet [
  <!ENTITY  copyright "&#xA9;">
  <!ENTITY  trademark "&#x2122;">
  <!ENTITY  registered "&#xAE;">
  <!ENTITY  section "&#xA7;">
  <!ENTITY  endash "&#x2013;">
  <!ENTITY  emdash "&#x2014;">
  <!ENTITY  quotedblleft "&#x201C;">
  <!ENTITY  quotedblright "&#x201D;">
]>                 
-->
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:rx="http://www.renderx.com/XSL/Extensions"
		xmlns:pp="http://pragprog.com"
		>

  <xsl:output method="xml" version="1.0"/>         
  
  <xsl:variable name="bib" select="document('../../../Book/bib_extract.xml')/bib-extract"/>
  <xsl:variable name="booktype" select="/book/bookinfo/@booktype"/>

  <xsl:param name="in.dir">!!missing!!</xsl:param>

  <xsl:param name="extracts"/>

  <xsl:param name="book-code">
    <xsl:value-of select="/book/bookinfo/@code"/>
  </xsl:param>
  
  <!--  these are set by external parameters -->
  <xsl:param name="ignore-workflow-tags" select="'no'"/>
  <xsl:param name="covers-root-dir" 
	     select="'PLEASE SET YOUR PPCOVERS ENVIRONMENT VARIABLE'"/>
 
  <xsl:param name="chapter">no</xsl:param>
  <xsl:param name="color">yes</xsl:param>
  <xsl:param name="sitb">no</xsl:param>

  <!--
      the file target_parameters is in fo/_targets/{paper|screen}, and contains the things that
      vary depending on the target
  -->
  
  <xsl:include href="fo/_targets/screen/target-parameters.xsl"/>

  <xsl:include href="ppb2fo-common.xsl"/>

  <!-- in fo/_targets -->

  <xsl:include href="fo/_targets/screen/build-image-list.xsl"/>  
  <xsl:include href="fo/_targets/screen/paper-content.xsl"/>
  <xsl:include href="fo/_targets/screen/page-decoration.xsl"/>
  <xsl:include href="fo/_targets/screen/draw-cover.xsl"/>
  <xsl:include href="fo/_targets/screen/backpage.xsl"/>


</xsl:stylesheet>
