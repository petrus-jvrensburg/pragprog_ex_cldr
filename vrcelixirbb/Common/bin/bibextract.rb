class Bibliography
  def initialize(filenames)
    @bib = filenames.map do |filename|
      begin
        File.read(filename)
      rescue
        fail "Can't read #{File.expand_path(filename, Dir.pwd)}"
      end
    end.join("\n")
    @bib.gsub!(/Annote\s*=\s*\{.*?\},\s*\n/m, '')
  end

  def find(cite)
    if @bib =~ /^@\w+\s*\{\s*#{cite}\s*,.*?\}\s*\n/im
      convert($&.dup)
    else
      STDERR.puts "Couldn't find #{cite.inspect}"
      nil
    end
  end

  def convert(entry)
    # remove \textit{ and {A} stuff
    entry = entry.
      sub(/\A.*?\n/, '').
      gsub(/\\textit\{/, '').
      sub(/\{\{/, '{').
      sub(/\}\}/, '}').
      gsub(/\{(.)\}/, '\1').
      sub(/^\}/m, '')

    entry.gsub!(/\{[^}]+\}/) { |param| param.tr(',', "\001") }
      
    entries = entry.split(/,/)
    result = {}
    entries.each do |entry|
      if entry =~ /^\s*(\w+)\s*=\s*\{?([^}]+)/
        result[$1.downcase] = $2.tr("\001", ",").strip
      end
    end
    result
  end
end

def gen_key(entry)
  entry["title"].split.map{|word| word[0,1].upcase}.join.gsub(/[^A-Z]/, '')
rescue Exception
  STDERR.puts entry.inspect
  raise
end

def normalize(string)
  (string || '').gsub(/\\&/, '&amp;')
end

bib_files = [ "../PPStuff/bibliography/Bibliography.bib" ]
while ARGV[0] == "-b"
  ARGV.shift
  bib_files << ARGV.shift
end

bib = Bibliography.new(bib_files)

file = ARGF.read

file = file.gsub(%r{<(bookname|articlename)[\s\n]+cite=("|')(.*?)\2\s*>(.*?)</\1>}m) do
  cite = $3
  tag = $1
  title = $4.gsub(/\n/, ' ').squeeze(" ")
  %{<#{tag}>#{title}</#{tag}><cite ref="#{cite}"/>}
end #'"

file = file.gsub(/<cite\s+ref=("|')(.*?)\1\s*\/>/m) do
  ref = $2
  entry = bib.find(ref)
  if entry.nil?
    %{<missing>Citation for #{ref}</missing>}
  else
    key = gen_key(entry)
    %{<realcite>
        <key>#{key}</key>
        <title>#{normalize(entry['title'])}</title>
        <author>#{normalize(entry['author'])}</author>
        <year>#{entry['year']}</year>
        <publisher>#{normalize(entry['publisher'])}</publisher>
      </realcite>
     }
  end
end

puts file
