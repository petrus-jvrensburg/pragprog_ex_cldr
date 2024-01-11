<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   version="1.0"
>

  <xsl:template match="layout">
  </xsl:template>

  <xsl:template match="booktitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="booksubtitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="booksubtitle">
    <xsl:apply-templates/>
  </xsl:template>

 

  <xsl:template match="epigraph">
    <div class="epigraph">
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


  <xsl:template match="epitext">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="epigraph/name | epigraph/title | epigraph/date">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="part">
    <h1 class="part-title"> 
      <xsl:call-template name="add-id"/>
      <span class="part-number">
	<xsl:text>Part </xsl:text>
        <xsl:number format="1" count="part" from="book" level="any"/>
      </span>
      <br />
      <span class="part-name">
	<xsl:apply-templates select="title" mode="force"/>
      </span>
    </h1>
    <!-- remove select ||.//contribution-->
    <xsl:apply-templates select="not(.//chapter|.//appendix)"/>
    <xsl:call-template name="add-copyright"/>
  </xsl:template>

  <!-- remove match |contribution -->
  <xsl:template match="chapter|appendix">
    <h1 class="chapter-title"> 
      <xsl:call-template name="add-id"/>
      <span class="chapter-number">
	Chapter
	<!-- remove count |contribution -->
        <xsl:number format="1" count="chapter|appendix" 
		    from="book" level="any"/>
      </span>
      <br />
      <span class="chapter-name">
	<xsl:apply-templates select="title" mode="force"/>
      </span>
    </h1>
    <xsl:apply-templates />
    <xsl:if test=".//footnote">
      <div class="footnotes">
	<h4>Footnotes</h4>
	<table cellspacing="3">
          <xsl:for-each select=".//footnote">
	    <xsl:call-template name="output-footnote"/>
          </xsl:for-each>
	</table>
      </div>
    </xsl:if>
    <!--
	<xsl:if test=".//realcite">
	  <div class="bibliography">
	    <h4>Bibliography</h4>
	    <table cellspacing="3">
	      <xsl:for-each select=".//realcite">
		<xsl:call-template name="output-citation"/>
	      </xsl:for-each>
	    </table>
	  </div>
	</xsl:if>
	-->
    <xsl:call-template name="add-copyright"/>
  </xsl:template>

  <xsl:template match="sect1">
    <h2>
      <xsl:call-template name="add-id"/>
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

  <xsl:template match="ldots">
    <xsl:text>&#8230;</xsl:text>
  </xsl:template>

  <xsl:template match="p/missing"/>
  
  <xsl:template name="missing">
    <div class="missing">
      <xsl:text>Missing: </xsl:text>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="missing">
    <xsl:call-template name="missing"/>
  </xsl:template>
  
  <xsl:template match="highlight">
    <div class="highlight">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="p">
    <xsl:for-each select="missing">
      <xsl:call-template name="missing"/>
    </xsl:for-each>
    <p>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="ul">
    <ul>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="dl">
    <dl>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="ol">
    <ol>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xsl:template match="li">
    <li>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="dt">
    <dt>
      <xsl:call-template name="add-id"/>
      <xsl:choose>
	<xsl:when test="@newline = 'yes'">
	  <xsl:attribute name="class">force-newline</xsl:attribute>
	</xsl:when>
      </xsl:choose>
      <xsl:choose>
	<xsl:when test="@bold = 'yes'">
	   <strong><xsl:apply-templates/></strong>
	 </xsl:when>
	 <xsl:otherwise>
	   <xsl:apply-templates/>
	 </xsl:otherwise>
      </xsl:choose>
    </dt>
  </xsl:template>

  <xsl:template match="dd">
    <dd>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </dd>
  </xsl:template>
 <!-- remove match  | stringinfile | tabletitle -->
  <xsl:template match="acronym | b | booksectname | cf | classname | 
     commandname | commandoption | constant | dirname | elide |
     emph | fileextension | filename | initials | keystroke | 
     keyword | parametername | sqlcolumn | sqltable | standin |
     string | underline | 
     variablename | xmlattrval">
    <span>
      <xsl:attribute name="class">
	<xsl:value-of select="local-name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="inlinecode | ic">
    <span class="inlinecode"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="fraction">
    <xsl:if test="./whole">
      <xsl:apply-templates select="top"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="top"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="bottom"/>
  </xsl:template>

  <xsl:template match="whole | top | bottom">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="methodname">
    <span>
      <xsl:attribute name="class">methodname</xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if test="@args and not(@args='')">  <!-- no odea why I have to do this -->
	<xsl:text>(</xsl:text>
	<xsl:value-of select="@args"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="objcmethodname">
    <span>
      <xsl:attribute name="class">methodname</xsl:attribute>
      <xsl:apply-templates/>
      <xsl:value-of select="@args"/>
    </span>
  </xsl:template>
<!-- remove match  | lmn -->
  <xsl:template match="lispmethodname">
    <span>
      <xsl:attribute name="class">methodname</xsl:attribute>
      <xsl:if test="@args"><xsl:text>)</xsl:text></xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="@args">
	<xsl:text> </xsl:text>
	<xsl:value-of select="@args"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="xmlattr">
    <span>
      <xsl:attribute name="class">xmlattr</xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if test="@value">
	<xsl:text>="</xsl:text>
	<xsl:value-of select="@value"/>
	<xsl:text>"</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="firstuse">
    <span class="firstuseinline"><xsl:apply-templates/></span>
