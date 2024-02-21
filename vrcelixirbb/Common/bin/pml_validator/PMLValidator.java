/**
* PMLValidator. A simple SAX-based validator. The complexity is that we need to track
* logical, not physical, line numbers. The proprocessor chain addes <?location file:line ?>
* PIs to the source. We use these to track where we are, and to adjust the line numbers in book.xml back
* to their equivalents in the original input files.
*
*/
import java.io.File;
import java.io.IOException;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

class PMLValidator extends DefaultHandler{
  public static void main(String[] args) {
    try {
      File inputFile = new File(args[0]);
      SAXParserFactory parserFactory = SAXParserFactory.newInstance();
      parserFactory.setValidating(true);
      parserFactory.setNamespaceAware(false);
      SAXParser parser = parserFactory.newSAXParser(); 

      XMLReader reader = parser.getXMLReader();
      try {
        reader.setFeature("http://xml.org/sax/features/namespace-prefixes", false);
        reader.setFeature("http://xml.org/sax/features/namespaces", false);
      } 
      catch (SAXException e) {
        System.err.println("could not set parser feature");
      }

      PMLValidator handler = new PMLValidator();
      parser.parse(inputFile, handler);
      System.exit(handler.errorCount);
    } catch (Exception e) {
      System.err.println(e.getMessage());
      System.exit(1);
    }
  }

  private String currentFileName;
  private int    currentLineNumberOffset;
  private Locator locator;

  public int errorCount;

  public PMLValidator() {
    currentFileName = null;
    currentLineNumberOffset = 0;
    errorCount = 0;
  }

  public void setDocumentLocator(Locator locator) {
    this.locator = locator;
  }

  public void processingInstruction(String target, String data) {
    if (target == "location") {
      String[] locations = data.split(":");
      int logicalLine = Integer.parseInt(locations[1].trim());
      currentLineNumberOffset = locator.getLineNumber() - logicalLine + 1;
      currentFileName = locations[0];
    }
  }

  public void startElement(String uri, String lName, String qName, Attributes attr) throws SAXException {
    if (qName.equals("url")) {
      String protocol = attr.getValue("protocol");
      if (protocol != null) {
        String file = getFileName("unknown");
        int line = locator.getLineNumber() - currentLineNumberOffset;
        String msg = "  Attribute \"protocol=\" of \"<url...>\" is deprecated.\n" +
                     "  Please prepend the protocol and any required delimiters to the actual url.";
        errorMessage(file, line, msg);
      }
    }
  }

  public void warning(SAXParseException e) throws SAXException { 
    printInfo(e);
  }
  public void error(SAXParseException e) throws SAXException {
    if (!e.getMessage().startsWith("Attribute \"xmlns:pml\" must be declared for element type \"book\""))
    printInfo(e);
  }
  public void fatalError(SAXParseException e) throws SAXException {
    printInfo(e);
  } 

  private String getFileName(String defaultName) {
    if (currentFileName == null) {
      return defaultName;
    }
    else {
      return currentFileName;
    }

  }

  private void errorMessage(String file, int line, String msg) {
    File f  = new File(file);
    String fname = f.getName();
    System.err.println();
    System.err.println("• " + fname + ", around line " + line);
    System.err.println(msg);
  }

  private void printInfo(SAXParseException e) {
    String file = getFileName(e.getSystemId());
    int line = e.getLineNumber() - currentLineNumberOffset;
    String msg = e.getMessage();

    errorMessage(file, line, "  " + msg);

    // Treat unknown IDs  as informational
    if (!(msg.startsWith("An element with the identifier") && msg.endsWith("must appear in the document.")))
    errorCount += 1;

  }

}
