<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>
   
  <xsl:template match="table[@dlist='yes']">
    <xsl:if test="title">
      <hr/>
      <div class="figurecaption">
        <xsl:call-template name="add-id"/>
        <xsl:text>Table </xsl:text>
        <xsl:number format="1" count="table[child::title]" from="book" level="any"/>
        <xsl:text>. </xsl:text>
        <xsl:apply-templates select="title" mode="force"/>
      </div>
      <xsl:apply-templates select="subtitle"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(descendant::row[1]/col) = 2">
        <dl>
          <xsl:apply-templates select="thead | row" mode="dlist"/>
        </dl>
      </xsl:when>
      <xsl:otherwise> 
        <xsl:call-template name="table"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="title">
      <hr/>
    </xsl:if>
  </xsl:template> 
  
  <xsl:template match="subtitle">
    <div class="figuresubcaption">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="thead" mode="dlist">
        <dt>
          <b>
          <xsl:apply-templates select="col[1]/node()"/>
          </b> 
        </dt>

        <dd> 
          <b>
          <xsl:apply-templates select="col[2]/node()" />
          </b>
        </dd>
  </xsl:template>
  
  <xsl:template match="row" mode="dlist">
    <xsl:apply-templates select="col" mode="dlist"/>
  </xsl:template>

  <xsl:template match="col" mode="dlist">
    <xsl:choose>
      <xsl:when test="not(preceding-sibling::col)">
        <dt> 
          <xsl:apply-templates mode="dlist" />
        </dt>
      </xsl:when>
      <xsl:otherwise>
        <dd>
          <xsl:apply-templates/>
        </dd>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="dlist">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Added processing to bypass the outer table for table-in-table markup. 
    Note: tables with mixed table/other content will be completely unwrapped! -->
  <xsl:template match="table[descendant::table]">
    <xsl:for-each select="row/col">
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="table" name="table">
     <xsl:if test="title">
       <hr/>
       <div class="figurecaption">
         <xsl:text>Table </xsl:text>
         <xsl:number format="1" count="table[child::title]" from="book" level="any"/>
         <xsl:text>. </xsl:text>
         <xsl:apply-templates select="title" mode="force"/>
       </div>
      <xsl:apply-templates select="subtitle"/>
     </xsl:if>
     <table>
      <xsl:call-template name="add-id"/>
      <xsl:attribute name="class">
	      <xsl:text>simpletable </xsl:text>
        <xsl:choose>
          <xsl:when test="@style">
            <xsl:value-of select="@style"/>
          </xsl:when>
          <xsl:when test="//book/options/tablestyle/@style">
           <xsl:value-of select="//book/options/tablestyle/@style"/>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>

      <xsl:apply-templates select="colspec"/>
      <xsl:apply-templates select="thead"/>
      <tbody>
	<xsl:apply-templates select="./row"/>
      </tbody>
    </table>
     <xsl:if test="title">
          <hr/>
       </xsl:if>
  </xsl:template>
  
  <xsl:template match="colspec">
 <!--    <col>
     <xsl:if test="@font-weight or @font-size or @font-family">
	<xsl:attribute name="style">
	  <xsl:if test="@font-weight">
	      <xsl:text>font-weight:</xsl:text><xsl:value-of select="@font-weight"/><xsl:text>;</xsl:text>
	  </xsl:if>
	  <xsl:if test="@font-size">
	      <xsl:text>font-size:</xsl:text><xsl:value-of select="@font-size"/><xsl:text>;</xsl:text>
	  </xsl:if>
	  <xsl:if test="@font-family">
	      <xsl:text>font-family:</xsl:text><xsl:value-of select="@font-family"/><xsl:text>;</xsl:text>
	  </xsl:if>	
	</xsl:attribute>
      </xsl:if>

      <xsl:if test="@width">
	<xsl:attribute name="width">
	  <xsl:value-of select="@width"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:if test="@align">
	<xsl:attribute name="align">
	  <xsl:value-of select="@align"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:if test="@valign">
	<xsl:attribute name="valign">
	  <xsl:value-of select="@valign"/>
	</xsl:attribute>
      </xsl:if>
    </col>--> 
  </xsl:template>

  <xsl:template match="thead">
    <thead>
      <tr>
	<xsl:apply-templates/>
      </tr>
    </thead>
  </xsl:template>

  <xsl:template match="thead/col">
    <th>
       <xsl:if test="string-length(@span) &gt; 0">
        <xsl:attribute name="colspan">
          <xsl:value-of select="@span"/>
        </xsl:attribute>
      </xsl:if>
       <xsl:choose>
          <xsl:when test="parent::thead/parent::table[@style]">       
            <xsl:attribute name="class">
              <xsl:value-of select="parent::thead/parent::table/@style"/>
            </xsl:attribute>
         </xsl:when>
          <xsl:when test="//book/options/tablestyle/@style">
            <xsl:attribute name="class">
              <xsl:value-of select="//book/options/tablestyle/@style"/>
          </xsl:attribute>
        </xsl:when>
        </xsl:choose>
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template match="row">
    <tr>
      <xsl:attribute name="class">
	<xsl:text>tr </xsl:text>
	<xsl:if test="parent::table[@decoration='zebra'] and (((count(preceding-sibling::row) + 1) mod 2) = 1)">
	  <xsl:text>zebra </xsl:text>
	</xsl:if>
        <xsl:if test="(parent::table[@style='hlines'] or //book/options/tablestyle/@style = 'hlines') and ((count(preceding-sibling::row) + 1) &gt; 1)">
	  <xsl:text>line-on-top</xsl:text>
	</xsl:if>
      </xsl:attribute>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="col">

    <xsl:variable name="align">
      <xsl:call-template name="get-col-attr"><xsl:with-param name="attr">align</xsl:with-param></xsl:call-template>
    </xsl:variable>

    <xsl:variable name="valign">
      <xsl:call-template name="get-col-attr"><xsl:with-param name="attr">valign</xsl:with-param></xsl:call-template>
    </xsl:variable>

    <xsl:variable name="font-weight">
      <xsl:call-template name="get-col-attr"><xsl:with-param name="attr">font-weight</xsl:with-param></xsl:call-template>
    </xsl:variable>

    <xsl:variable name="font-family">
      <xsl:call-template name="get-col-attr"><xsl:with-param name="attr">font-family</xsl:with-param></xsl:call-template>
    </xsl:variable>

    <xsl:variable name="font-size">
      <xsl:call-template name="get-col-attr"><xsl:with-param name="attr">font-size</xsl:with-param></xsl:call-template>
    </xsl:variable>

    <xsl:variable name="width">
      <xsl:call-template name="get-col-attr"><xsl:with-param name="attr">width</xsl:with-param></xsl:call-template>
    </xsl:variable>

    <td>
      <xsl:if test="@span">
	<xsl:attribute name="colspan"><xsl:value-of select="@span"/></xsl:attribute>
      </xsl:if>
      
      <xsl:attribute name="style">
	<xsl:if test="string-length($valign) &gt; 0">
	  <xsl:text>valign: </xsl:text><xsl:value-of select="$valign"/><xsl:text>; </xsl:text>
	</xsl:if>
	
	<xsl:if test="$font-weight = 'bold'">
	  <xsl:text>font-weight: bold; </xsl:text>
	</xsl:if>
	
	<xsl:if test="$font-family = 'sans'">
	  <xsl:text>font-family: DroidSans;</xsl:text>
	</xsl:if>
	
	<xsl:if test="$font-family = 'mono'">
	  <xsl:text>font-family: DroidSansMono; </xsl:text>
	</xsl:if>
	
	<xsl:if test="string-length($font-size) &gt; 0">
	  <xsl:text>font-size: </xsl:text><xsl:value-of select="$font-size"/><xsl:text>; </xsl:text>
	</xsl:if>

	<xsl:if test="string-length($width) &gt; 0">
	  <xsl:text>width: </xsl:text><xsl:value-of select="$width"/><xsl:text>; </xsl:text>
	</xsl:if>

      </xsl:attribute>

      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="col/p">
    <p>
      <xsl:if test="not(following-sibling::*)">
	<xsl:attribute name="class">last-para-in-cell</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="add-id"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>             

  <xsl:template name="get-col-attr">
    <xsl:param name="attr"/>
    <xsl:variable name="col"><xsl:number count="col" from="row"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="@*[name() = $attr]">
	<xsl:value-of select="@*[name() = $attr]"/>
      </xsl:when>
      <xsl:when test="../../colspec[@col = $col]">
	<xsl:for-each select="../../colspec[@col = $col]">
	  <xsl:value-of select="@*[name() = $attr]"/>
	</xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>