<!--    <span class="firstusemargin"><xsl:apply-templates/></span> -->
  </xsl:template>

<!-- remove 
  <xsl:template match="marginnote">
  </xsl:template>-->

 <!-- remove  <xsl:template match="flagmaterial">
    <span>
      <xsl:attribute name="class">
	<xsl:text>flag</xsl:text>
	<xsl:value-of select="@type"/>
      </xsl:attribute>
      <img src="images/WigglyRoad.png" alt="Here be dragons..."/>
    </span>
  </xsl:template>-->

  <!-- ignore indexing -->
  <xsl:template match="i" />

 <!-- remove
   <xsl:template match="unhandled-marginnote">
    <div class="marginnote">
      <xsl:apply-templates/>
    </div>
  </xsl:template>-->


  <xsl:template match="authorq">
    <div class="authorq">
      <div class="the-author-asks">
	The author asks:
      </div>
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ed">
    <span class="ed">
      <xsl:text>Ed: </xsl:text>
      <xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="ce">
    <span class="ce">
      <xsl:text>CE: </xsl:text>
      <xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="author">
    <span class="author">
      <xsl:text>Author: </xsl:text>
      <xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="flag">
    <span class="flag">
      <xsl:apply-templates/></span>
  </xsl:template>


  <xsl:template match="url">
    <a>
      <xsl:attribute name="href">
	<xsl:value-of select="."/>
      </xsl:attribute>
	<xsl:value-of select="."/>
    </a>
  </xsl:template>


  <xsl:template match="xmltag">
    <span class="xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates mode="strip"/>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="xmltagpair">
    <span class="xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&gt;</xsl:text>
    </span>

    <xsl:apply-templates mode="strip"/>

    <span class="xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>


  <!-- ignore margindef's in online version -->
  <!-- remove 
  <xsl:template match="margindef">
  </xsl:template>-->

 <!-- remove  <xsl:template match="programlisting">
    <pre class="programlisting"><xsl:call-template name="add-id"/>
<xsl:apply-templates/></pre>
  </xsl:template>-->

  <xsl:template match="processedcode">
    <table class="processedcode">
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates mode="code"/>
    </table>
  </xsl:template>

  <!-- imagecode is used in the mobiformat -->
  <xsl:template match="imagecode">
    <div>
    <xsl:call-template name="add-id"/>
    <br />
    <img>
      <xsl:attribute name="src">
	<xsl:value-of select="@code_listing"/>
      </xsl:attribute>
      <xsl:attribute name="alt">
	<xsl:value-of select="@code_listing"/>
      </xsl:attribute>
    </img>
    <br />
    </div>
  </xsl:template>


  <xsl:template name="create-callout">
    <xsl:param name="number"/>
    <span class="callout-number">
