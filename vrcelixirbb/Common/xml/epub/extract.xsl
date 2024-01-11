<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml"
  >
  <xsl:template name="extracts-cover"> 

    <p class="extract-cover">
    <span>Extracted from:</span></p> 
      <h3 class="extract-cover">
        <span>
        <xsl:apply-templates select="/book/bookinfo/booktitle"/>
        </span>
      </h3>
      <h4 class="extract-cover">
        <span><xsl:apply-templates select="/book/bookinfo/booksubtitle"/></span>
      </h4>
        <div class="extract-cover">
        <p>This PDF file contains pages extracted from 
          <span><xsl:value-of select="/book/bookinfo/booktitle"/></span>, 
          published by the Pragmatic Bookshelf. For more
          information or to purchase a paperback or PDF copy, please
          visit <a href="http://www.pragprog.com">http://www.pragprog.com</a>.</p>
        <p>Note: This extract contains some colored text
          (particularly in code listing). This is available only in
          online versions of the books. The printed versions are black
          and white. Pagination might vary between the online and
          printer versions; the content is otherwise
          identical.</p>
        <p> Copyright © 2010 The Pragmatic Programmers,
          LLC.</p>
        <p>All rights reserved.</p>
        <p>No part of this publication may be reproduced, stored
          in a retrieval system, or transmitted, in any form, or by any
          means, electronic, mechanical, photocopying, recording, or
          otherwise, without the prior consent of the
          publisher.</p>
      </div>
  </xsl:template>

  <xsl:template match="extract">
    <xsl:if test="$extracts = 'yes'">
         <xsl:element name="div">
           <xsl:attribute name="class">
             <xsl:choose>
               <xsl:when test="@id">
                 <xsl:value-of select="'start_extract'"/>
               </xsl:when>
               <xsl:when test="@idref">
                 <xsl:value-of select="'end_extract'"/>
               </xsl:when>
             </xsl:choose>
           </xsl:attribute>
           <xsl:if test="@id">
              <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
              </xsl:attribute>
           </xsl:if>
           <xsl:if test="@idref">
              <xsl:attribute name="idref">
                <xsl:value-of select="@idref"/>
              </xsl:attribute>
           </xsl:if>
           <xsl:if test="@title">
              <xsl:value-of select="@title"/>
           </xsl:if>
         </xsl:element>     
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
