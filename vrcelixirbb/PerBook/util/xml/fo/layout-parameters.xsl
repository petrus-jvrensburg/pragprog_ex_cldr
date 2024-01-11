<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

<!-- Da rules:
     - params ending .number have no units
 -->

<!--
  Horizontal layout:

                 < - - -  page width  - - - >
   ____________________________________________________________
  |                                                            |
  |      |      |                                       |
   < A  > <  B > < - - - - - - - C - - - - - - - - - - ->

  A = dead margin - no printing here
  B = sidebar margin - where margin notes go
  C = typeblock width

-->


<!-- Parameters that control formatting -->

<xsl:param name="page.width.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'pguide' ">6</xsl:when>
    <xsl:when test="$booktype = 'airport' ">4.25</xsl:when>
    <xsl:otherwise>7.5</xsl:otherwise>
  </xsl:choose>
</xsl:param>
<xsl:param name="page.width"><xsl:value-of select="$page.width.number"/>in</xsl:param>
<xsl:param name="page.height.number">
    <xsl:choose>
    <xsl:when test="$booktype = 'airport' ">7</xsl:when>
    <xsl:otherwise>9</xsl:otherwise>
  </xsl:choose>
</xsl:param>
<xsl:param name="page.height"><xsl:value-of select="$page.height.number"/>in</xsl:param>

<xsl:param name="dead.margin.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'pguide' ">
        <xsl:choose>
          <xsl:when test="$target.recto-verso-headings = 'yes'">.875</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

    <xsl:when test="$booktype = 'airport' ">
        <xsl:choose>
          <xsl:when test="$target.recto-verso-headings = 'yes'">.20</xsl:when>
          <xsl:otherwise>0.25</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

    <xsl:otherwise>0.375</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="vertical.margin.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'pguide' ">0.275</xsl:when>
    <xsl:when test="$booktype = 'airport' ">0.125</xsl:when>
    <xsl:otherwise>0.375</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="page.margin.top"><xsl:value-of select="$vertical.margin.number"/>in</xsl:param>
<xsl:param name="page.margin.bottom">
  <xsl:choose>
    <xsl:when test="$booktype = 'pguide' ">0.625</xsl:when>
    <xsl:when test="$booktype = 'airport' ">0.325</xsl:when>
    <xsl:otherwise><xsl:value-of select="$vertical.margin.number"/></xsl:otherwise>
  </xsl:choose>
  <xsl:text>in</xsl:text></xsl:param>

<!-- For marginalia purposes -->
  <!-- Note: the text margins in general are:
           $page-master-horizontal-margin + $flow-indent
           In addition, the inner margin is adjusted by $region-body-offset.
           The text column width is what remains from:
           (2 * ($page-master-horizontal-margins.number + $flow-indent.number)) + $region-body-offset.number
  -->

<xsl:param name="page-master-horizontal-margins.number">0.2</xsl:param>
<xsl:param name="page-master-horizontal-margins"><xsl:value-of select="$page-master-horizontal-margins.number"/>in</xsl:param>
<xsl:param name="flow-indent.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport' ">0</xsl:when>
    <xsl:otherwise>0.88</xsl:otherwise>
  </xsl:choose>
</xsl:param>
<xsl:param name="flow-indent"><xsl:value-of select="$flow-indent.number"/>in</xsl:param>
<xsl:param name="region-body-offset-inner.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport'">
      <xsl:choose>
        <xsl:when test="$target.for-screen='yes'">0.375</xsl:when>
        <xsl:otherwise>0.5</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$target.for-screen='yes'">0.17</xsl:when>
        <xsl:when test="$target.for-screen='no'">0.34</xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>
<xsl:param name="region-body-offset-outer.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport'">
      <xsl:choose>
        <xsl:when test="$target.for-screen='yes'">0.375</xsl:when>
        <xsl:otherwise>0.25</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$target.for-screen='yes'">0.17</xsl:when>
        <xsl:when test="$target.for-screen='no'">0</xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="region-body-offset-inner"><xsl:value-of select="$region-body-offset-inner.number"/>in</xsl:param>
<xsl:param name="region-body-offset-outer"><xsl:value-of select="$region-body-offset-outer.number"/>in</xsl:param>


<!-- Regular body -->

