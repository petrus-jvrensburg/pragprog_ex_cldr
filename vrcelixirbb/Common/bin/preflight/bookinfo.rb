require "ox"

DATE_RE = /
(  January
|  February
|  March
|  April
|  May
|  June
|  July
|  August
|  September
|  October
|  November
|  December
)\s
20[012]\d
/x

def load_into_hash
  path = File.expand_path(File.join("..", "bookinfo.pml"))
  unless File.exist?(path)
    STDERR.puts "Cannot find #{path}"
    exit 1
  end

  meta = Ox.load(File.read(path), mode: :hash)

  bookinfo = meta[:bookinfo] || error("Top level should be a <bookinfo> tag")

  bookinfo.each_with_object({}) do |entry, result|
    entry.each do |k, v|
      result[k.to_s] = v
    end
  end
end

def check_required(structure_name, fields, tags)
  tags.reduce([]) do |errors, tag|
    unless fields[tag]
      errors << "Entry #{tag} is missing from #{structure_name}"
    end
    errors
  end
end

def validate_printing(printing)
  errors = check_required("<printing>", printing, [ :printingnumber, :printingdate ]) 
  if errors.empty?
    date = printing[:printingdate]
    unless date =~ DATE_RE
      errors << "<printingdate> should be 'Monthname Year', got #{date.inspect}" 
    end
  end
  errors
end

SEPERATOR = "=" * 72

def pretty_print(fields)
  puts 
  puts "Please verify these details"
  puts SEPERATOR
  puts
  puts fields["booktitle"]
  puts fields["booksubtitle"] if fields["booksubtitle"]
  puts 
  authors = Array(fields["authors"][:person])
    .map { |person| person[:name] }
    .join("\n    ")
  print "By: "
  puts authors
  puts

  cr = fields["copyright"]
  puts "Copyright #{cr[:copyrightdate]}, #{cr[:copyrightholder]}"
  puts "Code: #{fields['code']} | ISBN: #{fields['isbn13']}"
  
  pr = fields["printing"]
  puts "Printing: #{pr[:printingnumber]}, #{pr[:printingdate]}"

  pi = fields["production_info"]
  if pi
    puts "\nProduction team"
    label_length = pi.max_by {|k, v| k.length} + 2
    pi.each do |k, v|
      puts "#{k}:".rjust(label_length)#{v}"
    end
  end
  puts 
  puts SEPERATOR
  puts
end

def validate_bookinfo
  fields = load_into_hash()
  pretty_print(fields)
  errors = check_required("bookinfo", fields, 
    %w{ code production-status booktype booktitle authors copyright isbn13 printing })
  errors = validate_printing(fields["printing"]) if errors.empty?

  unless fields["production-info"]
    errors << "NOTE: <missing production-info>"
  end
  [ fields, errors ]
end

