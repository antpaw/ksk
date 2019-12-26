module ImageProcessors
  
  class KskCrop < Processor
    
    def initialize(file, options = {}, attachment = nil)
      super
      @crop = options
      @format = File.extname(@file.path)
      @basename = File.basename(@file.path, @format)
    end
    
    def make
      src = @file
      dst = Tempfile.new([@basename, @format])
      dst.binmode
      
      parameters = []
      parameters << ":source"
      parameters << "-crop '#{@crop[2]}x#{@crop[3]}+#{@crop[0]}+#{@crop[1]}'"
      parameters << ":dest"

      parameters = parameters.flatten.compact.join(' ').strip.squeeze(' ')
      
      path = if @file.options && @file.options[:storage] == :s3
        src.url
      else
        File.expand_path(src.path)
      end
      # success = Paperclip.run('convert', parameters, source: path, dest: File.expand_path(dst.path))

      dst
    end
    
  end
end
