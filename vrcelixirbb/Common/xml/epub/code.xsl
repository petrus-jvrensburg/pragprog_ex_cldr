<!-- stylesheet shared between books and magazines -->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0"
    >

  <xsl:preserve-space elements="codeline"/>
  
  <xsl:template match="processedcode">
    <xsl:call-template name="code-lozenge"/>
    <table>
      <xsl:attribute name="class">
	<xsl:text>processedcode</xsl:text>
	<xsl:if test="@style='shaded'">
	  <xsl:text> shaded</xsl:text>
	</xsl:if>
      </xsl:attribute>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates mode="code"/>
    </table>
  </xsl:template>

  <xsl:template name="code-lozenge">
    <xsl:if test="@showname != 'no'">
      <div class="livecodelozenge">
        <xsl:choose>
          <xsl:when test="@url">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:text>http://media.pragprog.com/titles/</xsl:text>
                <xsl:value-of select="/book/bookinfo/@code"/>
                <xsl:text>/code/</xsl:text>
                <xsl:value-of select="@url"/>
              </xsl:attribute>
              <xsl:if test="ancestor::table">
              </xsl:if>
              <xsl:value-of select="@showname"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@file"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
  </xsl:template>


  <xsl:template name="create-callout">
    <xsl:param name="number"/>
    <span class="callout-number">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$number"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="codeline"  mode="code">
    <tr>
      <td class="codeinfo">
        <xsl:choose>
          <xsl:when test="@highlight = 'yes'">
            <xsl:text>»</xsl:text>
          </xsl:when>

          <xsl:when test="@calloutno or child::callout">
            <xsl:text>&#x200b;</xsl:text>
            <span class="codeprefix">
              <xsl:call-template name="callout-number">
                <xsl:with-param name="number">
                  <xsl:value-of select="count(preceding-sibling::codeline/@calloutno) + count(preceding-sibling::codeline/callout) + 1"/>
                </xsl:with-param>
              </xsl:call-template>
            </span>
          </xsl:when>

          <xsl:otherwise>
            <xsl:text>&#x200b;</xsl:text>
            <span class="codeprefix">
              <xsl:if test="@prefix or child::label">
                <xsl:choose>
		  <xsl:when test="@prefix = 'in'">
		    <xsl:text>=&gt;</xsl:text>
		  </xsl:when>

                  <xsl:when test="@prefix = 'out'">
		    <xsl:text>&lt;=</xsl:text>
		  </xsl:when>

                  <xsl:when test="@prefix or child::label">
                    <xsl:choose>
                      <xsl:when test="@prefix='Line 1'">
                        <xsl:text>1:</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@prefix"/>
                        <xsl:analyze-string select="@prefix" regex="^\d+$">
                          <xsl:matching-substring>
                            <xsl:text>:</xsl:text>
                          </xsl:matching-substring>
                        </xsl:analyze-string>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>

                </xsl:choose>
              </xsl:if>
              <xsl:text>&#160;</xsl:text>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="codeline">
        <xsl:apply-templates mode="code"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Note: the zero-width spaces are needed due to what appears to be a bug, 
       in which consecutive inline elements have a line return added between them if there is no text between them. 
       Disabling indentation does not prevent the addition of the line break.  -->
  
  <xsl:template match="cokw"  mode="code">&#x200b;<strong class="kw"><xsl:apply-templates  mode="code"/></strong>&#x200b;</xsl:template>

  <xsl:template match="cocomment"  mode="code">&#x200b;<em class="comment"><xsl:apply-templates  mode="code"/></em>&#x200b;</xsl:template>

  <xsl:template match="coprompt" mode="code">&#x200b;<span class="coprompt"><xsl:apply-templates  mode="code"/></span>&#x200b;</xsl:template>

  <xsl:template match="costring"  mode="code">&#x200b;<em class="string"><xsl:apply-templates  mode="code"/></em>&#x200b;</xsl:template>

  <xsl:template match="cobold"  mode="code">&#x200b;<strong class="kw"><xsl:apply-templates  mode="code"/></strong>&#x200b;</xsl:template>

  <xsl:template match="newline"><br /></xsl:template>
  
  <xsl:template match="eof"><xsl:call-template name="eof"/></xsl:template>

  <xsl:template match="eof" mode="code">&#x200b;<xsl:call-template name="eof"/>&#x200b;</xsl:template>

  <xsl:template name="eof">&#x200b;<small>&#x200b;<sup>E</sup>&#x200b;<small>O</small>&#x200b;<sub>F</sub>&#x200b;</small>&#x200b;</xsl:template>

</xsl:stylesheet>
