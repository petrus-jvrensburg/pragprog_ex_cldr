<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="2.0"> 


  <xsl:template match="frontmatter/praisepage">

     <xsl:apply-templates />
   
  </xsl:template>

  <xsl:template match="praisetitle">
    <h1>
      <xsl:apply-templates />
    </h1>
  </xsl:template>

  <xsl:template match="praisetitle/booksectname">
    <span>
      <xsl:apply-templates />
    </span>
  </xsl:template>


  <xsl:template match="praiseentry">
    <div style="margin-bottom:9px;margin-top:9px;">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="praiseentry/praise">
    <div class="praise">
      <xsl:apply-templates />
    </div>
  </xsl:template>


  <xsl:template match="praiseentry/person">
    <table class="praise">
      <tr>
        <td style="width:5%">→ </td>
        <td>
          <xsl:apply-templates select="name"/> 
        </td>
      </tr>
      <xsl:if test="jobtitle or affiliation">
        <tr class="praise">
          <td class="praise">
            <xsl:text>&#10;</xsl:text>
          </td>
          <td class="praise">
            <xsl:if test="jobtitle">
              <xsl:apply-templates select="jobtitle"/>
              <xsl:if test="affiliation">
                <xsl:text>, </xsl:text>
              </xsl:if>
            </xsl:if>
            <xsl:if test="affiliation">
              <xsl:apply-templates select="affiliation"/>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>
      
    </table>
  </xsl:template>

  <xsl:template match="praiseentry/person/name">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="praiseentry/person/jobtitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="praiseentry/person/affiliation">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
