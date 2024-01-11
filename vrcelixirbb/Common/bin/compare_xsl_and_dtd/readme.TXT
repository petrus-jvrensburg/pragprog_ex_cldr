The contents of this directory are used to run reports on the XSL and DTDs for PragProg's XSL-based rendering system.

Use Ant to process the elements.xml file. This build file in turn will execute the XSL that generates the output.  

I used the DITA Open Toolkit as a platform for executing Ant because it allows you a quick setup of environment variables, including the Saxon XSLT processor. However, there is no dependency between this set of files and the DITA OT.

The Ant command line is:

  ant -f elements.xml
  
No other parameters are used.

The rootdir property in elements.xml points to the book directory on which the scripts are to be run. You will likely need to adjust the rootdir path. The rootdir path is given as a relative path from the location of the elements.xml file.

The XSL files were originally place in the xsl/pragprog directory in the DITA OT.  That relative path is preserved.

Other paths may need to be adjusted in the XSLT.  To find these paths, search for the document() function in the XSLT.

Currently the outputs are placed in a folder called out.  This folder is expected to be a child directory of the folder where the elements.xml file is located.



