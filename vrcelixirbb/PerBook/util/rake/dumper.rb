stuff_to_dump = %w{
  Time.now
  Dir.pwd
  system("df\ -h\ .")
  RUBY_DESCRIPTION
  ENV_JAVA
  $:
  Dir[ENV_JAVA["jruby.home"]+"/lib/ruby/gems/shared/gems/*"]
  Gem.paths.path
  Gem.loaded_specs
}
desc "Dump out the local environment to help Dave diagnose issues"
task "dump-env" do
  require 'pp'
  stuff_to_dump.each do |name|
    puts
    puts name
    pp eval(name)
  end
end