<xsl:param name="typeblock.width.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'pguide' ">4</xsl:when>
    <xsl:when test="$booktype = 'airport' ">3.25</xsl:when>
    <xsl:otherwise>4.9</xsl:otherwise>
  </xsl:choose>
</xsl:param>
<!-- <xsl:param name="typeblock.height.number"> -->
<!--   <xsl:choose> -->
<!--     <xsl:when test="$booktype = 'airport' ">3.25</xsl:when> -->
<!--     <xsl:otherwise>7</xsl:otherwise> -->
<!--   </xsl:choose> -->
<!-- </xsl:param> -->
<xsl:param name="page.sidebar.margin.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'pguide' ">0</xsl:when>
    <xsl:when test="$booktype = 'airport' ">0</xsl:when>
    <xsl:otherwise>0.725</xsl:otherwise>
  </xsl:choose>
  </xsl:param>


<!-- special pages -->

<xsl:param name="praise.margin.top">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport' ">0.5in</xsl:when>
    <xsl:otherwise>1.5in</xsl:otherwise>
  </xsl:choose>
</xsl:param>
<xsl:param name="praise.margin.bottom">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport' ">0.5in</xsl:when>
    <xsl:otherwise>1.5in</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="space-before-contents-heading">56pt</xsl:param>
<xsl:param name="space-after-contents-heading">32pt</xsl:param>

<xsl:param name="page.header.extent.number">12</xsl:param>
<xsl:param name="page.header.extent"><xsl:value-of select="$page.header.extent.number"/>pt</xsl:param>
<xsl:param name="page.footer.extent.number">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport' ">0.15</xsl:when>
    <xsl:otherwise>0.541666</xsl:otherwise><!-- = 12pt +0.375in no-print -->
  </xsl:choose>
</xsl:param>  
<xsl:param name="page.footer.extent"><xsl:value-of select="$page.footer.extent.number"/>in</xsl:param>

<!-- Inline blocks like block quotes and lists -->
<xsl:param name="indented-block-indentation.number">0.25</xsl:param>
<xsl:param name="indented-block-indentation">0.25in</xsl:param>


<!-- indent controls for code and table fo:table elements. -->

<xsl:template name="fo-table-start-indent">
  <!-- Note: indent numbers eventually have units of inches. -->
  <xsl:variable name="indent-count">
    <xsl:value-of select="count(ancestor::ol) +
                          count(ancestor::ul) +
                          count(ancestor::blockquote)"/>
  </xsl:variable>

  <xsl:variable name="total-indent">
    <xsl:value-of select="$indent-count * $indented-block-indentation.number"/>
  </xsl:variable>

  <xsl:variable name="base-indent-number">
    <xsl:choose>
      <xsl:when test="ancestor::figure[@place]">
        <xsl:value-of select="0.2 + $flow-indent.number + $total-indent"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$flow-indent.number + $total-indent"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="table-start-indent.number">
    <xsl:choose>
      <xsl:when test="self::table">
        <xsl:value-of select="$base-indent-number"/>
      </xsl:when>
      <xsl:when test="self::processedcode">
        <xsl:value-of select="$base-indent-number - 0.5"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="(ancestor::chapter or ancestor::appendix or ancestor::recipe or ancestor::part)
      and not(ancestor::dl)
      and not(ancestor::example)
      and not(ancestor::blockquote)
      and not(ancestor::task)
      and not(ancestor::joeasks)
      and not(ancestor::said)
      and not(ancestor::story)
      and not(ancestor::table)
      and not(ancestor::sidebar)
      ">
       <xsl:value-of select="concat($table-start-indent.number,'in')"/>
    </xsl:when>

    <xsl:when test="ancestor::dl and self::table">
          <xsl:text>0in</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::blockquote and self::table">
      <xsl:text>inherit</xsl:text>
    </xsl:when>

    <xsl:when test="ancestor::blockquote and self::processedcode">
      <xsl:value-of select="concat($total-indent - 0.75,'in')"/>
    </xsl:when>

    <xsl:when test="ancestor::task and ancestor::chapter">
       <xsl:value-of select="concat($table-start-indent.number,'in')"/>
    </xsl:when>

    <xsl:when test="self::processedcode
                    and ancestor::sidebar
                    and (child::codeline[@prefix]
                         or child::codeline[@highlight='yes'])">
      <xsl:value-of select="concat($total-indent - 0.25,'in')"/>
    </xsl:when>

    <xsl:when test="(descendant::label or descendant::codeline[@lineno]) and
        (ancestor::sidebar
      or ancestor::figure
      or ancestor::story
      or ancestor::joeasks
      or ancestor::said)">
      <xsl:value-of select="concat($total-indent - 0.25,'in')"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="self::table">
          <xsl:text>0pt</xsl:text>
        </xsl:when>
        <xsl:when test="self::processedcode">
          <xsl:value-of select="concat($total-indent - 0.5,'in')"/>
        </xsl:when>
       </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="fo-table-end-indent">
