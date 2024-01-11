unless respond_to?(:require_relative)
  def require_relative(relative_feature)
    c = caller.first
    fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
    file = $`
    if /\A\((.*)\)/ =~ file # eval, etc.
      raise LoadError, "require_relative is called in #{$1}"
    end
    absolute = File.expand_path(relative_feature, File.dirname(file))
    require absolute
  end
end

class Preprocessor
end

require_relative '../lib/pml_code.rb'  # for now...

PmlCode.new.process(STDIN, STDOUT)
