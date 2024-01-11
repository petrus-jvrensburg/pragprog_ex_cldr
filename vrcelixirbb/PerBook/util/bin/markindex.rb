if RUBY_VERSION =~ /1\.9/
  ARGF.binmode
end

ARGF.each do |line|
  line.chomp!
  if line =~ /^(\s*\\item\s+)([^,]*)(.*)/
    puts "#$1\\idxmark{#$2}#$3"
  else
    puts line
  end
end