<xsl:variable name="indent-count">
<xsl:value-of select="count(ancestor::ol) + count(ancestor::ul) + count(ancestor::blockquote)"/>
</xsl:variable>
<xsl:variable name="total-indent">
<xsl:value-of select="$indent-count * $indented-block-indentation.number"/>
</xsl:variable>
<xsl:choose>
    <xsl:when test="(ancestor::chapter or ancestor::appendix or ancestor::recipe or ancestor::part)
      and not(ancestor::dl)
      and not(ancestor::example)
      and not(ancestor::blockquote)
      and not(ancestor::task)
      and not(ancestor::joeasks)
      and not(ancestor::said)
      and not(ancestor::story)
      and not(ancestor::table)
      and not(ancestor::sidebar)
      ">
      <xsl:value-of select="concat($flow-indent.number,'in')"/>
    </xsl:when>
    <xsl:otherwise>0in</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- No changing below here... -->

<xsl:param name="page.margin.outer.number">
  <xsl:value-of select="$dead.margin.number + $page.sidebar.margin.number"/>
</xsl:param>

<xsl:param name="page.margin.outer"><xsl:value-of select="$page.margin.outer.number"/>in</xsl:param>

<xsl:param name="page.margin.inner.number">
  <xsl:value-of select="$page.width.number -
			    ($typeblock.width.number + $page.margin.outer.number)"/>
</xsl:param>

<xsl:param name="page.margin.inner"><xsl:value-of select="$page.margin.inner.number"/>in</xsl:param>
<xsl:param name="figure-font-percentage">90%</xsl:param>
<xsl:param name="small-font-percentage">95%</xsl:param>
<xsl:param name="visibly-small-font-percentage">85%</xsl:param>
<xsl:param name="small-table-font-percentage">80%</xsl:param>


<xsl:param name="alignment">justify</xsl:param>
<xsl:param name="line-height">
  <xsl:choose>
    <xsl:when test="$booktype = 'airport' ">1.4</xsl:when>
    <xsl:otherwise>1.4</xsl:otherwise>
</xsl:choose>
</xsl:param>


<!-- for debugging -->

<xsl:template match="page-params">
  <fo:table>
    <fo:table-body>
      <xsl:call-template name="dump-globals"/>
    </fo:table-body>
  </fo:table>
</xsl:template>

 <!-- Cut and paste this template into your own scripts -->
  <xsl:template name="dump-globals" version="1.0"
    xmlns:exsl="http://exslt.org/common"
    xmlns:dyn="http://exslt.org/dynamic"
    >

    <xsl:variable name="ctde" select="document('')/xsl:*"/>

    <xsl:for-each
      select="$ctde/xsl:variable|$ctde/xsl:param">

      <fo:table-row>

	<xsl:variable name="value" select="dyn:evaluate(concat('$', @name))"/>

        <fo:table-cell border="1px solid rgb-icc(220, 220, 220, #Grayscale, 0.83)">
	  <fo:block>
	    <xsl:value-of select="@name"/><xsl:text>:</xsl:text>
	  </fo:block>
	</fo:table-cell>

        <fo:table-cell border="1px solid rgb-icc(220, 220, 220, #Grayscale, 0.83)">
	  <fo:block>
	    <xsl:choose>
	      <xsl:when test="exsl:object-type($value) = 'node-set'">
		<xsl:copy-of select="$value"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="$value"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </fo:block>
	</fo:table-cell>
      </fo:table-row>
    </xsl:for-each>

  </xsl:template>
</xsl:stylesheet>
