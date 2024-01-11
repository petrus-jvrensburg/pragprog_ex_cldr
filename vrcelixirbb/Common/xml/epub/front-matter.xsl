<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:pp="http://pragprog.com"
    version="2.0">


  <xsl:template match="frontmatter|mainmatter">
    <xsl:apply-templates/>
  </xsl:template>



  <xsl:template match="authors" mode="titlepage">
    <xsl:text>by </xsl:text>
    <xsl:for-each select="./person">
      <xsl:apply-templates select="./name" mode="titlepage"/>
      <xsl:if test="following-sibling::person">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="withauthors">
    <div class="authors">with</div>
    <xsl:for-each select="./person">
      <xsl:apply-templates select="./name" mode="titlepage"/>
      <xsl:if test="following-sibling::person">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="name" mode="titlepage">
    <xsl:apply-templates mode="force"/>
  </xsl:template>

  <xsl:template match="person" mode="titlepage"> </xsl:template>

  <xsl:template match="authors" mode="opf">
    <xsl:element xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf"
                 name="dc:creator" opf:role="auth">
      <xsl:apply-templates select="person/name"/>
    </xsl:element>
  </xsl:template>

  <!--  <xsl:template match="authors" mode="opf"><xsl:apply-templates mode="opf"/></xsl:template> -->

  <xsl:template match="person" mode="opf">
    <xsl:apply-templates mode="force"/>
  </xsl:template>

  <xsl:template match="name" mode="force">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="affiliation"/>
  <xsl:template match="affiliation" mode="force"/>

  <xsl:template match="jobtitle" mode="force"/>
  <xsl:template match="jobtitle"/>

  <xsl:template match="copyright">
    <xsl:text>Copyright &#169; </xsl:text>
    <xsl:apply-templates select="copyrightdate"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="copyrightholder"/>
  </xsl:template>

  <xsl:template match="copyrightholder">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="copyrightdate">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="isbn13">
    <xsl:apply-templates/>
  </xsl:template>


  <!--
      <xsl:template match="part|chapter|appendix|summary|contribution" mode="ncx">
      <xsl:variable name="play-order">
      <xsl:number count="part|chapter|appendix|summary|contribution"
      from="book" level="any"/>
      </xsl:variable>
      <xsl:variable name="count">
      <xsl:number format="001" value="$play-order"/>
      </xsl:variable>
      <xsl:variable name="filename">
      <xsl:text>chap-</xsl:text>
      <xsl:value-of select="$count"/>
      </xsl:variable>
      <xsl:element name="navPoint">
      <xsl:attribute name="playOrder">
      <xsl:value-of select="$play-order"/>
      </xsl:attribute>
      <xsl:attribute name="id">
      <xsl:text>toc-</xsl:text>
      <xsl:value-of select="$filename"/>
      </xsl:attribute>
      <navLabel>
      <text>
      <xsl:value-of select="./title" />  we don't want to interpret tags
      </text>
      </navLabel>
      <content>
      <xsl:attribute name="src">
      <xsl:value-of select="$filename"/>
      <xsl:text>.xhtml</xsl:text>
      </xsl:attribute>
      </content>
      <xsl:apply-templates mode="ncx"/>
      </xsl:element>
      </xsl:template>
  -->
  <!-- remove match |contribution -->
  <xsl:template match="part|chapter|appendix|task" mode="spine">
    <xsl:variable name="filename">
      <xsl:text>chap-</xsl:text>
      <!-- remove count |contribution -->
      <xsl:number format="001" count="part|chapter|appendix|task" from="book" level="any"/>
    </xsl:variable>
    <itemref>
      <xsl:attribute name="idref">
        <xsl:value-of select="$filename"/>
      </xsl:attribute>
    </itemref>
  </xsl:template>



  <xsl:template match="bookinfo" mode="toc">
    <h1 class="titlepage tp-title">
      <xsl:if test="$extracts = 'yes'">
        <span class="tp-extracted-from">Extracted from</span>
        <br/>
      </xsl:if>
      <xsl:apply-templates select="booktitle" mode="plain-text"/>
    </h1>
    <xsl:text>&#10;</xsl:text>
    <h3 class="titlepage tp-subtitle">
      <xsl:apply-templates select="booksubtitle"/>
    </h3>
    <xsl:text>&#10;</xsl:text>
    <h3 class="titlepage tp-authors">
      <xsl:apply-templates select="authors" mode="titlepage"/>
    </h3>
    <xsl:text>&#10;</xsl:text>
    <div class="titlepage tp-docinfo">
      <xsl:apply-templates select="printing"/>
    </div>

    <xsl:if test="$extracts = 'yes'">
      <div class="tp-extract-explanation">
        <p> This is an extract from <xsl:value-of select="/book/bookinfo/booktitle"/>, published by the
        Pragmatic Bookshelf. For more information or to purchase a paperback or eBook, please visit <a>
        <xsl:attribute name="href"> <xsl:text>https://www.pragprog.com/titles/</xsl:text> <xsl:value-of
        select="//bookinfo/@code"/> </xsl:attribute> <xsl:text>https://www.pragprog.com/titles/</xsl:text>
        <xsl:value-of select="//bookinfo/@code"/> <xsl:text>.</xsl:text> </a> </p>
        <p> Note: This extract contains some colored text (for example in code listings). This is only
        available if your device supports color. The printed versions are black and white. </p>
      </div>
    </xsl:if>

    <section class="pp-chunk tp-copyright">
      <p>
        <xsl:text>Copyright © </xsl:text>
        <xsl:apply-templates select="/book/bookinfo/copyright/copyrightdate"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="/book/bookinfo/copyright/copyrightholder"/>
        <xsl:text>.
        This book is licensed to
        the individual who purchased it. We don't copy-protect it
        because that would limit your ability to use it for your
        own purposes. Please don't break this trust—you can use
        this across all of your devices but please do not share this copy
        with other members of your team, with friends, or via
        file sharing services.  Thanks.
        </xsl:text>
      </p>

      <xsl:call-template name="copyright.text"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="pp:extra-rights"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="publisher-defaults"/>
      <xsl:apply-templates select="/book/bookinfo/production-info"/>
    </section>
  </xsl:template>



  <xsl:template match="praisepage" mode="toc"/>
  <xsl:template match="praisepage" mode="spine"/>

  <!--   <xsl:template match="printing">
       <xsl:text>Version: </xsl:text>
       <xsl:apply-templates select="printingnumber"/>
       <xsl:text> (</xsl:text>
       <xsl:apply-templates select="printingdate"/>
       <xsl:text>)</xsl:text>
     </xsl:template>

     <xsl:template match="printingnumber | printingdate">
       <xsl:apply-templates />
       </xsl:template> -->


       <xsl:template match="imagedata" mode="manifest-image-names">
         <xsl:element name="item">
           <xsl:attribute name="id">
             <xsl:text>img</xsl:text>
             <xsl:number format="1" count="imagedata" from="/" level="any"/>
           </xsl:attribute>
           <xsl:attribute name="href">
             <xsl:text>images/</xsl:text>
             <xsl:call-template name="get-image-name"/>
           </xsl:attribute>
           <xsl:attribute name="media-type">
             <xsl:text>image/jpeg</xsl:text>
           </xsl:attribute>
         </xsl:element>
       </xsl:template>

       <xsl:template name="add-copyright">
         <div class="copyright">
           <xsl:text>Copyright &#169; </xsl:text>
           <xsl:value-of select="$year"/>
           <xsl:text>, The Pragmatic Bookshelf.</xsl:text>
         </div>
       </xsl:template>

       <xsl:template name="pp:extra-rights"/>
       <!-- overridden in book -->
       <xsl:template name="country-of-manufacture">
         <!-- overridden in book -->
         <xsl:text>the United States of America</xsl:text>
       </xsl:template>

       <xsl:template name="paper-content">
         <!-- overridden in book -->
         <xsl:text>The paper verion of this book is printed on acid-free paper.</xsl:text>
       </xsl:template>

       <xsl:template name="copyright.text">
         <p>
             Many of the designations used by manufacturers and
             sellers to distinguish their products are claimed as
             trademarks. Where those designations appear in this book,
             and The Pragmatic Programmers, LLC was aware of a
             trademark claim, the designations have been printed in
             initial capital letters or in all capitals. The Pragmatic
             Starter Kit, The Pragmatic Programmer, Pragmatic
             Programming, Pragmatic Bookshelf and the linking <i>g</i>
             device are trademarks of The Pragmatic Programmers,
             LLC.
         </p>
         <p>
           Every precaution was taken in the preparation of this book.
           However, the publisher assumes no responsibility for errors
           or omissions, or for damages that may result from the use
           of information (including program listings) contained
           herein.
         </p>
       </xsl:template>

       <xsl:template name="publisher-defaults">
         <section class="about-pb">
         <h2 class="pp-no-chunk">About the Pragmatic Bookshelf</h2>

         <p>
           The Pragmatic Bookshelf is an agile publishing company.
           We’re here because we want to improve the lives of developers.
           We do this by creating timely, practical titles, written by programmers for programmers.
         </p>

         <p>
           Our Pragmatic courses, workshops, and other products can
           help you and your team create better software and have more
           fun. For more information, as well as the latest Pragmatic
           titles, please visit us at <a
           href="http://pragprog.com">http://pragprog.com</a>.
         </p>

         <p>
           Our ebooks do not contain any Digital Restrictions
           Management, and have always been DRM-free. We pioneered the
           beta book concept, where you can purchase and read a book
           while it’s still being written, and provide feedback to the
           author to help make a better book for everyone. Free
           resources for all purchasers include source code downloads
           (if applicable), errata and discussion forums, all
           available on the book's home page at pragprog.com. We’re
           here to make your life easier.
         </p>

         <h3>New Book Announcements</h3>
         <p>
           Want to keep up on our latest titles and announcements, and
           occasional special offers? Just create an account on
           <a href="https://pragprog.com">pragprog.com</a> (an email address and a password is all it takes)
           and select the checkbox to receive newsletters. You can
           also follow us on twitter as @pragprog.
         </p>

         <h3>About Ebook Formats</h3>

         <p>
           <xsl:text>
             If you buy directly from
           </xsl:text>
           <a href="https://pragprog.com">pragprog.com</a>
           <xsl:text>, you get
           ebooks in all available formats for one price. You can
           synch your ebooks amongst all your devices (including
           iPhone/iPad, Android, laptops, etc.) via Dropbox.
           You get free updates for the life of the edition. And, of
           course, you can always come back and re-download your books
           when needed. Ebooks bought from the Amazon Kindle store are
           subject to Amazon's polices. Limitations in Amazon's file
           format may cause ebooks to display differently on different
           devices. For more information, please see our FAQ at
           </xsl:text>
           <a href="https://pragprog.com/support/#about-ebooks">pragprog.com/#about-ebooks</a>
           <xsl:text>. To learn
           more about this book and access the free resources, go to
           </xsl:text>

           <a>
             <xsl:attribute name="href">
               <xsl:text>https://pragprog.com/book/</xsl:text>
               <xsl:value-of select="$bookcode"/>
             </xsl:attribute>
             <xsl:text>https://pragprog.com/book/</xsl:text>
             <xsl:value-of select="$bookcode"/>
           </a>
           <xsl:text>, the book's homepage.</xsl:text>
         </p>

         <p>
           Thanks for your continued support,
         </p>

         <p>
           The Pragmatic Bookshelf           
         </p>
         </section>
       </xsl:template>

       <xsl:template match="production-info">
         <section class="production-info">
           <p>
             <xsl:text>The team that produced this book includes: </xsl:text>
             <xsl:apply-templates/>
           </p>
           <p>
             For customer support, please contact
             <a href="mailto:support@pragprog.com">support@pragprog.com</a>.
           </p>
           <p>
             For international rights, please contact
             <a href="mailto:rights@pragprog.com">rights@pragprog.com</a>.
           </p>
         </section>
       </xsl:template>

       <xsl:template match="series-editor">
         <xsl:if test="string-length(.) &gt; 0">
           <span class="production">
             <xsl:text>Series editor: </xsl:text>
             <xsl:apply-templates/>
           </span>
         </xsl:if>
       </xsl:template>
       <xsl:template match="ceo | coo | founders | editor | indexer | copyeditor | typesetter | producer | support | publisher | vpoperations | executiveeditor | managingeditor | supervisingeditor">
         <xsl:if test="string-length(.) &gt; 0">
           <span class="production">
             <xsl:apply-templates/>
             <xsl:text> (</xsl:text>
             <xsl:apply-templates select="." mode="job-role"/>
             <xsl:text>)</xsl:text>
           </span>
         </xsl:if>
       </xsl:template>

      <xsl:template match="ceo"            mode="job-role">CEO</xsl:template>
      <xsl:template match="coo"            mode="job-role">COO</xsl:template>
      <xsl:template match="managingeditor"     mode="job-role">Managing Editor</xsl:template>
      <xsl:template match="supervisingeditor"  mode="job-role">Supervising Editor</xsl:template>
      <xsl:template match="editor"             mode="job-role">Development Editor</xsl:template>
      <xsl:template match="indexer"            mode="job-role">Indexing</xsl:template>
      <xsl:template match="copyeditor"         mode="job-role">Copy Editor</xsl:template>
      <xsl:template match="typesetter"         mode="job-role">Layout</xsl:template>
      <xsl:template match="producer"           mode="job-role">Producer</xsl:template>
      <xsl:template match="support"            mode="job-role">Support</xsl:template>
      <xsl:template match="founders"            mode="job-role">Founders</xsl:template>
      <!-- legacy -->
      <xsl:template match="executiveeditor"    mode="job-role">Executive Editor</xsl:template>
      <xsl:template match="publisher"          mode="job-role">Publisher</xsl:template>
      <xsl:template match="vpoperations"       mode="job-role">VP of Operations</xsl:template>

        <!--
   <production-info>
    <ceo>Dave Rankin</ceo>
    <coo>Janet Furlow</coo>
    <managingeditor>Tammy Coron</managingeditor>
    <supervisingeditor></supervisingeditor>
    <series-editor>Bruce A. Tate</series-editor>
    <editor></editor>
    <copyeditor></copyeditor>
    <indexer>Potomac Indexing, LLC</indexer>
    <typesetter>Gilson Graphics</typesetter>
    <producer></producer>
    <rights></rights>
    <support></support>
    <founders>Andy Hunt and Dave Thomas</founders>
  </production-info>
        -->


       <xsl:template name="do-dedication-page">
         <xsl:apply-templates select="frontmatter/dedication" mode="force"/>
       </xsl:template>


       <xsl:template match="dedication" mode="force">
         <xsl:for-each select="p">
           <p class="dedication-text">
             <xsl:apply-templates/>
           </p>
         </xsl:for-each>
         <xsl:for-each select="name">
           <p class="dedication-name">
             <xsl:text>- </xsl:text>
             <xsl:apply-templates/>
           </p>
         </xsl:for-each>
       </xsl:template>

       <xsl:template match="dedication"/>


     </xsl:stylesheet>
