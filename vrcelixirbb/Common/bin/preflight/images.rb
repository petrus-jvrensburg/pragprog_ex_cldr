require 'image_size'

MAX_WIDTH_IN = {
  "airport" => 4.25,
  "default" => 5.5,
}

MIN_DPI      = 300

def validate_images(images, format)
  errors = []
  warnings = []

  min_pixel_width = (MAX_WIDTH_IN[format] || MAX_WIDTH_IN["default"]) * MIN_DPI

  images.each do |image|
    path = image[:fileref]
    width = image[:width] || "100%"

    unless path
      errors << "fileref missing from <imagedata...>"
      next
    end
    unless File.file?(path)
      errors << "#{path} not found"
      next
    end

    next if path.end_with?(".pdf")

    size = ImageSize.path(path)

    if !size
      errors << "cannot determine size of #{path}"
      next
    end

    if !size.width
      errors << "cannot determine width of #{path} (#{size.inspect})"
      next
    end

    factor = if width == "fit"
      1.0
    elsif width =~ /^(\d+)%$/
      $1.to_i / 100.0
    else
      errors << "#{path}: can't parse width #{width}"
      1.0
    end

    min_pixels = (min_pixel_width * factor).to_i

    if size.width < 0.65 * min_pixels
      errors << "#{path}: is #{size.width} pixels wide. It needs to be at least #{min_pixels}"
    elsif size.width < 0.85 * min_pixels
      warnings << "#{path}: is #{size.width} pixels wide. Ideally it should be at least #{min_pixels}"
    end
  end
  [ warnings, errors ]
end