<!--      <xsl:text disable-output-escaping="yes">&#38;#</xsl:text>
      <xsl:value-of select="$number + 9311"/>
      <xsl:text>;</xsl:text> -->
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$number"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>


  <xsl:template match="codeline"  mode="code">
    <xsl:if test="position() = 1 and ../@livecode">
      <tr class="livecodelozenge">
	<td colspan="2">
	  <xsl:element name="a">
	    <xsl:attribute name="href">
	      <xsl:text>http://media.pragprog.com/</xsl:text>
	      <xsl:value-of select="/book/bookinfo/backsheet/homepageurl" />
	      <xsl:text>/code/</xsl:text>
	      <xsl:value-of select="../@file"/>
	    </xsl:attribute>
	    <xsl:value-of select="../@file"/>
	  </xsl:element>
	</td>
      </tr>
    </xsl:if>
    <tr>
    <td class="codeprefix">
      <xsl:if test="@highlight = 'yes'">
	<span class="codehighlightline">
	  *
	</span>
      </xsl:if>

      <xsl:choose>
	<xsl:when test="@calloutno">
	  <span class="codecalloutnumber">
	    <xsl:call-template name="create-callout">
	      <xsl:with-param name="number" select="@calloutno"/>
	    </xsl:call-template>
	  </span>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:if test="@prefix">
	    <span class="codeprefix">
	      <xsl:choose>
		<xsl:when test="@prefix = 'in'">
		  <xsl:text>=&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="@prefix = 'out'">
		  <xsl:text>&lt;=</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="@prefix"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </span>
	  </xsl:if>
	</xsl:otherwise>
      </xsl:choose>
    </td>
    <td class="codeline"><pre>&#160;<xsl:apply-templates mode="code"/></pre></td>
    </tr>
  </xsl:template>

  <xsl:template match="cokw"  mode="code"><span class="kw"><xsl:apply-templates  mode="code"/></span></xsl:template>

  <xsl:template match="cocomment"  mode="code"><span class="comment"><xsl:apply-templates  mode="code"/></span></xsl:template>

  <xsl:template match="costring"  mode="code">
    <span class="string"><xsl:apply-templates  mode="code"/></span>
  </xsl:template>

 <!-- remove
   <xsl:template match="continuation">
    &#8629;<br />
  </xsl:template> -->

  <xsl:template match="newline">
    <br />
  </xsl:template>

  <xsl:template match="ppextract">
    <div class="extract" ppextract="yes">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="nohyphen">
    <xsl:apply-templates mode="strip"/>
  </xsl:template>

  <xsl:template match="raise">
    <xsl:apply-templates/><sup><xsl:value-of select="@power"/></sup>
  </xsl:template>

  <xsl:template match="lower">
    <xsl:apply-templates/><sub><xsl:value-of select="@power"/></sub>
  </xsl:template>

  <xsl:template match="sidebar">
    <div class="sidebar">
      <xsl:call-template name="add-id"/>
      <div class="sidebar-title">
	<xsl:value-of select="title"/>
      </div>
      <div class="sidebar-content">
	<xsl:apply-templates/>
	<xsl:for-each select=".//footnote | .//footnoteref">
          <blockquote class="footnote">
	    <xsl:apply-templates/>
          </blockquote>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="dialog">
    <dl>
    <xsl:apply-templates />
    </dl>
  </xsl:template>

  <xsl:template match="said-by">
    <dt>
    <xsl:value-of select="@name"/>:
    </dt>
    <dd>
    <xsl:apply-templates />
    </dd>
  </xsl:template>

  <xsl:template match="blockquote">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>

  <xsl:template match="emailblock">
    <pre class="emailblock">
      <xsl:apply-templates/>
    </pre>
  </xsl:template>

  <xsl:template match="story">
    <blockquote class="story">
      <xsl:call-template name="add-id"/>
      <div class="title">
	<xsl:value-of select="./title"/>
      </div>
    <xsl:if test="./person">
      <div class="author">
        by <xsl:value-of select="./person/name"/>
	<xsl:if test="./person/jobtitle">
	  <xsl:text>, </xsl:text>
	  <xsl:value-of select="./person/jobtitle"/>
	</xsl:if>
	<xsl:if test="./person/affiliation">
	  <xsl:text>, </xsl:text>
	  <xsl:value-of select="./person/affiliation"/>
	</xsl:if>
      </div>
    </xsl:if>
    <div class="story-body">
      <xsl:apply-templates/>
    </div>
    </blockquote>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="xxxasks">
    <xsl:param name="label"/>
    <xsl:param name="image"/>
    <div class="xxxsays">
      <xsl:call-template name="add-id"/>
      <div class="heading">
	<div class="persons-picture">
	  <img>
	    <xsl:attribute name="src">
	      <xsl:value-of select="$image"/>
	    </xsl:attribute>
	    <xsl:attribute name="alt">
	      <xsl:value-of select="$label"/>
	    </xsl:attribute>
	  </img>
	</div>
	<div class="label">
	  <xsl:value-of select="$label"/>
	</div>
	<div class="title">
	  <xsl:apply-templates select="./title" mode="force"/>
	</div>
      </div>

      <div class="body">
	<xsl:apply-templates/>
	<xsl:for-each select=".//footnote | .//footnoteref">
          <blockquote class="footnote">
	    <xsl:apply-templates/>
          </blockquote>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="joeasks">
    <xsl:call-template name="xxxasks">
      <xsl:with-param name="label">
	<xsl:text>Joe asks:</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="image">
	<xsl:text>images/joe.png</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="said">
    <xsl:call-template name="xxxasks">
      <xsl:with-param name="label">
	<xsl:value-of select="@by"/>
	<xsl:text> says:</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="image">
	<xsl:text>images/headshot_</xsl:text>
        <xsl:call-template name="name-to-headshot-name"/>
        <xsl:text>.png</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="figure">
     <div class="figure">
   <!--   <table>
	<tr>
	  <td> --> 
	    <xsl:apply-templates select="*[not(self::title)]"/>
    <hr/>     <!-- </td>
	</tr>
	<tr>
	  <td align="center">-->
	    <b>
	      <xsl:call-template name="add-id"/>
              <xsl:text>Figure </xsl:text>
              <xsl:number format="1" count="figure" 
			  from="chapter|appendix" level="any"/>
              <xsl:text>. </xsl:text>
	      <xsl:apply-templates select="title" mode="force"/>
	   </b>
	 <!--  </td>
	</tr>
      </table> -->
    </div>
    <xsl:call-template name="post-figure-hook"/>
  </xsl:template>

  <xsl:template name="get-image-name">
    <xsl:param name="file">
      <xsl:value-of select="@fileref"/>
    </xsl:param>

    <xsl:variable name="before">
      <xsl:choose>
	<xsl:when test="contains($file, '.eps')">
	  <xsl:value-of select="substring-before($file, '.eps')"/>
	</xsl:when>
	<xsl:when test="contains($file, '.EPS')">
	  <xsl:value-of select="substring-before($file, '.EPS')"/>
	</xsl:when>
	<xsl:when test="contains($file, '.ps')">
	  <xsl:value-of select="substring-before($file, '.ps')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>bad-image-name:</xsl:text>
	  <xsl:value-of select="$file"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="after">
      <xsl:choose>
	<xsl:when test="contains($before, 'WigglyRoad')">
	  <xsl:text>WigglyRoad</xsl:text>
	</xsl:when>
	<xsl:when test="contains($before, 'PPStuff/util/images/joe')">
	  <xsl:text>joe</xsl:text>
	</xsl:when>
	<xsl:when test="contains($before, 'images/eps/')">
	  <xsl:value-of select="substring-after($before, 'images/eps/')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>Unknown image location:<xsl:value-of select="$before"/></xsl:message>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$after"/>
    <xsl:text>.png</xsl:text>
  </xsl:template>

  <xsl:template match="imagedata">
    <div class="image"> <!-- -->
      <img>
	<xsl:attribute name="src">
	  <xsl:text>images/</xsl:text>
	  <xsl:call-template name="get-image-name"/>
	</xsl:attribute>
	<xsl:attribute name="alt">
	  <xsl:call-template name="get-image-name"/>
	</xsl:attribute>
      </img>
   </div>  <!-- -->
  </xsl:template>


  <!-- resources section -->
  <xsl:template match="webresources">
    <div class="webresources">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="webresource">
    <div class="title">
      <xsl:apply-templates select="resname"/>
    </div>
    <div class="url">
      <xsl:apply-templates select="resurl"/>
    </div>
    <div class="desc">
      <xsl:apply-templates select="resdesc"/>
    </div>
  </xsl:template>

  <xsl:template match="resurl">
    <a>
      <xsl:attribute name="href">
	<xsl:apply-templates/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="resname">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="resdesc">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="bibliography">
    <div id="bibliography">
      <table cellspacing="3">
        <xsl:for-each select="//realcite">
          <xsl:call-template name="output-citation"/>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

  <!-- cites -->
  <xsl:template match="bookname">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="articlename">
    <xsl:text>“</xsl:text><xsl:apply-templates/><xsl:text>”</xsl:text>
  </xsl:template>

  <xsl:template match="realcite">
    <!-- Can't really do this, because cites are many to one...
    <a>
      <xsl:attribute name="id">
	<xsl:text>CITEPTR-</xsl:text>
	<xsl:number format="1" count="realcite" 
		    level="any"/>
      </xsl:attribute>
    </a>
    -->
    <a>
      <xsl:attribute name="href">
	<xsl:choose>
	  <xsl:when test="//bibliography">
	    <xsl:for-each select="//bibliography">
	      <xsl:call-template name="filename"/>
	    </xsl:for-each>
	    <xsl:text>#CITE-</xsl:text>
	    <!-- remove count |preface -->
	    <xsl:number format="1" count="realcite" 
			from="chapter|appendix" level="any"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>Can't find the bibliography</xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="./key"/>
      <xsl:text>]</xsl:text>
    </a>
  </xsl:template>

  <!-- footnotes -->
  <xsl:template match="footnote">
    <xsl:variable name="fn-count">
      <!-- remove count |preface -->
      <xsl:number format="1" count="footnote" 
		  from="chapter|appendix" level="any"/>
    </xsl:variable>
    <a>
      <xsl:attribute name="id">
	<xsl:text>FNPTR-</xsl:text>
	<xsl:value-of select="$fn-count"/>
      </xsl:attribute>
      <xsl:attribute name="href">
	<xsl:text>#FOOTNOTE-</xsl:text>
	<xsl:value-of select="$fn-count"/>
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$fn-count"/>
      <xsl:text>]</xsl:text>
    </a>
  </xsl:template>

  <xsl:template name="output-footnote">
    <xsl:variable name="fn-count">
      <!-- remove count |preface -->
      <xsl:number format="1" count="footnote" 
		  from="chapter|appendix" level="any"/>
    </xsl:variable>
    <tr valign="top">
      <td>
      <a>
	<xsl:attribute name="id">
	  <xsl:text>FOOTNOTE-</xsl:text>
	  <xsl:value-of select="$fn-count"/>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:text>#FNPTR-</xsl:text>
	  <xsl:value-of select="$fn-count"/>
	</xsl:attribute>
	<xsl:text>[</xsl:text>
	<xsl:value-of select="$fn-count"/>
	<xsl:text>]</xsl:text>
      </a>
    </td>
    <td>
      <xsl:apply-templates/>
    </td>
    </tr>
  </xsl:template>

  <xsl:template name="output-citation">
    <tr valign="top">
      <td>
      <a>
	<xsl:attribute name="id">
	  <xsl:text>CITE-</xsl:text>
	  <xsl:number format="1" count="realcite" 
		      level="any"/>
	</xsl:attribute>
      </a>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="./key"/>
      <xsl:text>]</xsl:text>
    </td>
    <td>
      <xsl:apply-templates select="./title" mode="cite"/>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="./author" mode="cite"/>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="./year" mode="cite"/>
      <xsl:text>. </xsl:text>
