# -*- coding: utf-8 -*-
# We take an entry from the main bibliography and add two things to it:
#
#  1. a label, used to cross-reference it to the biblio listing
#
#  2. a bib-line—the text actually displayed in the listing
#
# We delegate this work to one of outr child classes, depending on the
# type of the entry (book, article, web, ...)

class Annotator

  EXISTING_LABELS = {}   # global to all annotators...

  ANNOTATORS = {}

  def self.inherited(annotator)
    ANNOTATORS[annotator.name.downcase] = annotator
  end

  require_relative 'annotators/book'
  require_relative 'annotators/article'


  def self.process(doc, publishers, entry)
    name = entry.node_name.downcase
    annotator = ANNOTATORS[name]
    if annotator.nil?
      error("Cannot find bibliography annotator for #{name.inspect}. This annotator is not supported. Supported annotators are #{ANNOTATORS.keys.join(",")}")
    end
    annotator.new(doc, publishers).process(entry)
  end


  def initialize(doc, publishers)
    @doc        = doc
    @publishers = publishers
  end


  def process(entry)
    label = add_label(entry)
    create_bib_line(entry)     # in child...
    entry
  end



  # The label is:
  #   For an organization or single author, the first three letters of the name
  #   For multiple authors, the first letter of each of their names,
  #   followed by the last two of the year
  #   followed by a flower case sequence if the label isn't unique

  def add_label(entry)
    name = get_name_part(entry)
    year = entry.css('year')[0].text[-2,2]

    label = name + year
    suffix = ''

    while EXISTING_LABELS[label + suffix]
      if suffix == ''
        suffix = 'a'
      else
        suffix = suffix.succ
      end
    end

    label << suffix
    EXISTING_LABELS[label] = 1

    entry["label"] = label
    label
  end

  private

  def author_names(entry)
    authors = entry.xpath("authors/author | authors/organization")
    to_sentence(authors.map {|author| author_name(author)})
  end

  def bookname(title)
    bookname = Nokogiri::XML::Node.new("bookname", @doc)
    bookname << title
    bookname
  end

  def title(entry)
    title = entry.css("title")[0].text
  end

  def journal(entry)
    title = entry.css("in-journal")[0].text
  end

  def publisher(entry)

    pub_id = entry.xpath("publisher/@ref").text
    if details = @publishers[pub_id]
      [ details ]
    else
      STDERR.puts @publishers.inspect
      error("Cannot find publisher with id #{pub_id.inspect}")
      STDERR.puts "\n\nEntry that failed: #{entry.xpath("title").text}"
    end
  end

  def edition(entry)
    optional(entry, "edition")
  end

  def date(entry)
    result = [ ]
    maybe_append(result, entry, 'year')
    maybe_append(result, entry, 'month')
    result
  end

  def volume_and_pages(entry)
    volume = get_text(entry, 'volume')
    result = get_text(entry, 'volume') || ""
    number = get_text(entry, 'number')
    pages  = get_text(entry, 'page-range')
    if number
      result << "[" << number << "]"
    end
    if pages
	  if (volume or number)
        result << ":" << pages
	  else
	    result << pages
	  end
    end
    [ result ]
  end

  def optional(entry, tag)
    result = []
    maybe_append(result, entry, tag)
    result
  end

  def maybe_append(array, entry, tag)
    element = entry.css(tag)
    unless element.empty?
      array.concat(element.map {|e| e.text})
    end
  end

  def author_name(author)
    if author.node_name == "organization"
      author.text
    else
      author.xpath("given | prefix | family | suffix").map {|part| part.text}.join(" ")
    end
  end

  def to_sentence(phrases)
    last = phrases.pop
    case phrases.size
    when 0
      last
    when 1
      "#{phrases[0]} and #{last}"
    else
      "#{phrases.join(", ")}, and #{last}"
    end
  end

  def get_name_part(entry)
    names = entry.xpath("authors/organization|authors/author")

    if names.size == 1
      single_name(names[0])
    else
      joint_name(names)
    end
  end

  def single_name(node)
    if node.node_name == "organization"
      node.text
    else
      get_text(node, 'family')
    end[0,3]
  end

  def get_text(entry, tag)
    result = entry.css(tag)
    if result.empty?
      nil
    else
      result[0].text
    end
  end

  def joint_name(names)
    names.css('family').map {|f| f.text[0,1]}.join[0,4]
  end

  def text(text)
    Nokogiri::XML::Text.new(text, @doc)
  end


end

