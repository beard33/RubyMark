require 'optparse'

options = {}
colors = {}
RED = 'rgba(255,0,0,0.4)'
GREEN = 'rgba(0,255,0,0.4)'
BLUE = 'rgba(0,0,255,0.4)'
WHITE = 'rgba(255,255,255,0.4)'
BLACK =  'rgba(0,0,0,0.4)'
colors[:red] = RED
colors[:blue] = BLUE
colors[:green] = GREEN
colors[:black] = BLACK
colors[:white] = WHITE


options[:color] = RED
options[:text] = 'RubyMark'
options[:out] = 'out.jpg'

system('which convert > /dev/null', :err => File::NULL)
unless ($? == 0)
  puts("Please install ImageMagick")
  exit(1)
end

option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  # A non-mandatory option
  opts.on('-i', '--input example.png', String, '[MANDATORY] Input image to watermark') do |v|
    unless File.exist?(v)
      puts("File not found")
      exit(1)
    end
    options[:in] = v
  end

  # My mandatory option
  opts.on('-t watermark', '--text watermark', String, '[OPTIONAL] Specify the watermark text; default > RubyMark') do |t|
    options[:text] =  t
  end
  
  opts.on('-o', '--out out.png', '[OPTIONAL] Specify the output image; default > out.jpg') do |d|
    options[:out] = d
	end
	
	opts.on('-c', '--color color', '[OPTIONAL] Specify the watermark color; default > red') do |c|
    c.downcase!
    unless colors.has_key?(c.to_sym)
      puts("Please inesrt a valid color")
      puts("Available: RED, GREEN, BLUE, BLACK, WHITE")
      exit(1)
    end

    options[:color] = colors[c.to_sym]
    
  end
  
end

option_parser.parse!

if options[:in].nil?
  puts option_parser.help
  exit 1
end

cmd = "convert -density 150 -fill  \"#{options[:color]}\"  -gravity Center -pointsize 80 -draw \"rotate -45 text 0,0 \"#{options[:text]}\"\"  \"#{options[:in]}\" \"#{options[:out]}\""
system(cmd)
