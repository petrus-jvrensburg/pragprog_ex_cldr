<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">
<xsl:output indent="no"/>

  <xsl:attribute-set name="body-normal">
    <xsl:attribute name="font-family"><xsl:value-of select="$body.font.family"/></xsl:attribute>
    <xsl:attribute name="font-size"><xsl:value-of select="$body.font.size"/></xsl:attribute>
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="indented-block">
    <xsl:attribute name="margin-right">0pt</xsl:attribute>
    <xsl:attribute name="margin-left"><xsl:value-of select="$indented-block-indentation"/></xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
    <xsl:attribute name="line-height">135%</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="bib-entry">
    <xsl:attribute name="space-after.maximum">10pt</xsl:attribute>
    <xsl:attribute name="space-after.optimum">8pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">6pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">10pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">6pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">6pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- We control when we want titles to appear -->
  <xsl:template match="title">
  </xsl:template>

  <xsl:template match="title/p">
  </xsl:template>

  <xsl:template match="title/p" mode="force">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="title" mode="force">
     <xsl:apply-templates/>
  </xsl:template>



  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


  <xsl:template match="bibliography">
    <fo:list-block provisional-distance-between-starts="5.5em"  font-size="90%">
      <xsl:for-each select="$bib/*">
	<fo:list-item xsl:use-attribute-sets="bib-entry">
	  <fo:list-item-label end-indent="label-end()">
	    <fo:block text-align="left">
	      <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
	      <xsl:text>[</xsl:text>
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to"><fo:inline padding-left="-0.08em" padding-right="-0.08em">1</fo:inline></xsl:with-param>
      <xsl:with-param name="from">1</xsl:with-param>
      <xsl:with-param name="string">
        <xsl:apply-templates select="@label"/>
      </xsl:with-param>
      </xsl:call-template>
	      <xsl:text>]</xsl:text>
	    </fo:block>
	  </fo:list-item-label>
	  <fo:list-item-body start-indent="body-start()">
	    <fo:block>
	     <xsl:apply-templates select="bib-line"/>
	    </fo:block>
	  </fo:list-item-body>
	</fo:list-item>
      </xsl:for-each>
    </fo:list-block>
  </xsl:template>

   <xsl:template match="bib-line">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="blockquote">
    <fo:block-container xsl:use-attribute-sets="indented-block">
      <xsl:apply-templates/>
      <xsl:if test="@said-by">
        <fo:block margin-left="2em"
                  margin-top="-0.75em"
                  margin-bottom="1em"
                  font-size="85%"
                  font-style="italic">
          <fo:inline font-family="{$symbol.font.family}" >&#x27a4;</fo:inline>
          <xsl:text>&#160;</xsl:text>
          <xsl:value-of select="@said-by"/>
        </fo:block>
      </xsl:if>
    </fo:block-container>
  </xsl:template>



  <xsl:template match="dialog">
    <fo:block-container xsl:use-attribute-sets="indented-block" font-style="italic">
      <xsl:apply-templates/>
    </fo:block-container>
  </xsl:template>



  <xsl:template match="dialog/said-by">
    <fo:float float="left" clear="both">
      <fo:block font-weight="bold" margin-right="1em" margin-bottom="-2pt">
	<xsl:value-of select="@name"/>
	<xsl:text>:</xsl:text>
      </fo:block>
    </fo:float>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="example">
    <fo:block-container
	background="{$color.example-block}"
	padding="0.5em 1em -.4em 0.5em"
	margin-top="-0.4em"
	margin-bottom=".9em"
	font-size="90%"
	>
      <fo:block start-indent="0pt" end-indent="0pt">
      <xsl:apply-templates/>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <xsl:template match="footnote[not(ancestor::said) and not(ancestor::joeasks) and not(ancestor::sidebar)]">
    <xsl:variable name="fn">
      <xsl:number count="footnote[not(ancestor::said) and not(ancestor::joeasks) and not(ancestor::sidebar)]" level="any" from="chapter|appendix" format="1"/>
    </xsl:variable>
    <fo:footnote xsl:use-attribute-sets="body-normal" >
      <xsl:if test="preceding-sibling::footnote">
        <xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
      </xsl:if>
      <fo:inline baseline-shift="super" font-size="60%">
        <xsl:if test="preceding-sibling::footnote">
          <xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$fn"/>
        <xsl:if test="following-sibling::node()[1][name() = 'footnote']">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </fo:inline>
      <fo:footnote-body font-size="85%" font-weight="normal" font-style="normal">
	<fo:list-block provisional-label-separation="0pt"
		       provisional-distance-between-starts="{$indented-block-indentation}"
		       space-after.optimum="0pt"
		       >
	  <xsl:attribute name="start-indent">
	    <xsl:choose>
	      <xsl:when test="ancestor::chapter or ancestor::appendix or ancestor::recipe or ancestor::long-partintro"><xsl:value-of select="$flow-indent"/></xsl:when>
	      <xsl:otherwise>0pt</xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	  <xsl:attribute name="end-indent">
	    <xsl:choose>
	      <xsl:when test="ancestor::chapter or ancestor::appendix or ancestor::recipe or ancestor::long-partintro"><xsl:value-of select="$flow-indent"/></xsl:when>
	      <xsl:otherwise>0pt</xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>

	  <fo:list-item>
	    <fo:list-item-label end-indent="label-end()">
	      <fo:block><xsl:value-of select="$fn"/>. </fo:block>
	    </fo:list-item-label>
	    <fo:list-item-body start-indent="body-start()">
	      <fo:block>
		      <xsl:apply-templates/>
	      </fo:block>
	    </fo:list-item-body>
	  </fo:list-item>
	</fo:list-block>
        <!-- RenderX has a bug - if the last element in a float is a list-block, it omits the rest of the text from the page.
          So we check to see if this is in a float and add a block if this is the last one. -->
        <xsl:if test="ancestor::sidebar
          or ancestor::dialog
          or ancestor::said-by
          or ancestor::highlight
          or ancestor::figure
          or ancestor::someone-says
          and not(following-sibling::*)">
          <fo:block/>
        </xsl:if>
      </fo:footnote-body>
    </fo:footnote>
  </xsl:template>

  <xsl:template match="highlight">
    <fo:float float="inside"
	      start-indent="0in"
	      end-indent="0pt"
	      clear="both">
      <fo:block-container
	  width="2in"
	  padding-left="0.1in"
	  padding-right="0.1in"
	  font-size="110%"
	  font-family="{$sans.font.family}"
	  text-align="outside"
	  >
	<fo:block
	    border-top="3pt solid {$color.heading-underline}"
	    border-bottom="3pt solid {$color.heading-underline}"
      padding-top="3pt"
	    margin-left="0.2in"
	    margin-right="0.2in"
      hyphenate="false"
	    >
    <xsl:attribute name="padding-bottom">
      <xsl:choose>
        <xsl:when test="not(child::*)">3pt</xsl:when>
        <xsl:otherwise>-3pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
	  <xsl:apply-templates/>
	</fo:block>
      </fo:block-container>
    </fo:float>
  </xsl:template>

  <xsl:template match="imagedata">
    <xsl:variable name="holder-width">
      <xsl:call-template name="get-holder-width"/>
    </xsl:variable>
    <fo:block line-stacking-strategy="max-height"
	      line-height="0pt"
              margin="0pt 0pt 6pt 0pt"
              width="{$holder-width}"
              max-width="{$holder-width}"
              >
        <xsl:attribute name="text-align">
          <xsl:choose>
            <xsl:when test="@align">
              <xsl:value-of select="@align"/>
            </xsl:when>
            <xsl:when test="parent::figure/@align">
              <xsl:value-of select="parent::figure/@align"/>
            </xsl:when>
            <xsl:otherwise>center</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="add-or-generate-id"/>

      &#10;
      <fo:external-graphic scaling="uniform" overflow="hidden">
         <xsl:if test="@border = 'yes'">
           <xsl:attribute name="border-width">1pt</xsl:attribute>
           <xsl:attribute name="border-style">solid</xsl:attribute>
           <xsl:attribute name="border-color"><xsl:value-of select="$color.our-mid-line"/></xsl:attribute>
         </xsl:if>
         <xsl:if test="not(contains(@width,'non'))">
              <xsl:attribute name="width">
                <xsl:choose>
                  <xsl:when test="@width = 'fit'">100%</xsl:when>
	                <xsl:when test="@width">
	                  <xsl:value-of select="@width"/>
	                </xsl:when>
	                <xsl:otherwise>100%</xsl:otherwise>
	             </xsl:choose>
	            </xsl:attribute>
         <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
         <xsl:attribute name="content-height">100%</xsl:attribute>
       </xsl:if>
       <xsl:attribute name="src">
	 <xsl:text>url(</xsl:text>
	 <xsl:call-template name="get-image-name"/>
	 <xsl:text>)</xsl:text>
       </xsl:attribute>
       <!--  <xsl:if test="@scale">
	  <xsl:attribute name="content-width">
	    <xsl:choose>
	      <xsl:when test="@scale='fit'">scale-to-fit</xsl:when>
	      <xsl:otherwise>
	      <xsl:value-of select="@scale"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	</xsl:if>-->
      </fo:external-graphic>
      &#10;
    </fo:block>
  </xsl:template>

  <xsl:template name="get-holder-width">
    <xsl:choose>
      <xsl:when test="@holder-width">
        <xsl:variable name="percentage">
          <xsl:value-of select="substring-before(@holder-width,'%')"/>
        </xsl:variable>
        <xsl:variable name="hw">
          <xsl:value-of select="($typeblock.width.number * $percentage) div 100"/>
        </xsl:variable>
        <xsl:value-of select="concat($hw,'in')"/>
      </xsl:when>
      <xsl:otherwise>
            <xsl:text>100%</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="p[@float]" ><!-- [not(ancestor::figure and not(preceding-sibling::p))] -->
    <fo:float float="{@float}">
      <xsl:call-template name="add-or-generate-id"/>
      <xsl:choose>
        <xsl:when test="@size = 'small'">
          <xsl:attribute name="font-size"><xsl:value-of select="$small-font-percentage"/></xsl:attribute>
        </xsl:when>
        <xsl:when test="@size = 'visibly-small'">
          <xsl:attribute name="font-size"><xsl:value-of select="$visibly-small-font-percentage"/></xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="not(ancestor::ol[@style='compact'] or ancestor::ul[@style='compact']) or ancestor::footnote or ancestor::related-tasks">
        <xsl:attribute name="space-after">6pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="(ancestor::ol[@style='compact'] or ancestor::ul[@style='compact'] or ancestor::li[2][following-sibling::*])
                    and ancestor::li[1][not(following-sibling::li)] and not(following-sibling::p)">
        <xsl:attribute name="space-after">6pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="ancestor::footnote or ancestor::related-tasks or @space-after='none'">
        <xsl:attribute name="space-after">0pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="@clear">
        <xsl:attribute name="clear">
          <xsl:value-of select="@clear"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="column-percentage">
        <xsl:value-of select="substring-before(@width,'%')"/>
      </xsl:variable>
      <xsl:variable name="intrusion">
        <xsl:value-of select="($typeblock.width.number * $column-percentage) div 100"/>
      </xsl:variable>
      <xsl:variable name="intrusion-inches">
        <xsl:value-of select="concat($intrusion,'in')"/>
      </xsl:variable>
      <fo:block-container
          display-align="before"
          intrusion-displace="block"
          max-width="{$intrusion-inches}"
          width="{$intrusion-inches}"
          margin-left="0.88in" margin-right="0">
        <fo:block>
          <xsl:call-template name="add-id"/>
          <xsl:apply-templates/>
        </fo:block>
      </fo:block-container>
    </fo:float>
  </xsl:template>

  <xsl:template match="p" name="p">
    <xsl:param name="add-space">yes</xsl:param>

    <fo:block>
      <xsl:if test="$booktype = 'airport' and (local-name(parent::*) !='blockquote')">
        <xsl:attribute name="text-indent">0.5cm</xsl:attribute>
      </xsl:if>

      <xsl:call-template name="add-or-generate-id"/>

      <xsl:if test="ancestor::figure and
                    not(ancestor::table or ancestor::li)">
        <xsl:attribute name="margin-left">.25in</xsl:attribute>
        <xsl:attribute name="margin-right">.25in</xsl:attribute>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="ancestor::figure and not(ancestor::table or ancestor::li)">
          <xsl:attribute name="font-size">
            <xsl:value-of select="$figure-font-percentage"/>
          </xsl:attribute>
        </xsl:when>

        <xsl:when test="@size = 'small'">
          <xsl:attribute name="font-size">
            <xsl:value-of select="$small-font-percentage"/>
          </xsl:attribute>
        </xsl:when>

        <xsl:when test="@size = 'visibly-small'">
          <xsl:attribute name="font-size">
            <xsl:value-of select="$visibly-small-font-percentage"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>


      <xsl:variable name="space-to-add-after">
        <xsl:choose>

          <xsl:when test="@space-after = 'none'">0pt</xsl:when>

          <xsl:when test="$add-space = 'none'">0pt</xsl:when>

          <xsl:when test="ancestor::footnote">0pt</xsl:when>

          <xsl:when test="ancestor::related-tasks">0pt</xsl:when>

          <!-- airport book -->
          <xsl:when test="$booktype = 'airport' ">
            <xsl:choose>
              <xsl:when test="
                 (local-name(following-sibling::*[1]) = 'p') 
              or (local-name(following-sibling::*[1]) = 'figure' and (following-sibling::*[1]/@place = 'top'))
              ">0pt</xsl:when>
              <xsl:otherwise>6pt</xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>6pt</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:attribute name="space-after">
        <xsl:value-of select="$space-to-add-after"/>
      </xsl:attribute>

      <xsl:if test="@clear">
        <xsl:attribute name="clear">
          <xsl:value-of select="@clear"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>

    </fo:block>
  </xsl:template>


  <xsl:template match="clear">
    <fo:block clear="both" height="0">
    </fo:block>
  </xsl:template>

  <!-- <xsl:template match="p[ancestor::figure and not(preceding-sibling::*[1][name() = 'title'])]"/> -->

  <xsl:template match="pagebreak">
     <fo:block break-after="page" font-size="0pt" line-height="0pt"><fo:leader leader-pattern="space" leader-length="0pt"/></fo:block>
  </xsl:template>

  <xsl:template match="prefacesignoff">
    <fo:block font-weight="bold" space-before="18pt">
      <xsl:value-of select="@name"/>
    </fo:block>
    <xsl:if test="@title">
      <fo:block>
        <xsl:value-of select="@title"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="@email">
      <fo:block xsl:use-attribute-sets="inline-code-font" margin-top="2pt">
	<xsl:value-of select="@email"/>
      </fo:block>
    </xsl:if>
    <xsl:if test="@location or @date">
      <fo:block margin-top="2pt">
        <xsl:if test="@location">
          <xsl:value-of select="@location"/>
        </xsl:if>
        <xsl:if test="@location and @date">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="@date">
          <xsl:value-of select="@date"/>
        </xsl:if>
      </fo:block>
    </xsl:if>
    <fo:block margin-top="2pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

 <!-- remove
   <xsl:template match="quote">
    <fo:block margin-left="2em" space-after="0pt" margin-bottom="0pt" padding-end="0pt" font-style="italic" font-size="90%">
      <xsl:apply-templates/>
    </fo:block>
    <fo:block text-align="right" space-before="0pt" margin-top="0pt" padding-start="0pt" font-size="80%">
      <xsl:text>—</xsl:text>
      <xsl:apply-templates select="title" mode="force"/>
    </fo:block>
  </xsl:template> -->

  <xsl:template match="story">
    <fo:block-container xsl:use-attribute-sets="indented-block" font-family="{$sans.font.family}">
      <fo:block font-weight="bold"  keep-with-next="always" id="{@id}">
	<xsl:apply-templates select="title" mode="force"/>
      </fo:block>
      <fo:block>
	<xsl:apply-templates/>
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <xsl:template match="story/person">
    <fo:block font-style="italic"
	      font-size="80%"
	      margin-bottom="0.4em"
	      keep-with-next="always">
      <xsl:text>by: </xsl:text>
      <xsl:apply-templates select="name"/>
      <xsl:if test="./jobtitle">
	<xsl:text>, </xsl:text>
	<xsl:apply-templates select="jobtitle"/>
      </xsl:if>
      <xsl:if test="./affiliation">
	<xsl:text>, </xsl:text>
	<xsl:apply-templates select="affiliation"/>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="story/person/name">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="story/person/jobtitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="story/person/affiliation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="storymap">
    <xsl:if test="not($ignore-workflow-tags = 'yes')">
       <fo:block color="blue" font-weight="bold" font-size="120%" padding-bottom="6pt">Story Map</fo:block>
      <fo:block color="blue">
	      <xsl:apply-templates/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="webresources">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="webresource">
    <fo:block text-align="justify"
              text-align-last="justify"
              hyphenate="false"
              start-indent="80pt"
              text-indent="-16pt"
              last-line-end-indent="-36pt"
              end-indent="100pt"
              padding-top="7pt"
              keep-with-next="always">
      <fo:inline keep-together.within-line="always">
        <fo:inline font-weight="bold">
          <xsl:apply-templates select="resname"/>
        </fo:inline>
        <fo:inline padding-left="4pt"
                   padding-right="3pt"
                   inline-progression-dimension.minimum="48pt">
          <fo:leader leader-pattern="rule"
                     rule-thickness="0.5pt"
                     leader-alignment="reference-area"
                     leader-length.minimum="48pt"/>
          <xsl:if test="resurl/@newline='yes'"> &#x200b; </xsl:if>
        </fo:inline>
        <xsl:if test="resurl/@newline='yes'"> &#x200b; </xsl:if>
      </fo:inline>
      <xsl:if test="resurl/@newline='yes'"> &#x200b; </xsl:if>
      <fo:inline font-family="{$sans.font.family}" font-size="9pt" keep-together.within-line="always">
        <xsl:if test="resurl/@newline='yes'">
          <fo:inline padding-right="-3pt">
            <fo:leader leader-pattern-width="8pt" leader-pattern="use-content" leader-alignment="reference-area" leader-length.minimum="17pt">.</fo:leader>
          </fo:inline>
        </xsl:if>
        <xsl:apply-templates select="resurl"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="resdesc"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="resurl">
    <fo:basic-link>
      <xsl:attribute name="external-destination">
        <xsl:text>url(</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>)</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="resname">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="resdesc">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tip">
    <xsl:variable name="number">
      <xsl:number format="1" count="tip" level="any"/>
    </xsl:variable>
    <xsl:variable name="recipetitle">
      <xsl:choose>
        <xsl:when test="//book/options/recipetitle">
          <xsl:value-of select="//book/options/recipetitle/@name"/>
          <xsl:text> </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Tip </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="title-column-width">
      <xsl:choose>
        <xsl:when test="//book/options/recipetitle">
          <xsl:value-of select="//book/options/recipetitle/@width"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0.8in</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:variable name="startindent.number">
      <xsl:value-of select="$flow-indent.number - 0.2"/>
    </xsl:variable>

    <fo:table keep-together.within-page="always"
      padding-top="2pt" padding-bottom="2pt" padding-left="2pt" border="2pt solid {$color.our-tip}"
      table-layout="fixed" width="100%"
      space-after="6pt"
      >
      <xsl:attribute name="end-indent">
        <xsl:choose>
          <xsl:when test="(ancestor::chapter or ancestor::appendix or ancestor::recipe or ancestor::part)
	                  and not(ancestor::task)
	                  and not(ancestor::sidebar)
	                  and not(ancestor::joeasks)
	                  and not(ancestor::said)
	                  ">
            <xsl:value-of select="$flow-indent"/>
          </xsl:when>
          <xsl:otherwise>0pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="start-indent">
        <xsl:variable name="indent-count">
	  <xsl:value-of select="count(ancestor::ol) + count(ancestor::ul)"/>
	</xsl:variable>
	<xsl:variable name="total-indent">
	  <xsl:value-of select="$indent-count * $indented-block-indentation.number"/>
	</xsl:variable>
        <xsl:variable name="table-start-indent.number">
          <xsl:value-of select="$flow-indent.number + $total-indent"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="(ancestor::chapter or ancestor::appendix or ancestor::recipe or ancestor::part)
	                  and not(ancestor::task)
	                  and not(ancestor::sidebar)
	                  and not(ancestor::joeasks)
	                  and not(ancestor::said)
	                  ">
            <xsl:value-of select="concat($table-start-indent.number,'in')"/>
          </xsl:when>
          <xsl:otherwise>0pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <fo:table-column column-number="1"  text-align="center">
        <xsl:attribute name="column-width">
          <xsl:value-of select="$title-column-width"/>
        </xsl:attribute>
      </fo:table-column>
      <fo:table-body start-indent="0pt" end-indent="0pt">
        <fo:table-row>
          <xsl:if test="@add-number='yes'">
            <fo:table-cell margin-left="4pt"
                           margin-right="4pt"
                           margin-top="4pt"
                           margin-bottom="4pt"
                           border-left="2pt solid white"
                           border-top="2pt solid white"
                           border-bottom="2pt solid white"
                           background-color="{$color.our-tip}"
                           display-align="center">
              <fo:block end-indent="0pt"
                        padding-top="2pt"
                        text-align="center"
                        color="white"
                        font-weight="bold"
                        font-family="{$sans.font.family}"
                        >
                <xsl:value-of select="$recipetitle"/>
                <xsl:value-of select="$number"/>
              </fo:block>
            </fo:table-cell>
          </xsl:if>
          <fo:table-cell padding="4pt">
             <fo:block>
              <xsl:apply-templates select="title" mode="force"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>

  </xsl:template>

</xsl:stylesheet>