<!--
      <a>
	<xsl:attribute name="href">
	  <xsl:text>#CITEPTR-</xsl:text>
	  <xsl:number format="1" count="realcite" 
		      from="chapter|appendix|preface" level="any"/>
	</xsl:attribute>
	<xsl:text>[Back]</xsl:text>
      </a>
-->
    </td>
    </tr>
  </xsl:template>

  <xsl:template match="title" mode="cite">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="author" mode="cite">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="year" mode="cite">
    <xsl:apply-templates/>
  </xsl:template>

<!--
  <xsl:template match="footnote/para[not(preceding-sibling::*)]">
    <xsl:message>Wibble!!</xsl:message>
    <p>
      <a>
	<xsl:attribute name="href">
          <xsl:text>#FNPTR-</xsl:text>
          <xsl:number format="1" count="footnote" 
		      from="chapter|appendix|preface" level="any"/>
	</xsl:attribute>
	<xsl:text>[</xsl:text>
	<xsl:number format="1" count="footnote" 
		    from="chapter|appendix|preface" level="any"/>
	<xsl:text>]</xsl:text>
      </a>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="footnote/para[preceding-sibling::*]">
    <xsl:message>Wobble!!</xsl:message>
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
-->


<xsl:template match="simpletable">
  <table width="100%" class="simpletable">
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="row">
  <tr>
    <xsl:apply-templates/>
  </tr>
