<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            

  <xsl:template match="figure">
    <fo:float float="before">
      <xsl:call-template name="figure"/>
    </fo:float>
  </xsl:template>
  
  <xsl:template match="figure[@place='inline']">
    <xsl:call-template name="figure"/>
  </xsl:template>
  
  <xsl:template match="figure[@place='runaround-left']">
    <xsl:variable name="column-percentage">
      <xsl:value-of select="substring-before(@width,'%')"/>
    </xsl:variable>
    <xsl:variable name="intrusion">
      <xsl:value-of select="($typeblock.width.number * $column-percentage) div 100"/>
    </xsl:variable>
    <xsl:variable name="intrusion-inches">
      <xsl:value-of select="concat($intrusion,'in')"/>
    </xsl:variable>
    <fo:float float="outside">
      <xsl:if test="@clear">
        <xsl:attribute name="clear">
          <xsl:value-of select="@clear"/>
        </xsl:attribute>
      </xsl:if>
      <fo:block-container display-align="before" intrusion-displace="block" max-width="{$intrusion-inches}" margin-left="0.88in" margin-right="0.1in">
        <xsl:call-template name="figure-runaround"/>
      </fo:block-container>
    </fo:float>
  </xsl:template>
  
  <xsl:template match="figure[@place='runaround-right']">
    <xsl:variable name="column-percentage">
      <xsl:choose>
        <xsl:when test="not(@width)">100</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-before(@width,'%')"/>
        </xsl:otherwise>
      </xsl:choose>     
    </xsl:variable>
    <xsl:variable name="intrusion">
      <xsl:value-of select="($typeblock.width.number * $column-percentage) div 100"/>
    </xsl:variable>
    <xsl:variable name="intrusion-inches">
      <xsl:value-of select="concat($intrusion,'in')"/>
    </xsl:variable>
    <fo:float float="right">
      <xsl:if test="@clear">
        <xsl:attribute name="clear">
          <xsl:value-of select="@clear"/>
        </xsl:attribute>
      </xsl:if>
      <fo:block-container
          display-align="before"
          intrusion-displace="block"
          max-width="{$intrusion-inches}"
          margin-left="0.1in"
          margin-right="0in"
          >
        <xsl:if test="not(ancestor::dl) and $booktype != 'airport'">
          <xsl:attribute name="margin-right">0.88in</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="figure-runaround"/>
      </fo:block-container>
    </fo:float>
  </xsl:template> 
  
  <xsl:template name="figure-runaround">
    <fo:block
    space-after="3pt"
    keep-together.within-page="always" >
    <xsl:if test="ancestor::dl-dave-hack-xxx">
      <xsl:attribute name="start-indent">
        <xsl:value-of select="$flow-indent"/>
      </xsl:attribute>
      <xsl:attribute name="end-indent">
        <xsl:value-of select="$flow-indent"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="add-or-generate-id"/>

    <xsl:apply-templates/>

    <xsl:if test="title">
      <fo:block keep-with-previous="always" xsl:use-attribute-sets="figcaption.attrs">
        <xsl:if test="$booktype != 'airport'">
          <xsl:attribute name="border-top">0.5pt solid rgb-icc(220, 220, 220, #Grayscale, 0.83)</xsl:attribute>
          <xsl:attribute name="padding-top">3pt</xsl:attribute>
        </xsl:if>

        <fo:inline font-weight="bold">
          <xsl:if test="$booktype = 'airport'">
            <xsl:attribute name="font-size">8.5pt</xsl:attribute>
          </xsl:if>
          <xsl:if test="@omit-number != 'yes'">
            <xsl:text>Figure </xsl:text>
            <xsl:number format="1" count="figure[child::title][child::*[not(name() = 'title') and not(name() = 'table')]]" from="book" level="any"/>
            <xsl:text>—</xsl:text>
          </xsl:if>
          <xsl:apply-templates select="title" mode="force"/>
        </fo:inline>
        <xsl:if test="p">
          <xsl:text> </xsl:text>
          <fo:inline>
            <xsl:apply-templates select="p[1][not(preceding-sibling::*[not(self::title or self::i)])]/node()"/>
          </fo:inline>
          <xsl:apply-templates select="p[count(preceding-sibling::p) &gt;= 1][not(preceding-sibling::*[not(self::p or self::title or self::i)])]"/>
        </xsl:if>
      </fo:block>
    </xsl:if>
  </fo:block>
</xsl:template>

  <xsl:template name="figure">
    <fo:block
    space-after.minimum="12pt"
    space-after.optimum="14pt"
    space-after.maximum="16pt"
    keep-together.within-page="always" >
    <xsl:if test="@clear">
      <xsl:attribute name="clear">
        <xsl:value-of select="@clear"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="ancestor::table">
        <xsl:attribute name="start-indent">0in</xsl:attribute>
      </xsl:when>
      <xsl:when test="ancestor::ul or ancestor::ol or ancestor::dl">
        <xsl:attribute name="start-indent">
          <xsl:value-of select="$flow-indent"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="ancestor::dl">
      <xsl:attribute name="end-indent">
        <xsl:value-of select="$flow-indent"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="add-or-generate-id"/>
    <xsl:apply-templates />

    <xsl:if test="child::title and
    child::*[not(name() = 'title') and
    not(name() = 'table')]">
    <fo:block keep-with-previous="always" xsl:use-attribute-sets="figcaption.attrs">
        <xsl:if test="$booktype != 'airport'">
          <xsl:attribute name="border-top">0.5pt solid rgb-icc(220, 220, 220, #Grayscale, 0.83)</xsl:attribute>
          <xsl:attribute name="padding-top">3pt</xsl:attribute>
        </xsl:if>
    <fo:inline font-weight="bold">
      <xsl:if test="$booktype = 'airport'">
        <xsl:attribute name="font-size">8.5pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="@omit-number != 'yes'">
      <xsl:text>Figure </xsl:text>
      <xsl:number format="1" count="figure[child::title][child::*[not(name() = 'title') and not(name() = 'table')]]" from="book" level="any"/>
      <xsl:text>—</xsl:text>
    </xsl:if>
      <xsl:apply-templates select="title" mode="force"/>
    </fo:inline>
    <xsl:for-each select="title/p">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </fo:block>
</xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template name="preceding-sibling">
    <xsl:param name="count"/>
    <xsl:param name="position"/>
    <xsl:param name="preceding-non-p"/>
    <xsl:choose>
      <xsl:when test="(preceding-sibling::*[$count][name() != 'p' and  name() != 'i' and name() != 'title']) and $position &gt;= $count">
        <xsl:value-of select="'yes'"/>
      </xsl:when>
      <xsl:when test="$position &gt;= $count">
        <xsl:call-template name="preceding-sibling">
          <xsl:with-param name="count" select="$count + 1"/>
          <xsl:with-param name="position" select="$position"/>
          <xsl:with-param name="preceding-non-p" select="'no'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'no'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="joeasks">
    <xsl:call-template name="someone-says">
      <xsl:with-param name="prefix">Joe asks:</xsl:with-param>
      <xsl:with-param name="image">url(../PerBook/util/images/joe.pdf)</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="said">
    <xsl:call-template name="someone-says">
      <xsl:with-param name="prefix">
	<xsl:value-of select="@by"/>
	<xsl:text> says:</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="image">
	<xsl:text>url(</xsl:text>
	<xsl:call-template name="get-image-name">
          <xsl:with-param name="file">
            <xsl:text>images/</xsl:text>
            <xsl:call-template name="name-to-headshot-name"/>
          </xsl:with-param>
	</xsl:call-template>
	<xsl:text>)</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="name-to-headshot-name">
    <xsl:text>headshots/</xsl:text>
    <xsl:value-of select="translate(@by, 'áéó', 'aeo')"/>
    <xsl:text>.png</xsl:text>
  </xsl:template>

  <xsl:template match="sidebar">
    <xsl:call-template name="someone-says"/>
  </xsl:template>
  
  <xsl:template name="someone-says">
    <xsl:param name="prefix"/>
    <xsl:param name="image"/>
    <xsl:choose>
      <xsl:when test="@place='inline'">
        <fo:block margin-bottom="6pt">
          <xsl:call-template name="says-content">
            <xsl:with-param name="image" select="$image"/>
            <xsl:with-param name="prefix" select="$prefix"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:float float="before" >
          <xsl:call-template name="says-content">
            <xsl:with-param name="image" select="$image"/>
            <xsl:with-param name="prefix" select="$prefix"/>
          </xsl:call-template>
          <fo:block line-height="6pt">&#160;</fo:block>
        </fo:float>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
  
  <xsl:template name="says-content">
    <xsl:param name="prefix"/>
    <xsl:param name="image"/>
    <fo:table start-indent="{$flow-indent}" end-indent="{$flow-indent}" >
      <xsl:if test="@fullwide='yes'">
        <xsl:attribute name="width">5in</xsl:attribute>
      </xsl:if>
      <fo:table-column column-width="11.385pt" column-number="1"/>
      <fo:table-column column-number="2"/>
      <fo:table-column column-width="11.385pt" column-number="3"/>
      <fo:table-header start-indent="0pt" end-indent="0pt">
        <fo:table-row font-size="0pt">
          <fo:table-cell display-align="after" padding-left="-.06pt" 
                         block-progression-dimension="0pt" line-height="0pt" font-size="0pt" padding-top="2.4pt">
            <fo:block text-indent="-.45pt">
              <fo:instream-foreign-object>
                <svg version="1.1" 
		     id="Layer_1" 
		     xmlns="http://www.w3.org/2000/svg" 
		     xmlns:xlink="http://www.w3.org/1999/xlink" 
		     x="0px" y="0px" 
		     width="20px" height="20px" 
		     viewBox="0 0 20 20" 
		     enable-background="new 0 0 20 20" xml:space="preserve">
		  <path fill="{$color.sidebar-border-svg}" 
			stroke="{$color.sidebar-border-svg}" 
			stroke-width="2.1" 
			stroke-miterlimit="10" 
			d="M21,0.975 c-11.074,0-20,9-20,20h20V0.975H21z"/>
		</svg>
              </fo:instream-foreign-object> 
            </fo:block>
          </fo:table-cell>
          <fo:table-cell background-color="{$color.sidebar-border-svg}" block-progression-dimension="12pt" font-size="0pt" line-height="0pt">
            <fo:block> </fo:block>
          </fo:table-cell>
          <fo:table-cell  display-align="after" block-progression-dimension="0pt" line-height="0pt" font-size="0pt">
            <fo:block text-indent="-0.105pt" text-align="left">
              <fo:instream-foreign-object>
                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 20 20" enable-background="new 0 0 20 20" xml:space="preserve">
                  <path fill="{$color.sidebar-border-svg}" stroke="{$color.sidebar-border-svg}" stroke-width="2.1" stroke-miterlimit="10" d="M19.003,20.997
	                                                                                                                                     c0-11.042-8.937-19.978-19.975-19.978v19.978H19.003z"/>
                </svg> 
              </fo:instream-foreign-object>
              
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-footer start-indent="0pt" end-indent="0pt">
        <fo:table-row>
          <fo:table-cell display-align="after">
            <fo:block text-indent="-0.6pt" line-height="0pt" block-progression-dimension="0pt" font-size="0pt" padding-bottom="-0.1pt" >
              <fo:instream-foreign-object>
                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 20 20" enable-background="new 0 0 20 20" xml:space="preserve">
                  <path fill="{$color.sidebar-border-svg}" stroke="{$color.sidebar-border-svg}" stroke-width="1.66" stroke-miterlimit="10" 
                        d="M1-1C1,10.035,9.977,19,21.068,19V-1.044H1z"/>
                </svg> 
              </fo:instream-foreign-object>
            </fo:block>
          </fo:table-cell>
          <fo:table-cell background-color="{$color.sidebar-border-svg}" block-progression-dimension="11.9pt" >
            <fo:block font-size="0pt" line-height="0pt"></fo:block>
          </fo:table-cell> 
          <fo:table-cell display-align="after" block-progression-dimension="10pt">
            <fo:block text-indent="0pt" line-height="0pt" block-progression-dimension="0pt" font-size="0pt" padding-bottom="-0.1pt">
              <fo:instream-foreign-object>
                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 20 20" 
                     enable-background="new 0 0 20 20" xml:space="preserve">
                  <path fill="{$color.sidebar-border-svg}" stroke="{$color.sidebar-border-svg}" stroke-width="1.65" stroke-miterlimit="10" 
                        d="M-1,19.05 c11.05,0,19.989-8.979,19.989-20.071H-0.972V19.05z"/>
                </svg> 
              </fo:instream-foreign-object>   
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-footer>
      <fo:table-body start-indent="0pt" end-indent="0pt">
        <fo:table-row>
          <fo:table-cell
              border-top="1pt solid {$color.sidebar-border}"
              border-left="1pt solid {$color.sidebar-border}"
              border-bottom="1pt solid {$color.sidebar-border}"  
              background-color="{$color.sidebar-border}">
            <fo:block background-color="{$color.sidebar-border}"> </fo:block>
          </fo:table-cell>
          <fo:table-cell background-color="{$color.sidebar-border}"
                         border-top="1pt solid {$color.sidebar-border}" border-bottom="1pt solid {$color.sidebar-border}">
            <fo:block font-size="120%" font-weight="bold"
                      font-family="{$sans.font.family}"
                      background-color="{$color.sidebar-border}" padding-top="-9pt" text-align="left">
              <xsl:choose>
                <xsl:when test="name() = 'sidebar'">
                  <xsl:apply-templates select="title" mode="force"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="says-graphic">
                    <xsl:with-param name="prefix" select="$prefix"/>
                    <xsl:with-param name="image" select="$image"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
              
              
            </fo:block>
          </fo:table-cell>
          <fo:table-cell
              border-top="1pt solid {$color.sidebar-border}"
              border-right="1pt solid {$color.sidebar-border}"
              border-bottom="1pt solid {$color.sidebar-border}"  
              background-color="{$color.sidebar-border}">
            <fo:block 
                background-color="{$color.sidebar-border}"> </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell
              border-left="1pt solid {$color.sidebar-border}"
              background-color="{$color.sidebar-body-background}">
            <fo:block> </fo:block>
          </fo:table-cell>
          <fo:table-cell padding-top="6pt"
                         background-color="{$color.sidebar-body-background}">
            <fo:block-container font-size="85%">
              <fo:block>
                <xsl:call-template name="add-id"/>
                <xsl:apply-templates/>
              </fo:block>
              <xsl:if test="self::joeasks//footnote or self::said//footnote or self::sidebar//footnote">
                <xsl:call-template name="floatnotes"/>
              </xsl:if>
              
            </fo:block-container>
          </fo:table-cell>
          <fo:table-cell
              border-right="1pt solid {$color.sidebar-border}"
              background-color="{$color.sidebar-body-background}">
            <fo:block> </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template name="says-graphic">
    <xsl:param name="image"/>
    <xsl:param name="prefix"/>
    
    <fo:list-block 
        margin-right="5pt"
        margin-left="5pt"
        line-stacking-strategy="max-height"
        provisional-distance-between-starts="0.5in"
        >
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
          <fo:block>
            <fo:external-graphic src="{$image}" 
                                 content-height="0.4in"
                                 padding-right="0.2in"/>
          </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()" font-family="{$sans.font.family}">
          <fo:block font-weight="bold">
            <xsl:value-of select="$prefix"/>
          </fo:block>
          <fo:block font-size="120%" font-weight="bold">
            <xsl:apply-templates select="title" mode="force"/>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="sidebar//footnote | joeasks//footnote | said//footnote | figure//footnote">
    <!-- SAXON change: removed variable for from, specified the full <xsl:number> tag in the conditions, due to a Saxon bug. -->
    <xsl:variable name="notecount">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::sidebar"><xsl:number level="any" from="sidebar" count="footnote" format="a"/></xsl:when>
        <xsl:when test="ancestor-or-self::joeasks"><xsl:number level="any" from="joeasks" count="footnote" format="a"/> </xsl:when>
        <xsl:when test="ancestor-or-self::said"><xsl:number level="any" from="said" count="footnote" format="a"/></xsl:when>
        <xsl:otherwise><xsl:number level="any" count="footnote" format="a"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:inline baseline-shift="super" font-size="75%">
      <xsl:if test="preceding-sibling::footnote">
        <xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$notecount"/>
      <xsl:if test="following-sibling::node()[1][name() = 'footnote']">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </fo:inline>
  </xsl:template>
  
  <xsl:template name="floatnotes">
    <xsl:variable name="float-type">
      <xsl:choose>
        <xsl:when test="ancestor-or-self::sidebar">sidebar</xsl:when>
        <xsl:when test="ancestor-or-self::joeasks">joeasks</xsl:when>
        <xsl:when test="ancestor-or-self::said">said</xsl:when>
        <xsl:otherwise>none</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="ancestor-or-self::*[name() = $float-type]//footnote">
      <fo:block>
        <fo:leader leader-pattern="rule"
                   leader-length="15%"
                   rule-style="solid"
                   rule-thickness="0.25pt"/>
      </fo:block>
      <fo:list-block>
        <xsl:for-each select="ancestor-or-self::*[name() = $float-type]//footnote">
          <xsl:variable name="notecount">
            <xsl:number level="any" from="*[name() = $float-type]" count="footnote" format="a"/>
          </xsl:variable>
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block>
                <xsl:value-of select="$notecount"/>
                <xsl:text>.</xsl:text>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block  font-size="85%"></fo:block>
              <xsl:apply-templates/>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:for-each>
      </fo:list-block>
    </xsl:if>   
  </xsl:template>

  <xsl:template match="marginnote">
    <fo:float float="outside" 
	      start-indent="0in"
	      end-indent="0in"
	      clear="both">
      <fo:block-container 
	  width="0.7in"
	  padding-left="0in"
	  padding-right="0in"
	  font-size="60%"
	  font-family="{$sans.font.family}"
	  text-align="inside"
	  >
	<fo:block
	    padding-top="1pt"
	    margin-left="0in"
	    margin-right="0in"
            hyphenate="false"
	    >

	  <xsl:apply-templates/>
	</fo:block>
      </fo:block-container>
    </fo:float>
  </xsl:template>

</xsl:stylesheet>
