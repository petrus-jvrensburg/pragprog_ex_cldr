<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:pp="http://pragprog.com"
version="2.0">

<xsl:include href="airport-copyright.xsl"/>

<xsl:param name="copyright-fs">8pt</xsl:param>

<xsl:template name="title.title-page">
  <fo:page-sequence format="i"
  master-reference="title"
  initial-page-number="auto-odd">
  <xsl:if test="not(descendant::praisepage)">
    <xsl:attribute name="initial-page-number">1</xsl:attribute>
  </xsl:if>
  <xsl:if test="$extracts='yes'">
    <xsl:attribute name="force-page-count">no-force</xsl:attribute>
  </xsl:if>
  <fo:static-content flow-name="imprint-name">
    <xsl:call-template name="imprint-name"/>
  </fo:static-content>

  <fo:flow flow-name="xsl-region-body">

    <!--  Let's be bold and lose the half-title page
      <xsl:if test="$target.for-screen='no'">
      <xsl:call-template name="title.half-title"/>
      </xsl:if>
    -->
      <xsl:call-template name="title.full-title"/>
      <xsl:choose>
        <xsl:when test="$booktype = 'airport'">
          <xsl:call-template name="airport.copyright"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="title.copyright"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<!-- half title -->

<xsl:template name="title.half-title">
  <fo:block>
    <xsl:call-template name="write-title-and-subtitle"/>
  </fo:block>
</xsl:template>

<!-- full title -->

<xsl:template name="title.full-title">
  <fo:block text-align="right">

    <xsl:call-template name="write-title-and-subtitle"/>

    <fo:block space-before="1in"
    font-family="{$sans.font.family}"
    font-size="14pt"
    >
    <xsl:for-each select="/book/bookinfo/authors/person">
      <fo:block space-before="0pt">
        <xsl:apply-templates select="name" />
      </fo:block>
    </xsl:for-each>
  </fo:block>

  <xsl:if test="/book/bookinfo/withauthors/person/name">
    <fo:block space-before="1in"
    font-family="{$sans.font.family}"
    font-size="12pt">
    <xsl:for-each select="/book/bookinfo/withauthors/person">
      <fo:block>
        <xsl:if test="not(preceding-sibling::person)">
          <fo:inline space-before="0pt"><xsl:text>with </xsl:text></fo:inline>
        </xsl:if>
        <xsl:apply-templates select="name" />
      </fo:block>
    </xsl:for-each>
  </fo:block>
