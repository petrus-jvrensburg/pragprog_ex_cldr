<?xml version="1.0"?>

<xsl:stylesheet version="2.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:pp="http://pragprog.com" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="contents-page">
    <fo:page-sequence format="i" initial-page-number="auto-odd" master-reference="contents" xsl:use-attribute-sets="end-on-page-before-chapter-start">

      <xsl:call-template name="setup-page-headers"/>

      <xsl:call-template name="blank-page-setup"/>

      <fo:flow flow-name="xsl-region-body">
        <fo:block>

          <xsl:attribute name="id">
            <xsl:text>toc</xsl:text>

            <xsl:call-template name="get-or-generate-id"/>
          </xsl:attribute>
          <fo:marker marker-class-name="chapter-name">Contents</fo:marker>
          <fo:marker marker-class-name="section-name">Contents</fo:marker>
          <xsl:if test="$booktype != 'airport'">
            <fo:block space-after="{$space-after-contents-heading}" space-before.conditionality="retain" space-before="{$space-before-contents-heading}" text-align="right">
              <xsl:call-template name="draw-underlined-heading">
                <xsl:with-param name="title">Contents</xsl:with-param>
              </xsl:call-template>
            </fo:block>
          </xsl:if>

          <xsl:call-template name="generate-toc-contents"/>

          <xsl:if test="mainmatter/index">

            <xsl:for-each select="mainmatter/index">
              <xsl:call-template name="index-entry"/>
            </xsl:for-each>
          </xsl:if>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <!-- may be locally overridden to change font-size/spacing -->
  <xsl:template name="generate-toc-contents">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>

  <xsl:template name="index-entry">
    <fo:list-block provisional-distance-between-starts="0.35in" provisional-label-separation="2pt">
      <fo:list-item margin-bottom="8pt">

        <fo:list-item-label end-indent="label-end()">
          <fo:block/>
        </fo:list-item-label>

        <fo:list-item-body start-indent="body-start()">
          <fo:block end-indent="24pt" font-weight="bold" hyphenate="false" keep-with-next.within-page="always" last-line-end-indent="-24pt" text-align-last="justify">
            <fo:inline letter-spacing="0pt" word-spacing="0pt">

              <xsl:call-template name="internal-link">

                <xsl:with-param name="dest">
                  <xsl:call-template name="get-or-generate-id"/>
                </xsl:with-param>

                <xsl:with-param name="text">
                  <xsl:value-of select="'Index'"/>
                </xsl:with-param>
              </xsl:call-template>
            </fo:inline>
            <xsl:text> </xsl:text>
            <fo:inline keep-together.within-line="always">
              <fo:leader leader-pattern-width="2em" leader-pattern="use-content">.</fo:leader>
              <fo:inline letter-spacing="0pt" word-spacing="0pt">
                <fo:page-number-citation>

                  <xsl:attribute name="ref-id">
                    <xsl:call-template name="get-or-generate-id"/>
                  </xsl:attribute>
                </fo:page-number-citation>
              </fo:inline>
            </fo:inline>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="*" mode="toc"/>

  <xsl:template match="frontmatter | mainmatter" mode="toc">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>

  <xsl:template match="part" mode="toc">
    <fo:block font-family="{$sans.font.family}"
              font-size="120%"
              font-weight="bold"
              keep-with-next="always"
              margin-bottom="6pt"
              margin-top="12pt"
              text-align="center">
      <xsl:if test="@toc-on-new-page = 'yes'">
        <xsl:attribute name="break-before">page</xsl:attribute>
      </xsl:if>

      <xsl:text>Part </xsl:text>

      <xsl:number count="part" format="I" from="book" level="any"/>
      <xsl:text> — </xsl:text>

      <xsl:apply-templates mode="force" select="title"/>
    </fo:block>

    <xsl:apply-templates mode="toc"/>
  </xsl:template>

  <xsl:template match="chapter[not(@intoc='no')]" mode="toc">

    <xsl:call-template name="generate-toc-entry">

      <xsl:with-param name="number">
        <xsl:number count="chapter[not(@intoc='no')]" format="1." from="book/mainmatter" level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="recipe[not(@intoc='no')]" mode="toc">

    <xsl:choose>

      <xsl:when test="parent::book or parent::part">

        <xsl:choose>

          <xsl:when test="not(descendant::sect1)
			  and (not(preceding-sibling::chapter)
			  and not(preceding-sibling::appendix)
			  and not(following-sibling::chapter)
			  and not(following-sibling::appendix))">

            <xsl:call-template name="generate-recipe-entry">

              <xsl:with-param name="label-number">

                <xsl:value-of select="concat($recipetitle,' ')"/>

                <xsl:number count="recipe[not(@intoc='no')]" format="1." from="book" level="any"/>
              </xsl:with-param>

              <xsl:with-param name="title">
                <xsl:apply-templates mode="force" select="./title"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>

          <xsl:otherwise>

            <xsl:call-template name="generate-recipe-entry">

              <xsl:with-param name="label-number">

                <xsl:value-of select="concat($recipetitle,' ')"/>

                <xsl:number count="recipe[not(@intoc='no')]" format="1." from="book" level="any"/>
              </xsl:with-param>

              <xsl:with-param name="title">
                <xsl:apply-templates mode="force" select="./title"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="parent::chapter or parent::appendix">

        <xsl:call-template name="generate-recipe-entry">

          <xsl:with-param name="label-number">

            <xsl:value-of select="concat($recipetitle,' ')"/>

            <xsl:number count="recipe[not(@intoc='no')]" format="1." from="book" level="any"/>
          </xsl:with-param>

          <xsl:with-param name="title">
            <xsl:apply-templates mode="force" select="./title"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="task[not(@intoc='no')]" mode="toc">

    <xsl:if test="parent::book or parent::part or @intoc='yes'">

      <xsl:call-template name="generate-toc-entry">

        <xsl:with-param name="title">

          <xsl:value-of select="'Task '"/>

          <xsl:number count="task[not(@intoc='no')]" format="1." from="mainmatter" level="any"/>
          <xsl:text> </xsl:text>

          <xsl:apply-templates mode="force" select="./title"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="appendix[not(@intoc='no')]" mode="toc">

    <xsl:call-template name="generate-toc-entry">

      <xsl:with-param name="number">
        <xsl:text>A</xsl:text>

        <xsl:number count="appendix[not(@intoc='no')]" format="1." from="book" level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="bibsection[not(@intoc='no')]" mode="toc">
    <fo:block margin-top="9pt">

      <xsl:call-template name="generate-toc-entry">

        <xsl:with-param name="title">Bibliography</xsl:with-param>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="generate-toc-entry">

    <xsl:param name="title">
      <xsl:apply-templates mode="force" select="./title"/>
    </xsl:param>

    <xsl:param name="number"/>

    <xsl:variable name="child-count">
      <xsl:value-of select="count(child::sect1[not(@intoc='no')]) +
                            count(child::task[not(@intoc='no')]) +
                            count(child::recipe[not(@intoc='no')])"/>
    </xsl:variable>

    <fo:list-block provisional-distance-between-starts="0.35in" provisional-label-separation="0.1in">

      <xsl:attribute name="keep-with-previous.within-page">

        <xsl:choose>

          <xsl:when test="not(following-sibling::*[not(@intoc='no')]) and not(child::sect1[not(@intoc='no')])">always</xsl:when>

          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="keep-together.within-page">

        <xsl:choose>

          <xsl:when test="$child-count &lt; 4">always</xsl:when>

          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:if test="@toc-on-new-page = 'yes'">
        <xsl:attribute name="break-before">page</xsl:attribute>
      </xsl:if>

      <fo:list-item>

        <xsl:if test="$child-count &gt; 0">

          <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
        </xsl:if>

        <fo:list-item-label end-indent="label-end()">
          <fo:block font-weight="bold">

            <xsl:if test="not(ancestor::frontmatter) and $omit.chapnums='no'">
              <xsl:value-of select="$number"/>
            </xsl:if>
          </fo:block>
        </fo:list-item-label>

        <fo:list-item-body start-indent="body-start()">
          <fo:block end-indent="24pt" font-weight="bold" hyphenate="false" keep-with-next.within-page="always" last-line-end-indent="-24pt" start-indent="72pt" text-align-last="justify" text-indent="-48pt">
            <fo:inline letter-spacing="0pt" word-spacing="0pt">

              <xsl:call-template name="internal-link">

                <xsl:with-param name="dest">
                  <xsl:call-template name="get-or-generate-id"/>
                </xsl:with-param>

                <xsl:with-param name="text">
                  <xsl:value-of select="$title"/>
                </xsl:with-param>
              </xsl:call-template>
            </fo:inline>
            <fo:inline keep-together.within-line="always">
              <xsl:text> </xsl:text>
              <!-- The leader does not justify properly if it is the first item on a line, so we add a space before it. The space used to be outside the fo:inline, so no extra space is being added. -->
              <fo:leader leader-pattern-width="2em" leader-pattern="use-content">.</fo:leader>
              <fo:inline letter-spacing="0pt" word-spacing="0pt">
                <fo:page-number-citation>

                  <xsl:attribute name="ref-id">
                    <xsl:call-template name="get-or-generate-id"/>
                  </xsl:attribute>
                </fo:page-number-citation>
              </fo:inline>
            </fo:inline>
          </fo:block>

          <xsl:if test="./title/p">
            <fo:block
              end-indent="24pt"
              font-size="80%"
              font-style="italic"
              margin-top="3pt"
              margin-bottom="12pt"
              >
              <xsl:apply-templates select="./title/p" mode="force"/>
            </fo:block>
          </xsl:if>

          <xsl:if test="not(@stubout='yes') and not(./title/p)">

            <xsl:for-each select="./sect1[ancestor::mainmatter] |
                                  ./task[ancestor::mainmatter] |
                                  ./recipe[ancestor::mainmatter]">

              <xsl:choose>

                <xsl:when test="@intoc = 'no'"/>

                <xsl:when test="name() = 'sect1'">

                  <xsl:call-template name="generate-sect1-entry">

                    <xsl:with-param name="chap-number"><xsl:value-of select="$number"/></xsl:with-param>
                  </xsl:call-template>

                </xsl:when>

                <xsl:when test="name() = 'task'">

                  <xsl:call-template name="generate-recipe-entry">

                    <xsl:with-param name="label-number">

                      <xsl:value-of select="concat($tasktitle,' ')"/>

                      <xsl:number count="task[not(@intoc='no')]" format="1." from="book" level="any"/>
                    </xsl:with-param>

                    <xsl:with-param name="title">
                      <xsl:apply-templates mode="force" select="./title"/>
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>

                  <xsl:call-template name="generate-recipe-entry">

                    <xsl:with-param name="label-number">

                      <xsl:value-of select="concat($recipetitle,' ')"/>

                      <xsl:number count="recipe[not(@intoc='no')]" format="1." from="book" level="any"/>
                    </xsl:with-param>

                    <xsl:with-param name="title">
                      <xsl:apply-templates mode="force" select="./title"/>
                    </xsl:with-param>
                  </xsl:call-template>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:if>
        </fo:list-item-body>
      </fo:list-item>

    </fo:list-block>

  </xsl:template>

  <xsl:template name="generate-sect1-entry">

    <xsl:param name="title">
      <xsl:apply-templates mode="force" select="./title"/>
    </xsl:param>

    <xsl:param name="chap-number"/>

    <fo:block end-indent="24pt" hyphenate="false" last-line-end-indent="-24pt" text-align-last="justify" text-align="left">

      <xsl:attribute name="keep-with-next">

        <xsl:choose>

          <xsl:when test="self::chapter or self::appendix">always</xsl:when>

          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:attribute name="keep-with-previous.within-page">

        <xsl:choose>

          <xsl:when test="not(following-sibling::sect1[not(@intoc='no')])">always</xsl:when>

          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:call-template name="internal-link">

        <xsl:with-param name="dest">
          <xsl:call-template name="get-or-generate-id"/>
        </xsl:with-param>

        <xsl:with-param name="text">
          <xsl:value-of select="$title"/>
        </xsl:with-param>
      </xsl:call-template>
      <fo:inline keep-together.within-line="always">
        <fo:leader leader-pattern="space"/>
        <fo:page-number-citation>

          <xsl:attribute name="ref-id">
            <xsl:call-template name="get-or-generate-id"/>
          </xsl:attribute>
        </fo:page-number-citation>
      </fo:inline>
    </fo:block>

    <xsl:if test="./sect1">
      <xsl:apply-templates mode="toc" select="sect1[not(@intoc='no')]"/>
    </xsl:if>

  </xsl:template>

  <xsl:template name="generate-recipe-entry">

    <xsl:param name="label-number"/>

    <xsl:param name="title"/>

    <fo:list-block keep-together.within-page="auto" keep-with-previous.within-page="auto" provisional-distance-between-starts="58pt" provisional-label-separation="0pt">
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
          <fo:block font-weight="normal">

            <xsl:call-template name="internal-link">

              <xsl:with-param name="dest">
                <xsl:call-template name="get-or-generate-id"/>
              </xsl:with-param>

              <xsl:with-param name="text">
                <xsl:value-of select="$label-number"/>
              </xsl:with-param>
            </xsl:call-template>
          </fo:block>
        </fo:list-item-label>

        <fo:list-item-body start-indent="body-start()">
          <fo:block end-indent="18pt" font-weight="normal" hyphenate="false" last-line-end-indent="-18pt" text-align-last="justify" text-align="left">

            <xsl:call-template name="internal-link">

              <xsl:with-param name="dest">
                <xsl:call-template name="get-or-generate-id"/>
              </xsl:with-param>

              <xsl:with-param name="text">
                <xsl:value-of select="$title"/>
              </xsl:with-param>
            </xsl:call-template>
            <fo:inline keep-together.within-line="always">
              <fo:leader leader-pattern="space"/>
              <fo:page-number-citation>

                <xsl:attribute name="ref-id">
                  <xsl:call-template name="get-or-generate-id"/>
                </xsl:attribute>
              </fo:page-number-citation>
            </fo:inline>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>

    <xsl:if test="./sect1">
      <xsl:apply-templates mode="toc" select="sect1[not(@intoc='no')]"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
