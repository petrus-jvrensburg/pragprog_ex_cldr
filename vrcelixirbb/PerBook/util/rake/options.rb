BUILD_OPTIONS = {}

if ENV['PPCOVERS']
  BUILD_OPTIONS['covers-root-dir'] = ENV['PPCOVERS']
end


desc "Remove workflow markup from PDFs. Use as 'rake no-workflow screen'"
task "no-workflow" do
  BUILD_OPTIONS["ignore-workflow-tags"] = "yes"
end


desc "Generate extracts, not the full book"
task "set-extract-flag" do
  BUILD_OPTIONS["extracts"] = "yes"
  BUILD_OPTIONS["ignore-workflow-tags"] = "yes"
end

desc "Generate the chapter from the full book.xml"
task "set-chapter-flag" do
  BUILD_OPTIONS["chapter"] = "yes"
end

desc "Generate the SITB version of the paper book"
task "set-sitb-flag" do
  BUILD_OPTIONS["sitb"] = "yes"
end
