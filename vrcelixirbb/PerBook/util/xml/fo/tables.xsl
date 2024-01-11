<?xml version="1.0"?>

<xsl:stylesheet version="2.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- the original simpletable -->

  <xsl:template match="table" name="table">

    <xsl:param name="backmatter"/>

    <xsl:call-template name="table-contents">
      <xsl:with-param name="backmatter" select="$backmatter"/>
    </xsl:call-template>

    <xsl:if test="title">
      <xsl:call-template name="table-title"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="table[@inline='no']">

    <xsl:param name="backmatter"/>
    <fo:float float="before">

      <xsl:call-template name="table-contents">
        <xsl:with-param name="backmatter" select="$backmatter"/>
      </xsl:call-template>

      <xsl:if test="title">
        <xsl:call-template name="table-title"/>
      </xsl:if>

      <xsl:if test="not(child::title)">
        <fo:block line-height="0pt">&#160;</fo:block>
      </xsl:if>
    </fo:float>
  </xsl:template>

  <xsl:template name="table-contents">

    <xsl:param name="backmatter"/>
    <fo:block>

      <xsl:apply-templates select="i"/>
      <fo:table>

        <xsl:call-template name="add-id"/>

        <xsl:attribute name="start-indent">
          <xsl:call-template name="fo-table-start-indent"/>
        </xsl:attribute>

        <xsl:attribute name="end-indent">
          <xsl:call-template name="fo-table-end-indent"/>
        </xsl:attribute>

        <xsl:if test="$backmatter != 'yes'">

          <xsl:attribute name="margin-bottom">6pt</xsl:attribute>
        </xsl:if>

        <xsl:if test="@style='outerlines' or @style='hlines' or string-length(//book/options/tablestyle/@style) &gt; 0">

          <xsl:if test="not(@style='no-lines')">

            <xsl:if test="not(./thead)">

              <xsl:attribute name="border-top">1.5pt solid</xsl:attribute>

              <xsl:attribute name="border-top-color">
                <xsl:value-of select="$color.table-outer-line"/>
              </xsl:attribute>
            </xsl:if>

            <xsl:attribute name="border-bottom">1.5pt solid</xsl:attribute>

            <xsl:attribute name="border-bottom-color">
              <xsl:value-of select="$color.table-outer-line"/>
            </xsl:attribute>

            <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
            <!-- DT 11/30/14
               <xsl:attribute name="padding-top">3pt</xsl:attribute>
          -->
            <!-- DT 10/31/14
	      <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
          -->
          </xsl:if>
        </xsl:if>

        <xsl:apply-templates select="colspec"/>

        <xsl:apply-templates select="thead"/>
        <fo:table-body end-indent="0pt" start-indent="0pt">
          <xsl:apply-templates select="./row"/>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="table-title">
    <fo:block font-family="{$sans.font.family}"
              keep-with-previous="always"
              padding-bottom="0pt"
              space-after="4pt"
              space-before="-4pt"
              text-align="left">

      <xsl:attribute name="start-indent">

        <xsl:choose>

          <xsl:when test="ancestor::ol or ancestor::ul or ancestor::dl">

            <xsl:variable name="total-indent">
              <xsl:value-of select="$flow-indent.number + $indented-block-indentation.number"/>
            </xsl:variable>

            <xsl:value-of select="concat($total-indent,'in')"/>
          </xsl:when>

          <xsl:when test="ancestor::table">
            0pt
          </xsl:when>

          <xsl:otherwise><xsl:value-of select="$flow-indent"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="end-indent">

        <xsl:choose>

          <xsl:when test="ancestor::table">0pt</xsl:when>

          <xsl:otherwise><xsl:value-of select="$flow-indent"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <fo:block>

        <xsl:apply-templates select="i"/>
        <fo:inline font-weight="bold" color="{$color.our-dark-text}">
          <xsl:text>Table </xsl:text>

          <xsl:number count="table[child::title]" format="1" from="book" level="any"/>
          <xsl:text>—</xsl:text>

          <xsl:apply-templates mode="force" select="title"/>
        </fo:inline>
      </fo:block>

      <xsl:apply-templates select="subtitle"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="subtitle">
    <fo:block>
      <fo:inline color="{$color.our-mid-text}" font-size="85%">
        <xsl:apply-templates/>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <xsl:template match="colspec">
    <fo:table-column>

      <xsl:attribute name="column-number">
        <xsl:value-of select="@col"/>
      </xsl:attribute>

      <xsl:if test="@width">

        <xsl:attribute name="column-width">
          <xsl:value-of select="@width"/>
        </xsl:attribute>
      </xsl:if>

    </fo:table-column>
  </xsl:template>

  <xsl:template match="thead">
    <fo:table-header end-indent="0pt" start-indent="0pt">

      <xsl:if test="parent::table[@style='hlines' or @style='outerlines'] or string-length(//book/options/tablestyle/@style) &gt; 0">

        <xsl:attribute name="border-top">1.5pt solid</xsl:attribute>

        <xsl:attribute name="border-top-color">
          <xsl:value-of select="$color.table-outer-line"/>
        </xsl:attribute>

        <xsl:attribute name="border-bottom">0.75pt solid</xsl:attribute>

        <xsl:attribute name="border-bottom-color">
          <xsl:value-of select="$color.table-outer-line"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:apply-templates/>
    </fo:table-header>
  </xsl:template>

  <xsl:template match="thead/col">
    <fo:table-cell>

      <xsl:if test="@span">

        <xsl:attribute name="number-columns-spanned"><xsl:value-of select="@span"/></xsl:attribute>
      </xsl:if>

      <xsl:call-template name="padded-cell"/>
      <fo:block font-family="{$sans.font.family}" font-size="90%" font-weight="bold">

        <xsl:attribute name="text-align">

          <xsl:choose>

            <xsl:when test="@align">
              <xsl:value-of select="@align"/>
            </xsl:when>

            <xsl:otherwise>center</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <xsl:apply-templates/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template match="row">
    <fo:table-row>

      <xsl:if test="parent::table[@decoration='zebra'] and ((position() mod 2) = 1)">

        <xsl:attribute name="background">
          <xsl:value-of select="$color.table-zebra-stripe"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="(parent::table[@style='hlines'] or (//book/options/tablestyle/@style = 'hlines')) and (position() &gt; 1)">

        <xsl:attribute name="border-top">1pt solid</xsl:attribute>

        <xsl:attribute name="border-top-color">
          <xsl:value-of select="$color.table-inner-line"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="col">

    <xsl:variable name="align">

      <xsl:variable name="attr-align">

        <xsl:call-template name="get-col-attr">

          <xsl:with-param name="attr">align</xsl:with-param>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>

        <xsl:when test="string-length($attr-align) &gt; 0">
          <xsl:value-of select="$attr-align"/>
        </xsl:when>

        <xsl:otherwise>left</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="valign">

      <xsl:call-template name="get-col-attr">

        <xsl:with-param name="attr">valign</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="font-weight">

      <xsl:call-template name="get-col-attr">

        <xsl:with-param name="attr">font-weight</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="font-family">

      <xsl:call-template name="get-col-attr">

        <xsl:with-param name="attr">font-family</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="font-size">

      <xsl:call-template name="get-col-attr">

        <xsl:with-param name="attr">font-size</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <fo:table-cell>

      <xsl:call-template name="padded-cell"/>

      <xsl:if test="string-length($align) &gt; 0">

        <xsl:attribute name="text-align"><xsl:value-of select="$align"/></xsl:attribute>
      </xsl:if>

      <xsl:if test="@span">

        <xsl:attribute name="number-columns-spanned"><xsl:value-of select="@span"/></xsl:attribute>
      </xsl:if>

      <xsl:if test="string-length($valign) &gt; 0">

        <xsl:attribute name="display-align">

          <xsl:choose>

            <xsl:when test="$valign = 'top'">before</xsl:when>

            <xsl:when test="$valign = 'middle'">center</xsl:when>

            <xsl:when test="$valign = 'bottom'">after</xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>

      <fo:block>

        <xsl:if test="$font-weight = 'bold'">

          <xsl:attribute name="font-weight">bold</xsl:attribute>
        </xsl:if>

        <xsl:if test="$font-family = 'sans'">

          <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
        </xsl:if>

        <xsl:if test="$font-family = 'mono'">

          <xsl:attribute name="font-family"><xsl:value-of select="$mono.font.family"/></xsl:attribute>
        </xsl:if>

        <xsl:if test="string-length($font-size) &gt; 0">

          <xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
        </xsl:if>

        <xsl:apply-templates/>
      </fo:block>
    </fo:table-cell>
    <!--          span CDATA #IMPLIED -->
  </xsl:template>

  <xsl:template match="col/p">
    <fo:block>

      <xsl:if test="@size = 'small'">

        <xsl:attribute name="font-size"><xsl:value-of select="$small-table-font-percentage"/></xsl:attribute>
      </xsl:if>

      <xsl:if test="(position() &lt; last()) and not(ancestor::backmatter) and following-sibling::*">

        <xsl:attribute name="space-after">6pt</xsl:attribute>
      </xsl:if>

      <xsl:call-template name="add-id"/>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- remove
       <xsl:template match="tablerule">
       </xsl:template> -->

  <xsl:template name="padded-cell">

    <xsl:attribute name="padding">

      <xsl:choose>

        <xsl:when test="not(preceding-sibling::col[1])">
          <!-- first -->
          <xsl:text>1pt 0.5em 1pt </xsl:text>

          <xsl:call-template name="possible-side-padding"/>
        </xsl:when>

        <xsl:when test="not(following-sibling::col[1])">
          <!-- last -->
          <xsl:text>1pt </xsl:text>

          <xsl:call-template name="possible-side-padding"/>
          <xsl:text> 1pt 0.5em</xsl:text>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>1pt 0.5em 1pt 0.5em</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="possible-side-padding">

    <xsl:choose>

      <xsl:when test="ancestor::table[@style='outerlines' or
                      @decoration='zebra']">
        <xsl:text>0.5em</xsl:text>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>0.0em</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get-col-attr">

    <xsl:param name="attr"/>

    <xsl:variable name="col"><xsl:number count="col" from="row"/></xsl:variable>

    <xsl:choose>

      <xsl:when test="@*[name() = $attr]">
        <xsl:value-of select="@*[name() = $attr]"/>
      </xsl:when>

      <xsl:when test="../../colspec[@col = $col]">

        <xsl:for-each select="../../colspec[@col = $col]">
          <xsl:value-of select="@*[name() = $attr]"/>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tablestyle"/>
</xsl:stylesheet>
