# Remove any <a href's> that point to things not in the current file

require 'rubygems'
require 'hpricot'

chap_name = ARGV.shift || fail("Missing chapter name")

content = STDIN.read

doc = Hpricot(content)

# build the list of all our IDs
ids = {}
doc.search("[@id]").each {|el| ids[el['id']] = 1 }

doc.search("a[@href]").each do |el|
  href = el['href']
  next if href !~ /^chap-/
  #remove the 'a' if it references a different chapter or
  #a link in the current chapter that isn't defined

  chapter, id = href.split(/\#/, 2)
  if chapter != chap_name || !ids.has_key?(id)
    el.swap el.inner_html
  else
    el[:href] = href.sub(/\.xhtml/, '-extract.html') 
  end
end

puts doc