</xsl:if>

    </fo:block>
  </xsl:template>

  <!-- copyright -->

  <xsl:template name="title.copyright">
    <fo:block break-before="page" space-before="2in" space-before.conditionality="retain" >

    <xsl:call-template name="copyright-masthead"/>


    <fo:block-container font-size="{$copyright-fs}" space-before="20pt" margin-left="0pt" margin-right="24pt">
      <xsl:call-template name="copyright.text"/>
      <xsl:call-template name="pp:extra-rights"/>
      <xsl:call-template name="contact.text"/>

      <xsl:apply-templates select="/book/bookinfo/production-info"/>
      <fo:block space-before="6pt" space-after="4pt" font-size="8pt">
        For sales, volume licensing, and support, please contact
        <xsl:call-template name="external-link">
          <xsl:with-param name="url">
            <xsl:value-of select="'support@pragprog.com'"/>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:copy-of select="'support@pragprog.com'"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>.</xsl:text>
      </fo:block>
      <fo:block space-before="6pt" space-after="4pt">
        For international rights, please contact
        <xsl:call-template name="external-link">
          <xsl:with-param name="url">
            <xsl:value-of select="'rights@pragprog.com'"/>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:copy-of select="'rights@pragprog.com'"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>.</xsl:text>
      </fo:block>

    </fo:block-container>


    <fo:block-container font-family="{$heading.font.family}"
    font-size="6.5pt"
    space-before="24pt"
    margin-left="0pt"
    >


    <fo:block font-size="{$copyright-fs}" space-before="24pt">
      <xsl:text>Copyright © </xsl:text>
      <xsl:apply-templates select="/book/bookinfo/copyright/copyrightdate"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="/book/bookinfo/copyright/copyrightholder"/>
      <xsl:text>.</xsl:text>
    </fo:block>

    <!--	<fo:block>
      All rights reserved.
      </fo:block>
    -->
      <fo:block space-before="12pt" space-after="12pt"
      line-height="100%"
      end-indent="1.5in">
        All rights reserved. No part of this publication may be
        reproduced, stored in a retrieval system, or transmitted, in any form,
        or by any means, electronic, mechanical, photocopying, recording, or
        otherwise, without the prior consent of the publisher.
    </fo:block>

    <!--	  <fo:block space-before="6pt">
      <xsl:text>Printed in </xsl:text>
      <xsl:call-template name="country-of-manufacture"/>
      <xsl:text>.</xsl:text>
      </fo:block>
    -->

      <!-- support hardcover ISBN -->
      <xsl:choose>
        <xsl:when test="/book/bookinfo/isbn13-hardcover !=''">
          <fo:block>
            <xsl:text>ISBN-13 (Paperback edition): </xsl:text>
            <xsl:value-of select="/book/bookinfo/isbn13"/>
          </fo:block>

          <fo:block>
            <xsl:text>ISBN-13 (Hardcover edition): </xsl:text>
            <xsl:value-of select="/book/bookinfo/isbn13-hardcover"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <!-- legacy behavior -->
          <fo:block>
            <xsl:text>ISBN-13: </xsl:text>
            <xsl:value-of select="/book/bookinfo/isbn13"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>

      <!-- info about paper or "finest bits" -->
      <!-- only want this for screen versions. -->
      <xsl:if test="$target.for-screen='yes'">
        <fo:block>
          <xsl:call-template name="pp:paper-content"/>
        </fo:block>
      </xsl:if>

      <fo:block>
        <xsl:text>Book version: </xsl:text>
        <xsl:value-of select="/book/bookinfo/printing/printingnumber"/>
        <xsl:text>—</xsl:text>
        <xsl:value-of select="/book/bookinfo/printing/printingdate"/>
      </fo:block>

    </fo:block-container>
    <!--
      <fo:block>
      <xsl:text>Formatted: </xsl:text>
      .....
      </fo:block>
    -->

    </fo:block>
  </xsl:template>

  <xsl:template match="copyrightdate | copyrightholder | mainmatter">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/book/bookinfo/authors/person/name">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="/book/bookinfo/withauthors/person/name">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="write-title-and-subtitle">
    <fo:block padding-top="2in"
    text-align="right"
    line-height="100%"
    margin-bottom="10px"
    >
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="/book/bookinfo/booktitle/@size='normal'">23pt</xsl:when>
        <xsl:when test="/book/bookinfo/booktitle/@size='small'">21pt</xsl:when>
        <xsl:when test="/book/bookinfo/booktitle/@size='smaller'">19pt</xsl:when>
        <xsl:when test="/book/bookinfo/booktitle/@size='smallest'">16pt</xsl:when>
        <xsl:otherwise>23pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <fo:inline
    border-bottom="3pt solid"
    border-bottom-color="{$color.heading-underline}"
    >
    <xsl:attribute name="padding-bottom">
      <xsl:choose>
        <xsl:when test="/book/bookinfo/booktitle/@size='normal'">-11.9px</xsl:when>
        <xsl:when test="/book/bookinfo/booktitle/@size='small'">-10.9px</xsl:when>
        <xsl:when test="/book/bookinfo/booktitle/@size='smaller'">-9.9px</xsl:when>
        <xsl:when test="/book/bookinfo/booktitle/@size='smallest'">-8.3px</xsl:when>
        <xsl:otherwise>-11.9px</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="/book/bookinfo/booktitle"/>
  </fo:inline>
</fo:block>

<fo:block
text-align="right"
line-height="100%"
>
<xsl:variable name="font-size">
  <xsl:choose>
    <xsl:when test="/book/bookinfo/booksubtitle/@size='normal'">13</xsl:when>
    <xsl:when test="/book/bookinfo/booksubtitle/@size='small'">12</xsl:when>
    <xsl:when test="/book/bookinfo/booksubtitle/@size='smaller'">11</xsl:when>
    <xsl:when test="/book/bookinfo/booksubtitle/@size='smallest'">10</xsl:when>
    <xsl:otherwise>13</xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="line-height" select="$font-size * 1.2" />

