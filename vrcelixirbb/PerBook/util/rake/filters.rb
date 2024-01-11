namespace :filter do

  desc "Run the filter given by FILTER= on standard input/output"
  task :run do
    fail "Missing filter name" unless klass_name = ENV['FILTER']

    if file_path = ENV["FILTER_PATH"]
      require file_path
    else
      base_file_path = klass_name.gsub(/([a-z0-9])([A-Z])/) { "#$1_#{$2.downcase}" }.downcase + ".rb"
      possible_locations = [File.join(*%w{ local util }), File.join(*%w{ .. PerBook util bin preprocess }) ]
      
      found = false
      possible_locations.each do |location|
        file_path = File.expand_path(File.join(location, base_file_path), Dir.pwd)
        if File.exist?(file_path)
          require file_path
          found = true
          break
        end
      end
      
      unless found
        fail "Couldn't find #{base_file_path} in #{possible_locations.join(' or ')}"
      end
    end

    klass = Module.const_get(klass_name)
    klass.new.process(STDIN, STDOUT)
  end

  desc "Test the filter given by FILTER="
  task :test do
    fail "Missing filter name" unless klass_name = ENV['FILTER']

    file_path = klass_name.gsub(/([a-z0-9])([A-Z])/) { "#$1_#{$2.downcase}" }
    file_path = File.expand_path(File.join("local", "util", "#{file_path.downcase}.rb"), Dir.pwd)
    require file_path
    
    code = File.read(file_path)
    if code =~ /^__END__\s*\n(.*)/m
      klass = Module.const_get(klass_name)
      klass.new.test($1)
    else
      fail "No test data found in #{file_path} (I was looking for stuff after __END__)"
    end
  end


end
