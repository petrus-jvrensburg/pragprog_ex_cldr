# Check the log output of a build to see if it is ready to enter
# production

class Reporter
  attr_writer :subheading

  VALIDATION_FAILED = "\n\n=============== VALIDATION FAILED ================="
  def initialize(log)
    @log = log
  end
  
  def check_for(heading, pattern)
    @subheading = heading
    @log.scan(pattern) { |problem| report problem }
  end
  
  def report(string)
    print_heading
    puts string
  end

  def print_heading
    unless @heading
      puts VALIDATION_FAILED
      @heading = true
    end
    if @subheading
      puts "\n\n", @subheading, "=" * @subheading.size
      @subheading = nil
    end
  end
                 
  # check there's a file in src/ for every file in eps
  def check_images
    @subheading = "The following .eps files appear not to have a corresponding source image"
    
    eps_files = []
    Dir.chdir("images/eps") do
      eps_files = Dir.glob("**/*.eps")
    end
    Dir.chdir("images/src") do
      src_files = Dir.glob("**/*").join("\n") + "\n"
      eps_files.each do |eps|
        next if eps == "cover.eps"
        src_pattern = eps.sub(/\.eps.?/i, '')   
        unless src_files.sub!(/^#{src_pattern}\..*?\n/, '')
          report eps
        end
      end
    end  
  end
  
  def tidyup
    if @heading
      puts VALIDATION_FAILED, "\n\n"
    else
      puts "\n\nVALIDATION SUCCESSFUL\n\n"
    end
  end
  
end

reporter = Reporter.new(STDIN.read)


reporter.check_for("Cross Reference Check", /Warning: unknown cross reference to ".*?"/)
reporter.check_for("Code line length check",  /^Too long: .*"/)
reporter.check_for("Overly long code file names",  /^File name '.*?' truncated/)
reporter.check_for("Missing images", /File `.*?' not found\./)
reporter.check_for("Deprecated <cite> tags", /You have <cite ref=".*?"\s*\/>/)
reporter.check_for("Missing bibliograpy entries", /Warning--I didn't find a database entry for ".*?"/)
reporter.check_for("Bad cross references", /Warning: unknown cross reference to ".*?"/)

reporter.check_images

reporter.tidyup