<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/>pt</xsl:attribute>
<xsl:attribute name="line-height"><xsl:value-of select="$line-height"/>pt</xsl:attribute>

<xsl:apply-templates select="/book/bookinfo/booksubtitle"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="/book/bookinfo/booktitle">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="/book/bookinfo/booksubtitle">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="imprint-name">
    <fo:block
    text-align="right"
    color="{$color.imprint-name}"
    >

    <fo:block font-family="Bookman" font-size="13pt">
      <fo:inline
      border-bottom="1pt solid"
      border-bottom-color="{$color.imprint-border-bottom}"
      padding-bottom="-4pt">
        The Pragmatic Bookshelf
    </fo:inline>
  </fo:block>
  <fo:block font-family="{$sans.font.family}"
  font-size="8pt">
  <xsl:text>
    Dallas, Texas
  </xsl:text>
</fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="production-info">
    <fo:block space-before="6pt" space-after="4pt">
      The team that produced this book includes:
    </fo:block>
    <fo:table>
      <fo:table-body>
        <xsl:apply-templates/>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!--
    | founders
    | vpoperations
  -->
  <xsl:template match="ceo 
  | coo
  | copyeditor 
  | editor
  | executiveeditor
  | indexer
  | managingeditor
  | producer
  | publisher
  | supervisingeditor
  | support
  | typesetter
  | vpoperations
  ">
  <xsl:if test="string-length(.) &gt; 0">
    <fo:table-row>
      <fo:table-cell>
        <fo:block font-size="90%">
          <xsl:apply-templates select="." mode="job-role"/>
          <xsl:text>: </xsl:text>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block text-align="left" width="1.5em">
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:apply-templates />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:if>
</xsl:template>

<xsl:template match="ceo"                mode="job-role">CEO</xsl:template>
<xsl:template match="coo"                mode="job-role">COO</xsl:template>
<xsl:template match="copyeditor"         mode="job-role">Copy Editor</xsl:template>
<xsl:template match="editor"             mode="job-role">Development Editor</xsl:template>
<xsl:template match="indexer"            mode="job-role">Indexing</xsl:template>
<xsl:template match="managingeditor"     mode="job-role">Managing Editor</xsl:template>
<xsl:template match="producer"           mode="job-role">Producer</xsl:template> <!-- legacy -->
<xsl:template match="publisher"          mode="job-role">Publisher</xsl:template>
<xsl:template match="supervisingeditor"  mode="job-role">Supervising Editor</xsl:template>
<xsl:template match="support"            mode="job-role">Support</xsl:template>  <!-- legacy -->
<xsl:template match="typesetter"         mode="job-role">Layout</xsl:template>
<!-- legacy -->
<xsl:template match="founders"           mode="job-role">Founders</xsl:template>
<xsl:template match="vpoperations"       mode="job-role">VP of Operations</xsl:template>
<xsl:template match="executiveeditor"    mode="job-role">Executive Editor</xsl:template> <!-- legacy -->


<xsl:template match="rights"/>

<xsl:template match="series-editor">
  <xsl:if test="string-length(.) &gt; 0">
    <fo:block>
      <xsl:value-of select="'Series Editor'"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates />
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template name="do-dedication-page">
  <fo:page-sequence format="i"
  master-reference="title"
  xsl:use-attribute-sets="end-on-even">
  <xsl:call-template name="blank-page-setup"/>
  <fo:flow flow-name="xsl-region-body">
    <xsl:apply-templates select="frontmatter/dedication"></xsl:apply-templates>
  </fo:flow>
</fo:page-sequence>
  </xsl:template>


  <xsl:template match="dedication">
    <xsl:for-each select="p[position() = 1]">
      <fo:block margin-top="1.96in" text-align="center" font-style="italic" margin-left="1in" margin-right="1in">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:for-each>
    <xsl:for-each select="p[position() != 1]">
      <fo:block margin-top="8pt" text-align="center" font-style="italic" margin-left="1in" margin-right="1in">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:for-each>
    <xsl:for-each select="name">
      <fo:block margin-top="6pt" text-align="right" margin-right="12pt">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
