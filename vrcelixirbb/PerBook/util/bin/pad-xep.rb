# Read a .xep file and pad it to a multiple of 'n' pages
#
# ruby pad-xep.rb n file-name.rb

padding = Integer(ARGV.shift)
filename = ARGV.shift

content = File.read(filename)

# Look for the last <xep:page in the file
last_page = content.scan(%r{<xep:page.*}).last

unless last_page =~ %r{(<xep:page.*?)page-number="(\d+)"\s+page-id="(\d+)"}
  fail "Don't recognize <xep:page>:  #{last_page}"
end

leader  = $1.dup
number  = Integer($2)
page_id = Integer($3)

pages_in_last_signature = number % padding

if pages_in_last_signature > 0
  to_add = padding - pages_in_last_signature
  extra_pages = []
  to_add.times do 
    number += 1
    page_id += 1
    extra_pages << %{#{leader} page-number="#{number}" page-id="#{page_id}" />}
  end
  File.open(filename, "w") do |f|
    f.puts content.sub(%r{</xep:document>}, %{#{extra_pages.join("\n")}\n</xep:document>} )
  end
end