</xsl:template>

<xsl:template match="col">
  <td>
    <xsl:apply-templates/>
  </td>
</xsl:template>

<xsl:template match="tablerule">
  <tr>
    <td>
      <hr/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="prefacesignoff">
  <div class="prefacesignoff">
    <xsl:choose>
      <xsl:when test="@email">
	<a>
	  <xsl:attribute name="href">
	    <xsl:text>mailto:</xsl:text>
	    <xsl:value-of select="@email"/>
	  </xsl:attribute>
	  <xsl:value-of select="@name"/>
	</a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
    <div class="prefacesignoffdate">
      <xsl:value-of select="@date"/>
    </div>
  </div>
</xsl:template>

<!-- cross references -->
  <xsl:template match="*" mode="xref.name">
    <xsl:text>!!CAN'T XREF</xsl:text>
    <xsl:value-of select="local-name(.)" />
  </xsl:template>


  <!-- most xrefs don't have a title -->
  <xsl:template match="*" mode="xref.title" />


  <xsl:template match="chapter" mode="xref.name">
    <xsl:text>Chapter </xsl:text>
  </xsl:template>

  <xsl:template match="chapter" mode="xref.title">
    <xsl:text>, \booksectname{</xsl:text>
    <xsl:apply-templates select=".//title" mode="force"/>
    <xsl:text>}, </xsl:text>
  </xsl:template>


  <xsl:template match="sect1|sect2|sect3|sect4" mode="xref.name">
    <xsl:text>in </xsl:text>
  </xsl:template>

  <xsl:template match="sect1|sect2|sect3|sect4" mode="xref.title">
    <xsl:text> \booksectname{</xsl:text>
    <xsl:apply-templates select=".//title" mode="force"/>
    <xsl:text>}, </xsl:text>
  </xsl:template>

  <xsl:template match="figure" mode="xref.name">
    <xsl:text>Figure </xsl:text>
  </xsl:template>

  <xsl:template match="sidebar" mode="xref.name">
    <xsl:text>Sidebar </xsl:text>
  </xsl:template>

  <xsl:template match="joeasks" mode="xref.name">
    <xsl:text>Joe asks </xsl:text>
  </xsl:template>



