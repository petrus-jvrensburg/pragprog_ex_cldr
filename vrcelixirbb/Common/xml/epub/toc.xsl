<xsl:stylesheet  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="2.0">

  <xsl:template name="generate-toc">
    <nav
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:epub="http://www.idpf.org/2007/ops"
        epub:type="toc" class="pp-chunk table-of-contents">
      <h1 class="pp-no-chunk">Table of Contents</h1>
      <ol xmlns="http://www.w3.org/1999/xhtml">
        <xsl:apply-templates select="frontmatter" mode="toc"/>
        <xsl:apply-templates select="mainmatter" mode="toc"/>
      </ol>
    </nav>
  </xsl:template>

  <xsl:template match="*" mode="toc"> </xsl:template>

  <xsl:template match="frontmatter" mode="toc">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>

  <xsl:template match="mainmatter" mode="toc">
    <xsl:apply-templates mode="toc"/>
  </xsl:template>

  <xsl:template match="part" mode="toc">
    <li xmlns="http://www.w3.org/1999/xhtml" class="toc-part">
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:call-template name="sanitize-id">
                <xsl:with-param name="the-id">
                  <xsl:value-of select="@id"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="generate-id(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:text>Part </xsl:text>
        <xsl:number count="part[ancestor::mainmatter]" level="any" format="I. " from="book"/>
        <xsl:apply-templates select="title" mode="force"/>
      </a>
      <xsl:if test="descendant::chapter or descendant::appendix or descendant::recipe or descendant::task">
        <ol>
          <xsl:apply-templates mode="toc"/>
        </ol>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match="chapter|appendix|task|bibsection|recipe" mode="toc">
    <xsl:if test="not(@intoc='no')">
      <li xmlns="http://www.w3.org/1999/xhtml" class="toc-chap">
        <a>
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:choose>
              <xsl:when test="@id">
                <xsl:call-template name="sanitize-id">
                  <xsl:with-param name="the-id">
                    <xsl:value-of select="@id"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="generate-id(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>

          <xsl:choose>
            <xsl:when test="name() = 'dedication'">
              <xsl:text>Dedication</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="toc-secnum"/>
              <xsl:apply-templates select="./title" mode="force"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>

        <xsl:if test="child::sect1[not(@intoc='no')] | child::recipe[not(@intoc='no')]">
          <xsl:if test="not(@stubout='yes')">
            <ol>
              <xsl:apply-templates mode="toc"/>
            </ol>
          </xsl:if>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="//chapter/title/p"/>

  <xsl:template name="toc-secnum">
    <span  xmlns="http://www.w3.org/1999/xhtml" class="toc-secnum">
      <xsl:choose>
        <xsl:when test="ancestor::mainmatter">
          <xsl:choose>
            <xsl:when test="self::chapter[ancestor::mainmatter]">
              <xsl:number count="chapter" level="any" format="1. " from="mainmatter"/>
            </xsl:when>
            <xsl:when test="self::appendix[ancestor::mainmatter]">
              <xsl:text>A</xsl:text>
              <xsl:number count="appendix" level="any" format="1. " from="mainmatter"/>
            </xsl:when>
            <xsl:when test="self::task[ancestor::mainmatter]">
              <xsl:number count="task" level="any" format="1. " from="mainmatter"/>
            </xsl:when>
            <xsl:when test="self::recipe">
              <xsl:value-of select="concat($recipetitle,' ')"/>
              <xsl:number count="recipe" level="any" format="1. " from="mainmatter"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#160;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
    
  <xsl:template match="p" mode="wrap-in-span">
    <span  xmlns="http://www.w3.org/1999/xhtml" class="summary-in-toc">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="sect1[not(@intoc='no')]" mode="toc">
    <li xmlns="http://www.w3.org/1999/xhtml" class="toc-sect">
      <a>
        <xsl:attribute name="href">
          <xsl:text>#</xsl:text>
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:call-template name="sanitize-id">
                <xsl:with-param name="the-id">
                  <xsl:value-of select="@id"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="generate-id(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates select="title" mode="force"/>
      </a>
    </li>
  </xsl:template>
  
</xsl:stylesheet>

