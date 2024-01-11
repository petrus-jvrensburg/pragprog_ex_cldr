# Read a list of image file names from STDIN. For each, attempt
# to create a .png file in the epub images directory
#
require "fileutils"

MATH_FONT = File.expand_path("../fonts/Asana-Math.ttf", File.dirname(__FILE__))

BASIC_OPTS = %{-colorspace RGB -depth 8 -density 72 -resample 100x100   -background white -flatten -alpha Off}

DeviceData = Struct.new(:max_width, :max_height) do

  def as_geometry(scale=nil)
    w = self.max_width
    h = self.max_height

    case scale
    when /(\d+)%/
    factor = Integer($1)/100.0
      w = (w * factor).to_i
      h = (h * factor).to_i
    when "headshot"
      #factor = 1.00
      #w = (w * factor).to_i
      #h = (h * factor).to_i
      #h = w if w < h
      #w = h if h < w
      w = h = 72
    when "cover"
      factor = 0.2
      w = (w * factor).to_i
      h = (h * factor).to_i
      h = w if w < h
      w = h if h < w
    when /fit/, nil
      # ...
    else
      fail("Unknown scale factor: #{scale.inspect}")
    end

    %{-resize "#{w}x#{h}+0+0>"}

  end

  def as_convert_param(scale)
    extras = if scale == "cover"
               " -bordercolor gray -border 1x1"
             end
    %{#{BASIC_OPTS} #{as_geometry(scale)}#{extras}}
  end
end

def D(*args)
  DeviceData.new(*args)
end

PROFILES = {
  "kindle"  => D(400, 500),
  "epub"    => D(300, 420),
  "epub-xl" => D(900, 1200),
  "html"    => D(1024, 800)
}




########################################
#
# Regular images (jpg, gif, png) can be used directly, the rest must be converted
#

def find_source_for(target, scale)
  case
  when scale == "cover"
    File.join(ENV['PPCOVERS'], target, 'images', "#{target}_72dpi.jpg")

  when target =~ /\.(gif|jpg|jpeg|png)$/i && File.exist?(target)
    target
   else
    # this seems strange, but it allows us to force jpg in the
    # final ebook even if the original image is (say) a png.
    # It works because the XSL forces a .jpg extension in the image_list
    root = target.sub(/\.(gif|jpg|jpeg|png)$/i, '')
    %w{ tif pdf png jpeg gif svg }.each do |ext|
      source = "#{root}.#{ext}"
      return source if File.exist?(source)
    end
    nil
  end


end

########################################
#
# Convert from a source to a target format, putting
# the result in the epub images directory

def convert(source, target, scale, dest_dir, profile)
  source = "\"#{source}[0]\"" if source =~ /\.tiff?$/    # don't convert thumbnail

  case target
  when %r{^\.\./PerBook/util}
    dest = File.join(dest_dir, target.sub(%r{^\.\./PerBook/util/}, ''))
  when %r{images/}
    dest = File.join(dest_dir, target)
  else
    dest = File.join(dest_dir, "images", target)
  end

  FileUtils::mkdir_p(File.dirname(dest))

  # get width from source image. We'll use this later to figure out if the
  # image is too small
  width = `identify -format "%w" #{source}`

  if source =~ /\.svg$/i
    use_font = ""

    # clarify svgs - this is a fix for math in epubs
    if source =~ /svg-\d+\.svg$/i
      # inline needs higher res to match fonts.
      puts "### INLINE MATH - resizing ###"
      density_opts = %{-density 288 -resize 50% -font "#{MATH_FONT}"}
    elsif source =~ /svg-block-\d+\.svg$/i
      puts "### BLOCK MATH ###"

      # if the width is smaller than the min width, add options to upscale it
      if width.to_i < profile.max_width
        puts "   * SMALL image width found - resize and resample: width is #{width}"
        density_opts = %{-density 288 -resize 50% -font "#{MATH_FONT}"}
      else
        puts "   * adequate image width found - no resize: width is #{width}"
        density_opts = %{-density 100 -font "#{MATH_FONT}"}
      end
    else
      # it's not a math svg. It's something else.

      # if the width is smaller than the min width, add options to upscale it
      if width.to_i < profile.max_width
        puts "#### Small svg image found - resizing : width is  #{width} ####"
        density_opts = %{-density 400 -resize 50%}
      end
    end

  end

  # PDFs that are tiny may need a little extra clarity
  # Look for a PDF....
  if source =~ /\.pdf$/i

    # if the width is smaller than the min width, add options to upscale it
    if width.to_i < profile.max_width
      puts "#### Small PDF image found - resizing : width is  #{width} ####"
      density_opts = %{-density 400 -resize 50%}
    end
  end

  if !File.exist?(dest) || (File.mtime(source) > File.mtime(dest))
    cmd = %{convert #{density_opts} "#{source}" #{profile.as_convert_param(scale)} \"#{dest}\"}
    puts cmd
    system cmd
  else
    puts "Already done #{dest}"
  end
end


def copy(source, target, dest_dir)

  case target
  when %r{^\.\./PPStuff}
    dest = File.join(dest_dir, target.sub(%r{^\.\./PerBook/util/}, ''))
  when %r{images/}
    dest = File.join(dest_dir, target)
  else
    dest = File.join(dest_dir, "images", target)
  end

  FileUtils::mkdir_p(File.dirname(dest))
  FileUtils::cp(source, dest)
end


########################################

dest_dir      = ARGV.shift          || fail("Missing destination directory")

profile_name = ARGV.shift           || fail("Missing profile name")

image_list_name = ARGV.shift        || fail("Missing image_list name")

profile = PROFILES[profile_name] || fail("Unknown profile name #{profile_name}")

# These are precanned in every template
already_done = { "WigglyRoad.jpg" => 1, "joe.jpg" => 1}

File.readlines(image_list_name).each do |line|
  next if line =~ /<\?xml version.*\?>\s*$/   # xalan adds it...
  next if line =~ /^\s*$/

  target, scale = line.chomp.split(/@/)
  next if already_done[target]
  already_done[target] = 1

  source = find_source_for(target, scale)

  if scale == 'cover'
    target = "images/_covers/#{target}.jpg"
  end

  case
  when source.nil?
    STDERR.puts "Couldn't find source image for #{target}"
  else
    convert(source, target, scale, dest_dir, profile)
  end
end
