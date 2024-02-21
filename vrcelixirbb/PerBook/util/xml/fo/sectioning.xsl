<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">


  <xsl:attribute-set name="format-for-any-title">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="$color = 'yes'">
          <xsl:value-of select="$color.our-mid-heading-text"/>
        </xsl:when>
        <xsl:otherwise>black</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-family">
      <xsl:value-of select="$heading.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="format-for-sect1-title">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="$color = 'yes'">
          <xsl:value-of select="$color.our-mid-heading-text"/>
        </xsl:when>
        <xsl:otherwise>black</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-size">15pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">11pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">13pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">15pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">4pt</xsl:attribute>
    <xsl:attribute name="space-after.optimum">5pt</xsl:attribute>
    <xsl:attribute name="space-after.maximum">6pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="sect1-upper-title">
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-family"><xsl:value-of select="$heading.font.family"/></xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>


  <xsl:attribute-set name="format-for-sect2-title"
                     use-attribute-sets="format-for-any-title">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">7pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">9pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">12pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">2pt</xsl:attribute>
    <xsl:attribute name="space-after.optimum">4pt</xsl:attribute>
    <xsl:attribute name="space-after.maximum">5pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="format-for-sect3-title"
                     use-attribute-sets="format-for-any-title">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">6pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">9pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">11pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">2pt</xsl:attribute>
    <xsl:attribute name="space-after.optimum">3pt</xsl:attribute>
    <xsl:attribute name="space-after.maximum">4pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="format-for-sect4-title">
    <xsl:attribute name="color">
      <xsl:choose>
        <xsl:when test="$color = 'yes'">
          <xsl:value-of select="$color.our-mid-heading-text"/>
        </xsl:when>
        <xsl:otherwise>black</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-size">9.5pt</xsl:attribute>
    <xsl:attribute name="space-before.minimum">6pt</xsl:attribute>
    <xsl:attribute name="space-before.optimum">9pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">11pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1pt</xsl:attribute>
    <xsl:attribute name="space-after.maximum">2pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="format-for-tip-and-recipe-title">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="margin-left">13pt</xsl:attribute>
    <xsl:attribute name="margin-right">18pt</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="heading-font">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$heading.font.family"/>
    </xsl:attribute>
  </xsl:attribute-set>


  <xsl:attribute-set name="recipepad">
    <xsl:attribute name="force-page-count">
      <xsl:choose>
        <xsl:when test="$target.recto-verso-headings='no'">no-force</xsl:when>
        <xsl:when test="$recipe.padding='no' and following-sibling::*">no-force</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="initial-page-number">
    <!-- For the initial page number, we have to make some choices. If
         it's paper or screen and no peers exist before this one,
         start on 1.  If it's screen and we don't need to start on 1,
         use auto-odd to preserve page numbering where padded pages
         are omitted. -->
    <xsl:attribute name="initial-page-number">
      <xsl:choose>
        <xsl:when test="(parent::mainmatter)
                        and count(preceding-sibling::*[(name() = 'chapter')
                                                    or (name() = 'part')
                                                    or (name() = 'recipe')
                                                    or (name() = 'task')]) = 0">
          <xsl:choose>
            <xsl:when test="//bookinfo/@chapter-start = 'verso'">
              <xsl:text>2</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>1</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="//bookinfo/@chapter-start = 'verso'">
          <xsl:text>auto-even</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>auto-odd</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="force-page-count">
    <xsl:attribute name="force-page-count">
      <xsl:choose>
        <xsl:when test="$target.recto-verso-headings='no' and not($booktype='pguide')">no-force</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="mainmatter/chapter[1]">
    <xsl:call-template name="chapter">
      <xsl:with-param name="reset-page-sequence">yes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="chapter" name="chapter">
    <xsl:param name="reset-page-sequence"/>
    <!-- Note: This parameter is not used in this template, but if it
         is omitted, a Java heap space error occurs.  In fact, the
         parameter could be named anything and it would still fix the
         Java heap space error! -->
    <xsl:call-template name="force-recto"/>

    <xsl:if test="$chapter='no' or ($chapter='yes' and @solo='yes')">
      <fo:page-sequence xsl:use-attribute-sets="end-on-page-before-chapter-start"
                        master-reference="chapter">
        <xsl:call-template name="initial-page-number"/>
        <xsl:if test="ancestor::frontmatter">
          <xsl:attribute name="format">i</xsl:attribute>
        </xsl:if>

        <xsl:call-template name="setup-page-headers"/>
        <xsl:call-template name="setup-page-footers"/>
        <xsl:call-template name="blank-page-setup"/>

        <fo:flow flow-name="xsl-region-body"
                 start-indent="{$flow-indent}"
                 end-indent="{$flow-indent}"
                 hyphenation-remain-character-count="3">

          <xsl:call-template name="chapter-heading">
            <xsl:with-param name="type">Chapter</xsl:with-param>
            <xsl:with-param name="number">
              <xsl:number format="1" count="chapter" level="any" from="mainmatter"/>
            </xsl:with-param>
            <xsl:with-param name="name">
              <xsl:apply-templates select="title" mode="force"/>
            </xsl:with-param>
            <xsl:with-param name="extra">
              <xsl:apply-templates select="title/p" mode="force"/>
            </xsl:with-param>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="@stubout='yes'">
              <fo:block>Content to be supplied later.</fo:block>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:flow>
      </fo:page-sequence>
    </xsl:if>
  </xsl:template>


  <xsl:template match="appendix">
    <xsl:call-template name="force-recto"/>
    <fo:page-sequence xsl:use-attribute-sets="end-on-page-before-chapter-start"
                      initial-page-number="auto-odd"
                      master-reference="chapter">

      <xsl:call-template name="setup-page-headers"/>
      <xsl:call-template name="setup-page-footers"/>
      <xsl:call-template name="blank-page-setup"/>

      <fo:flow flow-name="xsl-region-body"
               start-indent="{$flow-indent}"
               end-indent="{$flow-indent}"
               hyphenation-remain-character-count="3">

        <xsl:call-template name="chapter-heading">
          <xsl:with-param name="type">Appendix</xsl:with-param>
          <xsl:with-param name="number">
            <xsl:number format="1" count="appendix" level="any" from="mainmatter"/>
          </xsl:with-param>
          <xsl:with-param name="name">
            <xsl:apply-templates select="title" mode="force"/>
          </xsl:with-param>
            <xsl:with-param name="extra">
              <xsl:apply-templates select="title/p" mode="force"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@stubout='yes'">
          <fo:block>Content to be supplied later.</fo:block>
        </xsl:if>
        <xsl:if test="not(@stubout='yes')">
          <xsl:apply-templates/>
        </xsl:if>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>


  <xsl:template match="part">
    <xsl:call-template name="force-recto"/>

    <xsl:choose>
      <xsl:when test="long-partintro">
        <fo:page-sequence master-reference="part"
                           xsl:use-attribute-sets="end-on-page-before-chapter-start">
          <xsl:call-template name="force-page-count"/>
          <xsl:call-template name="initial-page-number"/>
          <xsl:call-template name="setup-page-headers"/>
          <xsl:call-template name="blank-page-setup"/>
          <fo:flow flow-name="xsl-region-body">
            <fo:block margin-top="2in"
                      font-size="190%"
                      text-align="center"
                      hyphenate="false"
                      font-family="{$sans.font.family}">
              <xsl:call-template name="add-or-generate-id"/>
              <fo:block padding-after="0.5in">
                <xsl:text>Part </xsl:text>
                <xsl:number count="part" from="book" level="any" format="I"/>
              </fo:block>
              <fo:block>
                <xsl:apply-templates select="title" mode="force"/>
              </fo:block>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>
        <fo:page-sequence master-reference="long-intro"
                          initial-page-number="auto-odd">

          <xsl:choose>
            <xsl:when test="$booktype = 'pguide'">
              <xsl:attribute name="xsl:use-attribute-sets">
                <xsl:text>
                  end-on-even
                </xsl:text>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="xsl:use-attribute-sets">
                <xsl:text>end-on-page-before-chapter-start"</xsl:text>
              </xsl:attribute>
            </xsl:otherwise>

          </xsl:choose>

          <xsl:call-template name="setup-page-headers"/>
          <xsl:call-template name="blank-page-setup"/>
          <fo:flow flow-name="xsl-region-body"
                   start-indent="{$flow-indent}"
                   end-indent="{$flow-indent}">
            <fo:block font-size="190%"
                      text-align="left"
                      hyphenate="false"
                      font-family="{$sans.font.family}">
              <xsl:call-template name="add-or-generate-id"/>
              <fo:marker marker-class-name="chapter-name">
                <xsl:apply-templates select="title" mode="force"/>
              </fo:marker>
              <fo:marker marker-class-name="section-name">
                <xsl:apply-templates select="title" mode="force"/>
              </fo:marker>
              <xsl:apply-templates select="long-partintro" mode="force"/>
            </fo:block>
          </fo:flow>
        </fo:page-sequence>
        <xsl:apply-templates/>
      </xsl:when>

      <!-- normal part intro -->

      <xsl:otherwise>
        <fo:page-sequence master-reference="part" >
          <xsl:call-template name="force-page-count"/>
          <xsl:call-template name="initial-page-number"/>
          <xsl:call-template name="setup-page-headers"/>
          <xsl:call-template name="blank-page-setup"/>
          <fo:flow flow-name="xsl-region-body">
            <fo:block margin-top="2in" font-size="155%" text-align="center" hyphenate="false">
              <xsl:call-template name="add-or-generate-id"/>
              <fo:marker marker-class-name="part-name">
                <xsl:if test="ancestor::mainmatter and not(ancestor-or-self::index) and not(ancestor-or-self::bibsection)and $omit.chapnums='no'">
                  <xsl:value-of select="'Part'"/>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:number count="part" from="mainmatter" format="1"/>
                  <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:value-of select="title"/>
              </fo:marker>
              <xsl:text>Part </xsl:text>
              <xsl:number count="part" from="book" level="any" format="I"/>
            </fo:block>
            <fo:block margin-top="0.25in" font-size="190%" text-align="center" hyphenate="false">
              <xsl:apply-templates select="title" mode="force"/>
            </fo:block>
            <xsl:apply-templates select="partintro" mode="force"/>
          </fo:flow>
        </fo:page-sequence>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="partintro"/>
  <xsl:template match="partintro" mode="force">
    <xsl:choose>
      <xsl:when test="$booktype = 'pguide'">
        <fo:block margin-top="17.5pt">
          <xsl:choose>
            <xsl:when test="//task">
              <xsl:attribute name="font-size">10.5pt</xsl:attribute>
              <xsl:attribute name="font-family"><xsl:value-of select="$sans.font.family"/></xsl:attribute>
              <xsl:attribute name="page-break-before">always</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="font-size"><xsl:value-of select="$body.font.size"/></xsl:attribute>
              <xsl:attribute name="font-family"><xsl:value-of select="$body.font.family"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block border-top="1pt solid {$color.heading-underline}"
                  border-bottom="1pt solid {$color.heading-underline}"
                  padding-top="3pt"
                  padding-bottom="3pt"
                  font-style="italic"
                  font-size="90%">
          <xsl:choose>
            <xsl:when test="@width='wide'">
              <xsl:attribute name="margin-top">0.75in</xsl:attribute>
              <xsl:attribute name="margin-left">0in</xsl:attribute>
              <xsl:attribute name="margin-right">0in</xsl:attribute>
            </xsl:when>
            <xsl:when test="$booktype = 'airport' ">
              <xsl:attribute name="margin-top">0.75in</xsl:attribute>
              <xsl:attribute name="margin-left">0.25in</xsl:attribute>
              <xsl:attribute name="margin-right">0.25in</xsl:attribute>
              <xsl:attribute name="text-indent">0.5cm</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="margin-top">1.5in</xsl:attribute>
              <xsl:attribute name="margin-left">1in</xsl:attribute>
              <xsl:attribute name="margin-right">1in</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="partintro/p[position()=last()]">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="long-partintro"/>
  <xsl:template match="long-partintro" mode="force">
    <xsl:choose>
      <xsl:when test="$booktype = 'pguide'">
        <fo:block margin-top="17.5pt" break-before="page">
          <xsl:choose>
            <xsl:when test="//task">
              <xsl:attribute name="font-size">10.5pt</xsl:attribute>
              <xsl:attribute name="font-family">
                <xsl:value-of select="$sans.font.family"/>
              </xsl:attribute>
              <xsl:attribute name="page-break-before">always</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="font-size">10.5pt</xsl:attribute>
              <xsl:attribute name="font-family">
                <xsl:value-of select="$sans.font.family"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block margin-top="1.5in"
                  border-top="1pt solid black"
                  border-bottom="1pt solid black"
                  padding-top="3pt"
                  padding-bottom="3pt"
                  font-style="italic"
                  font-size="10.5pt">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Added templates for recipe.  Remember that recipe can be a peer to chapter or to sect1.
       If it is contained by book or part, it will need its own page-sequence.
  -->
  <xsl:template match="mainmatter/recipe[1][not(preceding::mainmatter/part)][not(preceding::mainmatter/chapter)]">
    <xsl:call-template name="recipe">
      <xsl:with-param name="reset-page-sequence">yes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="recipe" name="recipe">
    <xsl:param name="reset-page-sequence"/>
    <xsl:choose>

      <xsl:when test="parent::book or parent::part or not(parent::*)">
        <xsl:call-template name="recipe-page-sequence">
          <xsl:with-param name="reset-page-sequence"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="recipe-heading">
          <xsl:with-param name="number">
            <xsl:number format="1" count="recipe" level="any"/>
          </xsl:with-param>
          <xsl:with-param name="name">
            <xsl:apply-templates select="title" mode="force"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:if test="./epigraph">
          <xsl:call-template name="free-standing-epigraph"/>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="@stubout='yes'">
            <fo:block id="{@id}">Content to be supplied later.</fo:block>
          </xsl:when>

          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="@break='no'">
                <fo:block border-bottom="1pt solid {$color.sidebar-border}"  margin-bottom="12pt" ><!-- margin-before="-12pt" margin-before.conditionality="discard"  -->
                  <xsl:apply-templates/>
                </fo:block>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="recipe-page-sequence">
    <xsl:param name="reset-page-sequence"/>
    <fo:page-sequence xsl:use-attribute-sets="recipepad" master-reference="chapter">
      <xsl:choose>
        <xsl:when test="$reset-page-sequence = 'yes'">
          <xsl:attribute name="initial-page-number">1</xsl:attribute>
        </xsl:when>
        <xsl:when test="not($recipe.padding='no')">
          <xsl:attribute name="initial-page-number">auto-odd</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="setup-page-headers"/>
      <xsl:call-template name="setup-page-footers"/>
      <xsl:call-template name="blank-page-setup"/>

      <fo:flow flow-name="xsl-region-body" start-indent="{$flow-indent}" end-indent="{$flow-indent}" hyphenation-remain-character-count="3">

        <xsl:call-template name="recipe-heading">
          <xsl:with-param name="number">
            <xsl:number format="1" count="recipe" level="any"/>
          </xsl:with-param>
          <xsl:with-param name="name">
            <xsl:apply-templates select="title" mode="force"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:if test="./epigraph">
          <xsl:call-template name="free-standing-epigraph"/>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="@stubout='yes'">
            <fo:block id="{@id}">Content to be supplied later.</fo:block>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:flow>
    </fo:page-sequence>

  </xsl:template>

  <xsl:template name="recipe-heading">
    <xsl:param name="name"/>
    <xsl:param name="number"/>
    <xsl:variable name="startindent.number">
      <xsl:value-of select="$flow-indent.number - 0.2"/>
    </xsl:variable>

    <fo:block start-indent="{concat($startindent.number,'in')}" width="7in" keep-together.within-page="always" keep-with-next="always">
      <xsl:attribute name="padding-top">
        <xsl:choose>
          <xsl:when test="@break='no'">21pt</xsl:when>
          <xsl:otherwise>32pt</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="page-break-before">
        <xsl:choose>
          <xsl:when test="@break = 'yes' and not(parent::part or parent::book)">always</xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="id">
        <xsl:call-template name="get-or-generate-id"/>
      </xsl:attribute>

      <xsl:if test="parent::part">
        <fo:marker marker-class-name="chapter-name">
          <xsl:apply-templates select="parent::part/title" mode="force"/>
        </fo:marker>
      </xsl:if>

      <fo:marker marker-class-name="section-name">
        <xsl:apply-templates select="title" mode="force"/>
      </fo:marker>

      <fo:instream-foreign-object keep-with-next="always">
        <xsl:choose>
          <xsl:when test="$booktype='pguide'">
            <xsl:call-template name="six-by-nine-recipe-top">
              <xsl:with-param name="number" select="$number"/>
              <xsl:with-param name="recipetitle" select="$recipetitle"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="seven-half-by-nine-recipe-top">
              <xsl:with-param name="number" select="$number"/>
              <xsl:with-param name="recipetitle" select="$recipetitle"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </fo:instream-foreign-object>

      <xsl:variable name="recipe-title-indent.number">
        <xsl:value-of select="$flow-indent.number - 0.186"/>
      </xsl:variable>

      <xsl:variable name="recipe-title-end-indent.number">
        <xsl:value-of select="$flow-indent.number - 0.1"/>
      </xsl:variable>

      <fo:block padding-top="6pt" space-before="-5pt"
                start-indent="{concat($recipe-title-indent.number,'in')}"
                end-indent="{concat($recipe-title-end-indent.number,'in')}"
                font-family="{$heading.font.family}" font-size="14pt"
                border-left-width=".774pt"
                border-left-style="solid"
                border-left-color="{$color.sidebar-border}"
                border-right-width=".774pt"
                border-right-style="solid"
                border-right-color="{$color.sidebar-border}"
                color="{$color.our-mid-heading-text}"
                >
        <fo:block xsl:use-attribute-sets="format-for-tip-and-recipe-title"><xsl:value-of select="$name"/></fo:block>
      </fo:block>

      <fo:block padding-top="15.3pt" padding-bottom="-12pt">
        <fo:instream-foreign-object>
          <xsl:choose>
            <xsl:when test="$booktype='pguide'">
              <xsl:call-template name="six-by-nine-bottom"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="seven-half-by-nine-bottom"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:instream-foreign-object>
      </fo:block>

    </fo:block>
  </xsl:template>

  <xsl:template name="seven-half-by-nine-recipe-top">
    <xsl:param name="recipetitle"/>
    <xsl:param name="number"/>
    <xsl:param name="type"/>
    <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="646.5px" height="37px" viewBox="0 0 646.5 37" enable-background="new 0 0 646.5 37" xml:space="preserve">
      <path fill="{$color.our-mid-line-svg}" stroke="{$color.sidebar-border-svg}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M13.182,27.333
	                                                                                                                                               h315.326c7.409,0,11.695-3.883,11.695-10.575v-4.168c0-6.707,4.304-10.589,11.71-10.589h161.951c7.41,0,11.695,3.882,11.695,10.589
	                                                                                                                                               v4.168c0,6.692,4.3,10.575,11.697,10.575h87.739c7.393,0,11.694,3.88,11.694,10.588H1c0-6.708,4.49-10.588,12.245-10.588"/>
      <!--    <rect x="1" y="37.94" fill="white" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" width="635.69" height="0.164"/>-->
      <text transform="matrix(0.9698 0 0 1 393.8779 25.5088)" font-family="{$heading.font.family}" font-size="19.426"><xsl:value-of select="concat($recipetitle,' ')"/><xsl:value-of select="$number"/></text>
    </svg>
  </xsl:template>

  <xsl:template name="six-by-nine-recipe-top">
    <xsl:param name="recipetitle"/>
    <xsl:param name="number"/>

    <svg version="1.1" id="Layer_1"
         xmlns="http://www.w3.org/2000/svg"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         x="0px" y="0px"
	       width="532.75px" height="37px" viewBox="0 0 532.75 37"
         enable-background="new 0 0 532.75 37" xml:space="preserve">
      <path fill="{$color.our-mid-line-svg}" stroke="{$color.sidebar-border-svg}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" d="M9.73,27.333h225.985
	                                                                                                                                               c5.31,0,8.381-3.883,8.381-10.575V12.59c0-6.707,3.084-10.589,8.393-10.589h116.066c5.31,0,8.382,3.882,8.382,10.589v4.168
	                                                                                                                                               c0,6.692,3.081,10.575,8.383,10.575h62.879c5.299,0,8.382,3.88,8.382,10.588H1c0-6.708,3.219-10.588,8.776-10.588"/>
      <text transform="matrix(0.843 0 0 1 256.0156 22.0088)" font-family="{$heading.font.family}" font-size="19.426"><xsl:value-of select="concat($recipetitle,' ')"/><xsl:value-of select="$number"/></text>
    </svg>

  </xsl:template>

  <xsl:template name="seven-half-by-nine-bottom">
    <svg version="1.1" baseProfile="basic" id="Layer_1"
	 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="638.042px"
	 height="40.097px" viewBox="0 0 638.042 40.097" xml:space="preserve">
      <path fill="none" stroke="{$color.sidebar-border-svg}" stroke-width="1.35" d="M636.542,0c0,7.094-4.488,11.21-12.242,11.21H33.66H13.81h-0.567
	                                                                            C5.489,11.21,1,7.094,1,0"/>
    </svg>
  </xsl:template>

  <xsl:template name="six-by-nine-bottom">
    <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="638.042px" height="40.098px" viewBox="0 0 638.042 40.098" enable-background="new 0 0 638.042 40.098"
	 xml:space="preserve">
      <path fill="none" stroke="{$color.sidebar-border-svg}" stroke-width="1.35" d="M456.58,0c0,7.094-3.217,11.21-8.773,11.21H24.412H10.183H9.775
	                                                                            C4.218,11.21,1,7.094,1,0"/>
    </svg>
  </xsl:template>


  <xsl:template match="sect1">
    <fo:block>
      <fo:list-block start-indent="{concat($flow-indent.number - 0.4,'in')}"
                     provisional-distance-between-starts="0.4in"
                     provisional-label-separation="3pt" xsl:use-attribute-sets="sect1-upper-title" >
        <xsl:call-template name="add-or-generate-id"/>
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()" text-align="start">
            <xsl:if test="not($booktype = 'pguide')">
              <fo:block xsl:use-attribute-sets="format-for-sect1-title">
                <fo:marker marker-class-name="section-name">
                  <xsl:apply-templates select="title" mode="force"/>
                </fo:marker>
              </fo:block>
            </xsl:if>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()" text-align="start">
            <fo:block xsl:use-attribute-sets="format-for-sect1-title">
              <xsl:apply-templates select="title" mode="force"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>

      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>


  <xsl:template match="sect2">
    <fo:block>
      <xsl:element name="fo:block" use-attribute-sets="format-for-sect2-title">
        <xsl:call-template name="add-id"/>
        <xsl:apply-templates select="title" mode="force"/>
      </xsl:element>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>



  <xsl:template match="sect3">
    <fo:block>
      <xsl:element name="fo:block" use-attribute-sets="format-for-sect3-title">
        <xsl:call-template name="add-id"/>
        <xsl:apply-templates select="title" mode="force"/>
      </xsl:element>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>



  <xsl:template match="sect4">
    <fo:block>
      <xsl:element name="fo:block" use-attribute-sets="format-for-sect4-title">
        <xsl:call-template name="add-id"/>
        <xsl:apply-templates select="title" mode="force"/>
      </xsl:element>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>



  <xsl:template name="chapter-heading">
    <xsl:param name="type"/>
    <xsl:param name="number"/>
    <xsl:param name="name"/>
    <xsl:param name="extra"/>

    <fo:block color="white" line-height="0pt">

      <fo:marker marker-class-name="chapter-name">
        <xsl:if test="ancestor::mainmatter and not(ancestor-or-self::index) and not(ancestor-or-self::bibsection)and $omit.chapnums='no'">
          <xsl:value-of select="$type"/>
          <xsl:text>&#160;</xsl:text>
          <xsl:value-of select="$number"/>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:value-of select="$name"/>
      </fo:marker>

      <fo:marker marker-class-name="section-name">
        <xsl:if test="ancestor::mainmatter and not(ancestor-or-self::index) and not(ancestor-or-self::bibsection) and $omit.chapnums='no'">
          <xsl:value-of select="$type"/>
          <xsl:text>&#160;</xsl:text>
          <xsl:value-of select="$number"/>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:value-of select="$name"/>
      </fo:marker>
    </fo:block>

    <xsl:if test="./extract[following-sibling::*[1][name()='title']]">
      <xsl:for-each select="extract[1]">
        <xsl:call-template name="start_extract"/>
      </xsl:for-each>
    </xsl:if>

    <fo:block-container xsl:use-attribute-sets="heading-font">
      <xsl:if test="./banner">
        <xsl:apply-templates select="banner" mode="force"/>
      </xsl:if>

      <fo:table start-indent="0in" end-indent="0in" width="100%">
        <fo:table-column column-number="1" width="2.5in"/>
        <fo:table-body>
          <fo:table-row>
            <xsl:attribute name="height">
              <xsl:choose>
                <xsl:when test="./banner">
                  <xsl:text>20pt</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>72pt</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <fo:table-cell start-indent="0in" end-indent="0in">
              <fo:block padding-top="12pt">
                <xsl:if test="./epigraph">
                  <xsl:apply-templates select="epigraph" mode="force"/>
                </xsl:if>
                <xsl:if test="./wecover">
                  <xsl:apply-templates select="wecover" mode="force"/>
                </xsl:if>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell start-indent="0in" end-indent="0in">
              <xsl:if test="not(ancestor::frontmatter) and $omit.chapnums='no'">
                <!--  <fo:block font-weight="normal" font-size="12pt"  space-after="18pt" space-before.conditionality="retain"> -->
                <fo:block text-align="right"
                          space-before="1in" font-weight="normal" font-size="12pt"
                          space-after="18pt" space-before.conditionality="retain">
                  <xsl:attribute name="color">
                    <xsl:choose>
                      <xsl:when test="$color = 'yes'">
                        <xsl:value-of select="$color.our-mid-heading-text"/>
                      </xsl:when>
                      <xsl:otherwise>black</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:variable name="first-letter">
                    <xsl:value-of select="substring($type,1,1)"/>
                  </xsl:variable>
                  <xsl:variable name="remainder">
                    <xsl:value-of select="substring($type,2)"/>
                  </xsl:variable>
                  <xsl:value-of select="$first-letter"/><xsl:value-of select="translate($remainder,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                  <xsl:text>&#160;</xsl:text>
                  <fo:inline font-size="18pt"><xsl:value-of select="$number"/></fo:inline>
                </fo:block>
              </xsl:if>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell number-columns-spanned="2">
              <fo:block space-after="0.2in" start-indent="0in"
                        end-indent="0in" text-align="right" hyphenate="false">
                <xsl:call-template name="add-or-generate-id"/>
                <xsl:call-template name="draw-underlined-heading">
                  <xsl:with-param name="title">
                    <xsl:copy-of select="$name"/>
                  </xsl:with-param>
                  <xsl:with-param name="extra">
                    <xsl:copy-of select="$extra"/>
                  </xsl:with-param>
                </xsl:call-template>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>


    </fo:block-container>

  </xsl:template>


  <xsl:template match="banner"/>
  <xsl:template match="banner" mode="force">
    <fo:block
        margin-left="0pt"
        start-indent="0pt"
        margin-right="0pt">

      <xsl:if test="@vertical-adjust">
        <xsl:attribute name="margin-bottom">
          <xsl:value-of select="@vertical-adjust"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="./title">
        <fo:block
            font-family="{$sans.font.family}"
            font-style="italic"
            line-height="100%"
            text-align="center"
            margin-left="0pt"
            start-indent="0pt"
            margin-right="0pt">
          <xsl:apply-templates select="title" mode="force"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="wecover"/>
  <xsl:template match="wecover" mode="force">
    <fo:block font-size="smaller" font-family="{$sans.font.family}" line-height="130%"
              text-align="left" margin-left="0pt" start-indent="0pt" margin-right="0pt">
      <fo:block>In this chapter, you'll see:</fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="epigraph"/>
  <xsl:template match="epigraph" mode="force">
    <fo:block font-size="smaller" font-style="italic" line-height="140%"
              text-align="left" margin-left="0pt" start-indent="0pt" margin-right="0pt">
      <xsl:apply-templates select="epitext"/>
      <xsl:if test="./name/text()">
        <fo:block  text-align="left" margin-left="2em">
          <fo:inline color="rgb-icc(220, 220, 220, #Grayscale, 0.83)" font-family="{$symbol.font.family}">>
          <xsl:text>&#x27a4;</xsl:text>
          </fo:inline>
          <xsl:text>&#160;</xsl:text>
          <xsl:apply-templates select="name"/>
          <xsl:if test="./title">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="title"/>
          </xsl:if>
          <xsl:if test="./date">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="date"/>
          </xsl:if>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template name="free-standing-epigraph">
    <fo:table start-indent="{$flow-indent}" end-indent="0in" width="60%"
              margin-bottom="8pt">
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell start-indent="0in" end-indent="0in">
            <fo:block padding-top="2pt">
              <xsl:apply-templates select="epigraph" mode="force"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>


  <xsl:template match="epigraph/title"/>

  <xsl:template match="epigraph/date"/>

  <xsl:template match="epigraph/epitext/p[position()=last()]">
    <fo:block margin-bottom="3pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="epitext">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="epigraph/name">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="bibsection">
    <xsl:param name="reset-page-sequence"/>
    <!-- Note: This parameter is not used in this template, but if it is omitted, a Java heap space error occurs.
         In fact, the parameter could be named anything and it would still fix the Java heap space error! -->
    <fo:page-sequence xsl:use-attribute-sets="end-on-page-before-chapter-start" master-reference="chapter">
      <xsl:call-template name="initial-page-number"/>
      <xsl:call-template name="setup-page-headers"/>
      <xsl:call-template name="setup-page-footers"/>
      <xsl:call-template name="blank-page-setup"/>
      <fo:flow flow-name="xsl-region-body" start-indent="{$flow-indent}" end-indent="{$flow-indent}" hyphenation-remain-character-count="3">
        <xsl:call-template name="chapter-heading">
          <xsl:with-param name="type"/>
          <xsl:with-param name="number"/>
          <xsl:with-param name="name">Bibliography</xsl:with-param>
          <xsl:with-param name="extra"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>


  <xsl:template name="force-recto">
    <fo:page-sequence master-reference="blank-page"
                      xsl:use-attribute-sets="end-on-page-before-chapter-start">
      <fo:flow flow-name="xsl-region-body">
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

</xsl:stylesheet>
