<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:param name="bullets">
    <xsl:text>&#x2776;</xsl:text>
    <xsl:text>&#x2777;</xsl:text>
    <xsl:text>&#x2778;</xsl:text>
    <xsl:text>&#x2779;</xsl:text>
    <xsl:text>&#x277A;</xsl:text>
    <xsl:text>&#x277B;</xsl:text>
    <xsl:text>&#x277C;</xsl:text>
    <xsl:text>&#x277D;</xsl:text>
    <xsl:text>&#x277E;</xsl:text>
    <xsl:text>&#x277F;</xsl:text>
    <xsl:text>&#x24eb;</xsl:text>
    <xsl:text>&#x24ec;</xsl:text>
    <xsl:text>&#x24ed;</xsl:text>
    <xsl:text>&#x24ee;</xsl:text>
    <xsl:text>&#x24ef;</xsl:text>
    <xsl:text>&#x24f0;</xsl:text>
    <xsl:text>&#x24f1;</xsl:text>
    <xsl:text>&#x24f2;</xsl:text>
    <xsl:text>&#x24f3;</xsl:text>
    <xsl:text>&#x24f4;</xsl:text>

  </xsl:param>

  <xsl:template match="processedcode">
    <xsl:variable name="indent-count">
      <xsl:value-of select="count(ancestor::ol) +
                            count(ancestor::ul) +
                            count(ancestor::blockquote)"/>
    </xsl:variable>
    <xsl:variable name="total-indent">
      <xsl:value-of select="$indent-count *
                            $indented-block-indentation.number"/>
    </xsl:variable>

    <xsl:if test="@showname != 'no'">
      <xsl:call-template name="show-name">
        <xsl:with-param name="total-indent">
          <xsl:value-of select="$total-indent"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:call-template name="code-listing"/>
  </xsl:template>



  <xsl:template name="show-name">
    <xsl:param name="total-indent"/>

    <xsl:if test="string-length(@url) &gt; 0">
      <fo:block keep-with-next="always"
                space-before.minimum="6pt"
                space-before.optimum="6pt"
                space-before.maximum="10pt"
                space-before.conditionality="discard"
                padding-left="0.3em"
                font-family="{$sans.font.family}"
                font-weight="bold"
                xsl:use-attribute-sets="code-lozenge">
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="contains(@size,'small')">75%</xsl:when>
            <xsl:otherwise>80%</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:if test="@id">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
        </xsl:if>
        <fo:block hyphenation-character="&#xac;">
          <xsl:attribute name="text-indent">0in</xsl:attribute>
          <xsl:attribute name="start-indent">
            <xsl:choose>
              <xsl:when test="ancestor::sidebar
                              or ancestor::dialog
                              or ancestor::said-by
                              or ancestor::highlight
                              or (ancestor::task and not(ancestor::chapter))
                              or ancestor::joeasks
                              or ancestor::someone-says">
                <xsl:value-of select="concat($total-indent,'in')"/>
              </xsl:when>
              <xsl:when test="ancestor::dl or ancestor::blockquote">
                <xsl:value-of select="'0in'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat(($flow-indent.number + $total-indent),'in')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="end-indent">
            <xsl:call-template name="fo-table-end-indent"/>
          </xsl:attribute>
          <xsl:call-template name="livecode-link">
            <xsl:with-param name="link">
              <xsl:value-of select="@url"/>
            </xsl:with-param>
            <xsl:with-param name="text">
              <xsl:value-of select="@showname"/>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </fo:block>
    </xsl:if>
  </xsl:template>   <!-- show-name -->

  <xsl:template name="code-listing">
    <fo:table font-family="{$mono.font.family}"
              font-size="80%"
              margin-left="0pt"
              margin-right="0pt"
              space-before.minimum="0pt"
              space-before.optimum="0pt"
              space-before.maximum="0pt"
              space-before.conditionality="discard">

      <xsl:choose>
        <xsl:when test="local-name(..) = 'col'">
          <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
          <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
          <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="space-after.minimum">6pt</xsl:attribute>
          <xsl:attribute name="space-after.optimum">8pt</xsl:attribute>
          <xsl:attribute name="space-after.maximum">10pt</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:attribute name="start-indent">
        <xsl:call-template name="fo-table-start-indent"/>
      </xsl:attribute>
      <xsl:attribute name="end-indent">
        <xsl:call-template name="fo-table-end-indent"/>
      </xsl:attribute>

      <xsl:call-template name="add-id"/>

      <fo:table-column column-number="1" column-width="0.5in" text-align="right"/>
      <fo:table-column column-number="2" column-width="100%"/>
      <fo:table-body start-indent="0in"
                     end-indent="{concat($flow-indent.number - 0.38,'in')}">

        <xsl:call-template name="padding-row">
          <xsl:with-param name="border">top</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
        <xsl:call-template name="padding-row">
          <xsl:with-param name="border">bottom</xsl:with-param>
        </xsl:call-template>
      </fo:table-body>
    </fo:table>

    <!-- RenderX has a bug - if the last element in a float is a
         list-block, it omits the rest of the text from the page.
         So we check to see if this is in a float and add a block
         if this is the last one. -->
    <xsl:if test="ancestor::sidebar
                  or ancestor::dialog
                  or ancestor::said-by
                  or ancestor::highlight
                  or ancestor::figure
                  or ancestor::someone-says
                  and not(following-sibling::*)">
      <fo:block/>
    </xsl:if>

  </xsl:template>


  <xsl:template name="padding-row">
    <xsl:param name="border"/>
    <xsl:if test="@style='shaded'">
      <fo:table-row>
        <fo:table-cell>
        </fo:table-cell>
        <fo:table-cell>
          <fo:block line-height="0.05in">
            <xsl:attribute name="background">
              <xsl:value-of select="$color.code-shaded-background"/>
            </xsl:attribute>
            <xsl:if test="$border='top'">
              <xsl:attribute name="border-top">
                <xsl:text>0.5pt solid </xsl:text>
                <xsl:value-of select="$color.table-outer-line"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$border='bottom'">
              <xsl:attribute name="border-bottom">
                <xsl:text>0.5pt solid </xsl:text>
                <xsl:value-of select="$color.table-outer-line"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:text>&#160;</xsl:text>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>

  <xsl:template match="codeline">
    <xsl:variable name="indent-count">
      <xsl:value-of select="count(ancestor::ol) + count(ancestor::ul) + count(ancestor::blockquote)"/>
    </xsl:variable>
    <xsl:variable name="total-indent">
      <xsl:value-of select="$indent-count * $indented-block-indentation.number"/>
    </xsl:variable>
    <fo:table-row>
      <fo:table-cell display-align="center">
        <fo:block text-align="right" margin-right="7pt" font-size="85%" color="{$color.code-marginalia}" font-family="{$sans.font.family}">
          <xsl:choose>
            <xsl:when test="@prefix='in'">
              <fo:inline font-family="{$symbol.font.family}" font-size="140%">&#x27be;</fo:inline>
            </xsl:when>
            <xsl:when test="@prefix='out'">
              <fo:inline font-family="{$symbol.font.family}" font-size="140%">&#x276e;</fo:inline>
            </xsl:when>
            <xsl:when test="@prefix or child::label">
              <xsl:choose>
                <xsl:when test="@prefix">
                  <xsl:value-of select="@prefix"/>
                </xsl:when>
                <xsl:when test="not(preceding-sibling::codeline)"><xsl:text>Line 1</xsl:text></xsl:when>
                <xsl:otherwise><xsl:value-of select="count(preceding-sibling::codeline) + 1"></xsl:value-of></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@calloutno or child::callout">
              <xsl:variable name="calloutno">
                <xsl:value-of select="count(preceding-sibling::codeline/@calloutno) + count(preceding-sibling::codeline/callout) + 1"/>
              </xsl:variable>
              <fo:inline font-size="150%">
                <xsl:call-template name="callout-dingbat">
                  <xsl:with-param name="index">
                    <xsl:value-of select="$calloutno"/>
                  </xsl:with-param>
                </xsl:call-template>
              </fo:inline>
            </xsl:when>
            <xsl:when test="preceding-sibling::codeline/label or following-sibling::codeline/label">
              <xsl:choose>
                <xsl:when test="not(preceding-sibling::codeline)"><xsl:text>Line 1</xsl:text></xsl:when>
                <xsl:otherwise><xsl:value-of select="count(preceding-sibling::codeline) + 1"></xsl:value-of></xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@highlight='yes'">
              <fo:inline font-family="{$symbol.font.family}" font-size="130%">&#x27a4;</fo:inline>
            </xsl:when>
          </xsl:choose>

        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block text-align="start"
                  white-space-collapse="false"
                  white-space-treatment="preserve"
                  linefeed-treatment="preserve"
                  wrap-option="no-wrap"
                  margin-top="0pt"
                  margin-bottom="0pt"
                  padding-top="0pt"
                  padding-bottom="0pt">

	  <xsl:choose>
	    <xsl:when test="@toolong">
	      <xsl:attribute name="background">
		<xsl:text>rgb(150, 0, 0)</xsl:text>
	      </xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::processedcode[@style='shaded']">
              <xsl:attribute name="background">
                <xsl:value-of select="$color.code-shaded-background"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>

          <xsl:attribute name="line-height">
            <xsl:choose>
              <xsl:when test="not(.//text()) or @blank='yes'">
                <xsl:text>70%</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>140%</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <xsl:text>&#8203;</xsl:text>
          <!-- without this, the first line is indented if it starts with a tag -->
          <xsl:apply-templates mode="code"/>
          <xsl:text>&#10;</xsl:text>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="standin" mode="code">
    <fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="costring" mode="code">
    <fo:inline xsl:use-attribute-sets="costring">
      <xsl:apply-templates mode="code"/>
      </fo:inline><xsl:text>&#8203;</xsl:text>
  </xsl:template>

  <xsl:template match="cokw" mode="code"><xsl:choose>
    <xsl:when test="following-sibling::cobold or preceding-sibling::cobold"><fo:inline><xsl:apply-templates mode="code"/></fo:inline></xsl:when>
    <xsl:otherwise><fo:inline xsl:use-attribute-sets="cokw"><xsl:apply-templates mode="code"/></fo:inline></xsl:otherwise>
  </xsl:choose><xsl:text>&#8203;</xsl:text></xsl:template>

  <xsl:template match="coprompt" mode="code">
    <fo:inline xsl:use-attribute-sets="coprompt">
      <xsl:apply-templates mode="code"/>
      </fo:inline><xsl:text>&#8203;</xsl:text>
  </xsl:template>

  <xsl:template match="cotag" mode="code">
    <fo:inline xsl:use-attribute-sets="cotag">
      <xsl:apply-templates mode="code"/>
      </fo:inline><xsl:text>&#8203;</xsl:text>
  </xsl:template>

  <xsl:template match="cocomment" mode="code">
    <fo:inline xsl:use-attribute-sets="cocomment">
      <xsl:apply-templates mode="code"/>
      </fo:inline><xsl:text>&#8203;</xsl:text>
  </xsl:template>

  <xsl:template match="cobold" mode="code">
    <fo:inline xsl:use-attribute-sets="cokw">
      <xsl:apply-templates mode="code"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="cref">
    <xsl:variable name="linkend" select="@linkend"/>
    <xsl:variable name="target" select="generate-id(//codeline[descendant-or-self::*[@id = $linkend]])"/>

    <xsl:choose>
      <xsl:when test="$target">
	<xsl:value-of select="count(//codeline[generate-id() = $target]/preceding-sibling::codeline) + 1" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>
	  <xsl:text>***** Error: missing cross reference target: </xsl:text>
	  <xsl:value-of select="@linkend"/>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="coref" name="coref">
    <xsl:variable name="target" select="id(@linkend)"/>
    <xsl:variable name="index">
      <xsl:value-of select="count($target/ancestor-or-self::codeline/preceding-sibling::codeline/@calloutno)
                            + count($target/ancestor-or-self::codeline/preceding-sibling::codeline/callout) + 1"/>
    </xsl:variable>
    <xsl:call-template name="callout-dingbat">
      <xsl:with-param name="index"><xsl:value-of select="$index"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="callout-dingbat">
    <xsl:param name="index"/>
    <fo:inline font-family="Corbel"><xsl:value-of select="substring($bullets, number($index), 1)"/></fo:inline>
  </xsl:template>

  <xsl:template match="label"/>

  <!-- eof may appear inside cokw. -->


  <xsl:attribute-set name="eof-attributes">
    <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size">75%</xsl:attribute>
    <xsl:attribute name="font-weight">bolder</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="eof">
    <xsl:call-template name="eof"/>
  </xsl:template>

  <xsl:template match="eof" mode="code">
    <xsl:call-template name="eof"/>
  </xsl:template>

  <xsl:template name="eof">&#x200b;<fo:inline xsl:use-attribute-sets="eof-attributes" baseline-shift="15%" margin-right="-0.25pt" padding-left="-1pt">E</fo:inline>&#x200b;<fo:inline xsl:use-attribute-sets="eof-attributes">O</fo:inline>&#x200b;<fo:inline xsl:use-attribute-sets="eof-attributes" margin-left="-0.5pt" baseline-shift="-15%">F</fo:inline>&#x200b;</xsl:template>


</xsl:stylesheet>
