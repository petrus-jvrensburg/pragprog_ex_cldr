
def create_book_pml_from_yaml(yaml_file)
  require 'yaml'
  require 'nokogiri'

  structure = YAML.load(File.read(yaml_file))
  File.open("book.pml", "w") do |f|
    f.puts(yaml_to_xml(structure))
  end
end


def yaml_to_xml(structure)
  builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
    #    xml.doc.create_internal_subset('book', 'SYSTEM', "local/xml/markup.dtd")
    xml.book('xmlns:pml' => "http://pragprog.com/ns/pml") do
      do_options(structure, xml)
      do_metadata(structure, xml)
      %w{ frontmatter mainmatter backmatter }.each do |section|
        do_major_section(section, structure, xml)
      end
    end
  end

  # Hate it, but I can't get the internal_subset call above to work
  builder.to_xml.sub(/\n/, %{\n<!DOCTYPE book SYSTEM "local/xml/markup.dtd">\n})
end


def do_options(structure, xml)
  if options = structure["options"]
    xml.options do
      options.each do |k, v|
        xml.send(k, v)
      end
    end
  end
end

def do_metadata(structure, xml)
  bookinfo_name = structure["metadata"]
  fail "Missing 'metadata:' in book.yml" unless bookinfo_name
  bookinfo_name << ".yml" unless bookinfo_name =~ /\.yml$/
  book_info = YAML.load(File.read(bookinfo_name))
  xml.bookinfo(:booktype => "book", :code => File.basename(File.dirname(Dir.pwd)).downcase) do
    xml.booktitle(book_info["title"])
    xml.booksubtitle(book_info["subtitle"]) if book_info["subtitle"]
    do_authors(book_info["authors"], xml)
    do_copyright(book_info["copyright"], xml)
    xml.isbn13(book_info["isbn13"]) if book_info["isbn13"]
    do_printing(book_info["versions"], xml)
    do_team(book_info["team"], xml)
  end
end

def do_authors(authors, xml)
  xml.authors do
    authors.each do |a|
      xml.person do
        xml.name(a["name"])
        xml.affiliation(a["affiliation"]) if a["affiliation"]
      end
    end
  end
end

def do_copyright(copyright, xml)
  fail "Missing 'copyright:'" unless copyright
  xml.copyright do
    xml.copyrightholder(copyright["holder"]  || "The Pragmatic Bookshelf, LLC")
    xml.copyrightdate(copyright["year"] || Time.now.year)
  end
end

def do_printing(versions, xml)
  return unless versions
  latest = versions.first
  xml.printing do
    xml.printingnumber(latest["number"])
    xml.printingdate(latest["date"])
  end
end

def do_team(team, xml)
  return unless team
  xml.send("production-info") do
    team.each do |role, name|
      xml.send(role, name)
    end
  end
end



def do_major_section(name, structure, xml)
  return unless section = structure[name]
  xml.send(name) do
    section = [ section ] unless section.kind_of?(Array)
    section.each do |content|
      do_content(content, xml)
    end
  end
end

def do_include(files, xml)
  files.each do |file|
    xml['pml'].include(:file => file)
  end
end

def do_part(content, xml)
  xml.part do
    xml.title(content["title"])
    if intro = content["intro"]
      xml.partintro do
        if intro.kind_of?(String)
          intro.split(/\n\s*\n/).each {|paragraph| xml.p(paragraph) }
        else
          do_content(intro, xml)
        end
      end
    end
    do_include(content["include"].split(/\s+/), xml)
  end
end

def do_content(content, xml)
  content.each do |name, value|
    case name
    when "include"
      do_include(value.split(/\s+/), xml)
    when "part"
      do_part(value, xml)
    else
      fail "Unknown content: #{name}"
    end
  end
end

__END__

<?xml version="1.0" encoding="UTF-8"?> 
<!-- -*- xml -*- -->
<!DOCTYPE book SYSTEM "local/xml/markup.dtd">

<book>

  <pml:include file="../bookinfo.pml"/>

  <frontmatter>
    <pml:include file="Introduction"/>
  </frontmatter>

  <!-- START:mainmatter -->
  <mainmatter>

    <part>
      <title>Pragmatic Markup</title>
      <partintro>
        <p>
            Our markup system is simple and straightforward, and is based on
            the meaning and purpose of text, not its appearance. When writing,
            you want to put your energy into the content. Don't worry too much
            about the appearance at first.
        </p>
      </partintro>
      <pml:include file="MUIntro"/>
      <pml:include file="Markup"/>
      <pml:include file="FiguresImages"/>
      <pml:include file="Tables"/>
      <pml:include file="Code"/>
      <pml:include file="Math"/>
      <pml:include file="Markdown"/>
    </part>
    
    <part>
      <title>Pragmatic Writer's Guide</title>
      <partintro>
          <pml:include file="WGIntro"/>
      </partintro>
      <pml:include file="Habits"/>
      <pml:include file="StoryBoard"/>
      <pml:include file="HerosJourney"/>
      <pml:include file="Tips"/>
      <pml:include file="Editors"/>
      <pml:include file="Promotion"/>  
      <pml:include file="Conclusion"/>
    </part>
    
    <pml:include file="Entities"/>
    <pml:include file="Preprocessor"/>
    <pml:include file="PermissionGuidelines"/>
    <pml:include file="AllAboutGrammar"/>

    <pml:include file="Bibliography"/>

  </mainmatter>
  
  
  <!-- END:mainmatter -->

  <!--  
  <backmatter>
    <pml:ignore file="local/backmatter/backmatter"/>
  </backmatter>
   -->

</book>

metadata: bookinfo.yml

options:
  recipetitle:
    name: Recipe

frontmatter: 
  include: introduction

mainmatter:
- part: 
    title: Pragmatic Markup
    intro:
      Our markup system is simple and straightforward, and is based on
      the meaning and purpose of text, not its appearance. When writing,
      you want to put your energy into the content. Don't worry too much
      about the appearance at first.
    include:
      MUIntro
      Markup
      FiguresImages
      Tables
      Code
      Math
      Markdown

- part:
    title: Pragmatic Writer's Guide
    intro:
      include: WGIntro
    include:
      Habits
      StoryBoard
      HerosJourney
      Tips
      Editors
      Promotion  
      Conclusion

- include:  
    Entities
    Preprocessor
    PermissionGuidelines
    AllAboutGrammar
    Bibliography
