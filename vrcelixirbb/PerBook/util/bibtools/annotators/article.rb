class Article < Annotator

  def create_bib_line(entry)
    line = Nokogiri::XML::Node.new("bib-line", @doc)
    line << text(author_names(entry) + ". ")
    line << text(title(entry) + ". ")
    line << bookname(journal(entry))
	if volume_and_pages(entry).join.length > 0
      fields = volume_and_pages(entry) << (date(entry))
	  line << text(". " + fields.join(", "))
    else
	  line << text(". " + date(entry).join(", "))
	end
    line << "."
    entry.add_child(line)
  end

end

