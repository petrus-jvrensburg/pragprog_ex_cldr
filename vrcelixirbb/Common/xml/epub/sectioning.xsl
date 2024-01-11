<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>

  <xsl:template match="booktitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="booksubtitle">
    <xsl:apply-templates/>
  </xsl:template>

<!-- remove
  <xsl:template match="booksubtitle2">
    <xsl:apply-templates/>
  </xsl:template> -->



  <xsl:template match="banner"/>
  <xsl:template match="banner" mode="force">
      <div class="pp-chunk">
        <div class="banner">
          <xsl:apply-templates/>
        </div>
      </div>
  </xsl:template>

  <xsl:template match="banner/title">
    <hr/>
    <p>
      <xsl:apply-templates/>
    </p>
    <hr/>
  </xsl:template>


  <xsl:template match="epigraph | wecover" />

  <xsl:template match="epigraph" mode="force">
    <div class="epigraph pp-chunk">
      <div class="epitext">
	<xsl:apply-templates select="./epitext"/>
      </div>
        <div class="episign">
          <span class="episignname">
            <xsl:apply-templates select="./name" mode="force"/>
          </span>
          <span class="episigntitle">
            <xsl:apply-templates select="./title"/>
          </span>
          <span class="episigndate">
            <xsl:apply-templates select="./date"/>
          </span>
        </div>
    </div>
  </xsl:template>

  <xsl:template match="wecover" mode="force">
    <div class="epigraph wecover pp-chunk">
      <p>We cover:</p>
      <div class="epitext">
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="epitext">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="epigraph/name | epigraph/title | epigraph/date">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="part">
    <xsl:text>&#10;&#10;&#10;</xsl:text>
    <h1 class="part-title">
      <xsl:call-template name="add-or-generate-id"/>
      <span class="part-number">
	<xsl:text>Part </xsl:text>
        <xsl:number format="1" count="part" from="book" level="any"/>
      </span>
      <br />
	<xsl:apply-templates select="title" mode="force"/>
    </h1>
    <xsl:apply-templates />
    <!-- If the part contains no chapters, we may have to dump footnotes -->
    <xsl:if test="not(./chapter|./appendix)">
      <xsl:call-template name="dump-footnotes"/>
    </xsl:if>
    <br class="pp-chunk end-of-part"/>
  </xsl:template>

  <xsl:template match="partintro">
    <blockquote class="partintro">
      <xsl:call-template name="add-or-generate-id"/>
      <xsl:apply-templates />
    </blockquote>
    <!-- If the parent part has chapters or appendix, the partintro footnotes don't get processed unless... -->
    <xsl:if test="parent::part/chapter|parent::part/appendix">
      <xsl:call-template name="dump-footnotes"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="long-partintro">
    <blockquote class="partintro">
      <xsl:call-template name="add-or-generate-id"/>
      <xsl:apply-templates />
    </blockquote>
    <!-- If the parent part has chapters or appendix, the partintro footnotes don't get processed unless... -->
    <xsl:if test="parent::part/chapter|parent::part/appendix">
      <xsl:call-template name="dump-footnotes"/>
    </xsl:if>
  </xsl:template>

  <!-- remove match |contribution|preface -->
  <xsl:template match="chapter|appendix|bibsection">
    <xsl:if test="./banner">
      <xsl:apply-templates select="./banner" mode="force"/>
    </xsl:if>

    <xsl:if test="./epigraph">
      <xsl:apply-templates select="./epigraph" mode="force"/>
    </xsl:if>

    <xsl:if test="./wecover">
      <xsl:apply-templates select="./wecover" mode="force"/>
    </xsl:if>

    <xsl:text>&#10;&#10;&#10;</xsl:text>
    <h1>
      <xsl:attribute name="class">
        <xsl:text>chapter-title</xsl:text>

        <xsl:if test="./epigraph or ./wecover">
          <xsl:text> pp-no-chunk</xsl:text>
        </xsl:if>
      </xsl:attribute>

      <xsl:call-template name="add-or-generate-id"/>

      <span class="chapter-number">
        <xsl:choose>
          <xsl:when test="local-name() = 'chapter' and not(ancestor::frontmatter)">
            Chapter
            <xsl:number format="1" count="chapter"
                        from="book/mainmatter" level="any"/>
          </xsl:when>
          <xsl:when test="local-name() = 'appendix'">
            Appendix
            <xsl:number format="1" count="appendix"
                        from="book" level="any"/>
          </xsl:when>
        </xsl:choose>

      </span>
      <br />
      <span class="chapter-name">
	<xsl:apply-templates select="title" mode="force"/>
      </span>
    </h1>

    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="@stubout='yes'">
        <p>Content to be supplied later.</p>
      </xsl:when>
      <xsl:otherwise>
    <xsl:apply-templates />
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="dump-footnotes" />
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="add-copyright"/>
    <xsl:text>&#10;&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="recipe-head">
    <xsl:param name="type"/>
    <xsl:param name="number"/>
    <table class="arr-recipe">
      <xsl:call-template name="add-or-generate-id" />
      <tr>
        <td class="arr-recipe-number">
          <xsl:value-of select="concat($type,' ',$number)"/>
        </td>
        <td class="arr-recipe-name pp-use-as-title-2">
          <xsl:apply-templates select="title" mode="force"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="recipe" name="recipe">
    <xsl:comment>PP-SPLIT-H2</xsl:comment>
    <xsl:call-template name="recipe-head">
      <xsl:with-param name="type">
        <xsl:value-of select="$recipetitle"/>
      </xsl:with-param>
      <xsl:with-param name="number">
        <xsl:number format="1" count="recipe" from="book" level="any"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:if test="./epigraph">
      <xsl:apply-templates select="./epigraph" mode="force"/>
    </xsl:if>

    <xsl:apply-templates />
    <!-- If the parent part has chapters or appendix, the recipe footnotes don't get processed unless... -->
    <xsl:if test="parent::part/chapter|parent::part/appendix">
      <xsl:call-template name="dump-footnotes"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tip" name="tip">
    <xsl:call-template name="recipe-head">
      <xsl:with-param name="type">
        <xsl:value-of select="$recipetitle"/>
      </xsl:with-param>
      <xsl:with-param name="number">
        <xsl:number format="1" count="tip" from="book" level="any"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="sect1">
    <xsl:text>&#10;</xsl:text>
    <h2>
      <xsl:call-template name="add-or-generate-id"/>
      <xsl:apply-templates select="title" mode="force"/>
    </h2>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect2">
    <h3>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates select="title" mode="force"/>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect3">
    <h4>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates select="title" mode="force"/>
    </h4>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect4">
    <p><strong>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates select="title" mode="force"/>
    </strong></p>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- normally ignore all titles -
       they should be handled by their parents directly -->
  <xsl:template match="title"/>

  <!-- but sometimes we need to force one out -->
  <xsl:template match="title" mode="force">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- overall stuff we don't need -->

<xsl:template match="prefacesignoff">
  <div>  <xsl:text>&#10;</xsl:text></div>
  <div class="prefacesignoff">
    <xsl:value-of select="@name"/>
  </div>
  <xsl:if test="@title">
    <div class="prefacesignoffdate">
      <xsl:value-of select="@title"/>
    </div>
  </xsl:if>
  <xsl:if test="@email">
    <xsl:variable name="emailaddr">
          <xsl:value-of select="concat('mailto:',@email)"/>
    </xsl:variable>
    <div class="prefacesignoffemail">
      <a href="{$emailaddr}">
        <xsl:value-of select="$emailaddr"/>
      </a>
     </div>
  </xsl:if>
  <xsl:if test="@location or @date">
    <div class="prefacesignoffdate">
      <xsl:if test="@location">
        <xsl:value-of select="@location"/>
      </xsl:if>
      <xsl:if test="@location and @date">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:if test="@date">
        <xsl:value-of select="@date"/>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
