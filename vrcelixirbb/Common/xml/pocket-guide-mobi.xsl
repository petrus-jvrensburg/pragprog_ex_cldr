<xsl:stylesheet  
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"> 

 <!--  <xsl:template match="partintro">
    <blockquote class="pg-partintro">
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template> -->


  <xsl:template match="task" mode="xref.name">
    <xsl:text>Task </xsl:text>
    <xsl:number format="1" count="task" from="book" level="any"/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="task" mode="xref.title">
    <xsl:variable name="title">
      <xsl:choose>
	<xsl:when test="toctitle">
	  <xsl:apply-templates select="toctitle" mode="strip"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="title" mode="force"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <em>
      <xsl:value-of select="normalize-space($title)"/>
    </em>
  </xsl:template>

  <xsl:template name="task-head">
    <p height="15">
      &#160;
    </p>

    <table width="95%" border="4">
      <xsl:call-template name="add-or-generate-id" />
      <tr>
	<td>
          <h2 text-align="center">
            <xsl:number format="1" count="task" from="book" level="any"/>
          </h2>
        </td>
	<td>
	  <h2><xsl:apply-templates select="title" mode="force"/></h2>
	</td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="task">
    <xsl:call-template name="task-head"/>
    <!--
    <xsl:apply-templates select="why-it-works"/>    
    <xsl:apply-templates select="what-to-do"/>
    -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="what-to-do">
    <table width="95%" border="1">
      <tr>
	<center>
	  <h3><td class="pg-what-to-do">What To Do...</td></h3>
	</center>
      </tr>
    </table>
    <ul>
    <xsl:apply-templates select="*[not(self::related-tasks)]"/>
    </ul>
    <xsl:apply-templates select="./related-tasks"/>
  </xsl:template>

  <xsl:template match="step">
  <li>
    <p>
      <b>
	      <xsl:apply-templates select="./title" mode="force"/>
	      <xsl:call-template name="add-id"/>
     </b>
   </p>
   <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="related-tasks">
    <h4>Related Tasks</h4>
    <ul>
    <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="related-tasks/li">
    <li height="2">
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="why-it-works">
    <xsl:apply-templates/>
  </xsl:template>


</xsl:stylesheet>  