<xsl:template name="get.xref.name">
  <xsl:variable name="target" select="id(@linkend)[1]"/>
  <xsl:apply-templates select="$target" mode="xref.name"/>
  <xsl:text>\ref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates select="$target" mode="xref.title"/>
</xsl:template>

<xsl:template match="xxxpref">
  <xsl:call-template name="get.xref.name"/>
  <xsl:text>\vpageref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="pref | xref" name="pref">
  <xsl:variable name="linkend">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="//*[@id=$linkend]">
      <xsl:for-each select="//*[@id=$linkend]">
        <xsl:call-template name="do-xref">
	  <xsl:with-param name="id">
	    <xsl:value-of select="$linkend"/>
	</xsl:with-param>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <span class="bad-xref">
        <xsl:text>[XREF: </xsl:text>
        <xsl:value-of select="@linkend"/>
        <xsl:text>]</xsl:text>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="pageref" name="pageref">
  <xsl:variable name="linkend">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="//*[@id=$linkend]">
      <xsl:for-each select="//*[@id=$linkend]">
        <xsl:call-template name="do-pageref">
	  <xsl:with-param name="id">
	    <xsl:value-of select="$linkend"/>
	</xsl:with-param>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <span class="bad-xref">
        <xsl:text>[XREF: </xsl:text>
        <xsl:value-of select="@linkend"/>
        <xsl:text>]</xsl:text>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cref">
  <xsl:variable name="linkend">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="//*[@id=$linkend]">
      <xsl:for-each select="//*[@id=$linkend]">
	<xsl:value-of select="@lineno" />
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <span class="bad-xref">
        <xsl:text>[XREF: </xsl:text>
        <xsl:value-of select="@linkend"/>
        <xsl:text>]</xsl:text>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="coref">
  <xsl:variable name="linkend">
    <xsl:value-of select="@linkend"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="//*[@id=$linkend]">
      <xsl:for-each select="//*[@id=$linkend]">
	<span class="codecalloutinline">
	  <xsl:call-template name="create-callout">
	    <xsl:with-param name="number" select="@calloutno" />
	  </xsl:call-template>
	</span>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <font color="red">
        <xsl:text>[XREF: </xsl:text>
        <xsl:value-of select="@linkend"/>
        <xsl:text>]</xsl:text>
      </font>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="filename">
  <xsl:text>chap-</xsl:text>
  <!-- remove count |contribution -->
  <xsl:number format="001" count="part|chapter|appendix" 
	      from="book" level="any"/>
  <xsl:text>.xhtml</xsl:text>
