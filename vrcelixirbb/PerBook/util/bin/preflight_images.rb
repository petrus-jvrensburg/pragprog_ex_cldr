# encoding: utf-8

# Scan image files and check to see if their resolution is up to snuff

@image_errors = []

def error(name, message)
  @image_errors << sprintf("%-40s %s", name, message)
end

def validate(name, ppu_x, ppu_y, factor)
  if factor == 0
    error name, "Has an unknown resolution (pixel values are #{ppu_x}x#{ppu_y}))"
  else
    x = (ppu_x * factor).round
    y = (ppu_y * factor).round
    if x < 240 || y < 240
      error name, "Resolution (#{x}x#{y}) is less than 240ppi"
    end
  end
end

def handle_png(name)
  data = File.open(name, "rb:binary")
  header = data.read(8)
  unless header[1,3] == "PNG" #{}"\x89PNG\r\n\x1A\n"
    error name, "#{name} is not a PNG"
    return
  end

  begin
    until data.eof?
      length = data.read(4)
      count = length.unpack("N")[0]
      chunk_type = data.read(4)
      chunk = data.read(count + 4)
      if chunk_type == 'pHYs'
        ppu_x, ppu_y, unit = chunk.unpack("N N C")

        factor = unit == 0 ? 1 : 0.0254

        validate(name, ppu_x, ppu_y, factor)
        break
      end
    end
  rescue
    error name, "This PNG file could not be read. Try recreating the PNG."
  end
end

def handle_jfif(data)
  version, units, ppu_x, ppu_y = data.read(9).unpack("a2 c n2")
  factor = { 0 => 0, 1 => 1, 2 => 2.54}[units] || 0
  [ ppu_x, ppu_y, factor ]
end

class Reader
  def initialize(data, start_of_tiff)
    @data = data
    @start_of_tiff = start_of_tiff
  end

  def seek(offset)
    @data.seek(offset + @start_of_tiff)
  end
end

class BigEndianReader < Reader
  def short
    @data.read(2).unpack("n")[0]
  end
  def long
    @data.read(4).unpack("N")[0]
  end
end

class LittleEndianReader < Reader
  def short
    @data.read(2).unpack("v")[0]
  end
  def long
    @data.read(4).unpack("V")[0]
  end
end


def handle_exif(data)
  # data.read(1)
  # start_of_tiff = data.tell
  # byte_order = data.read(2)
  # reader = case byte_order
  #   when "II"
  #     LitteEndianReader.new(data, start_of_tiff)
  #   when "MM"
  #     BigEndianReader.new(data, start_of_tiff)
  #   else
  #     fail "Invalid byte order #{byte_order.inspect}"
  #   end
  #
  # tag = reader.short
  # fail("tag mark invalid (#{tag})") unless tag == 0x2a
  # offset = reader.long
  # reader.seek(offset)
  #
  # count = reader.short
  # count.times do
  #   tag_number = reader.short
  #   data_type =  reader.short
  #   n = reader.long
  #   d = reader.long
  #   printf "%04x %d %d 5d\n", tag_number, data_type, n, d
  #   if tag_number = 0x8769
  #     reader.seek(d + 12)
  #     puts data.read(12).inspect
  #     break
  #   end
  # end
  # puts count
end

def handle_jpg(name)
  data = File.open(name, "rb:binary")
  soi, app, length, identifier = data.read(11).unpack("a2 a2 n a5")
  case identifier
  when "JFIF\x00"
    ppu_x, ppu_y, factor = handle_jfif(data)
  when "Exif\x00"
#    ppu_x, ppu_y, factor = handle_exif(data)
    error name, "#{name} is in exif format—I'm not smart enough to handle that"
    return
  else
    error name, "#{name} is not a JPG (got #{identifier.inspect} #{version.inspect} #{units} #{ppu_x})"
    return
  end

  validate(name, ppu_x, ppu_y, factor)
end

Dir.glob("**/*.png").each  { |name| handle_png(name)  }
Dir.glob("**/*.jpg").each  { |name| handle_jpg(name)  }
Dir.glob("**/*.jpeg").each { |name| handle_jpg(name)  }

unless @image_errors.empty?
  STDERR.puts "\n\nIMAGE ERRORS:\n"
  STDERR.puts "="*50
  @image_errors.each do |e|
    STDERR.puts e
  end
  STDERR.puts "\n\n"
end