</xsl:template>

<xsl:template name="add-xref-title">
  <xsl:text>, </xsl:text>
  <span class="xref-title">
    <xsl:apply-templates select="title"/>
  </span>
</xsl:template>

<xsl:template name="do-xref">
  <xsl:param name="id"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="filename"/> 
      <xsl:text>#</xsl:text>
      <xsl:call-template name="sanitize-id">
	<xsl:with-param name="the-id"  select="$id"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:choose>

      <xsl:when test="self::appendix">
	<xsl:text>Appendix </xsl:text>
        <xsl:number format="A" value="count(preceding::appendix) +1"/>
	<xsl:call-template name="add-xref-title"/>
      </xsl:when>

      <xsl:when test="self::chapter">
	<xsl:text>Chapter </xsl:text>
        <xsl:number format="1" value="count(preceding::chapter) +1"/>
	<xsl:call-template name="add-xref-title"/>
      </xsl:when>

      <xsl:when test="self::part">
	<xsl:text>Part </xsl:text>
        <xsl:number format="1" value="count(preceding::part) +1"/>
	<xsl:call-template name="add-xref-title"/>
      </xsl:when>

   <!-- remove
     <xsl:when test="self::preface">
        <xsl:text>the Preface</xsl:text>
      </xsl:when>-->

      <xsl:when test="self::sect1 or
                      self::sect2 or
                      self::sect3 or
                      self::sect4 or
                      self::refsect1 or
                      self::refsect2">
        <xsl:text>Section </xsl:text>
	<xsl:call-template name="add-xref-title"/>
      </xsl:when>

        <xsl:when test="self::figure">
        <xsl:text>Figure </xsl:text>
          <xsl:number format="1" count="figure" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::example">
        <xsl:text>Example </xsl:text>
          <xsl:number format="1" count="example" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::table">
        <xsl:text>Table </xsl:text>
          <xsl:number format="1" count="table" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::refentry">
          <xsl:number format="1" count="refentry" 
              from="chapter|appendix" level="any"/>
        </xsl:when>

        <xsl:when test="self::sidebar">
          <xsl:text>the sidebar </xsl:text>
	  <span class="xref-title">
            <xsl:value-of select="title"/>
	  </span>
        </xsl:when>

        <xsl:when test="self::joeasks">
          <xsl:text>in the Joe Asks note </xsl:text>
	  <span class="xref-title">
            <xsl:value-of select="title"/>
	  </span>
        </xsl:when>

        <xsl:otherwise>
          <xsl:text>{XREF - UNDEFINED PATTERN}</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template name="do-pageref">
  <xsl:param name="id"/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="filename"/> 
      <xsl:text>#</xsl:text>
      <xsl:call-template name="sanitize-id">
	<xsl:with-param name="the-id"  select="$id"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:text>(here…)</xsl:text>
  </a>
</xsl:template>

 <xsl:template match="cite">
   <b>
     <xsl:text>cite: </xsl:text>
     <xsl:value-of select="@ref"/>
   </b>
 </xsl:template>


  <!--- ignore index online -->
  <xsl:template match="indexterm" />

  <!--- ignore toctitle online -->
  <xsl:template match="toctitle" />

  
  <!-- normally ignore all titles - 
       they should be handled by their parents directly -->
  <xsl:template match="title"/>
  <xsl:template match="person"/>

  <!-- but sometimes we need to force one out -->
  <xsl:template match="title" mode="force">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- overall stuff we don't need -->
  <xsl:template match="backpage"/>

  <xsl:template name="add-copyright">
    <div class="copyright">
      <xsl:text>Copyright &#169; </xsl:text>
      <xsl:value-of select="$year"/>
      <xsl:text>, The Pragmatic Bookshelf.</xsl:text>
    </div>
  </xsl:template>


</xsl:stylesheet>
