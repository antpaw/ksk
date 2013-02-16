module Apdown
  
  def self.parse_regex(type)
    /(\{#{type}_(\d{1,2})_?(\w+)?\})/i
  end
  
  def text_used_content(type)
    (apdown_text || '').scan(Apdown.parse_regex(type)).each_with_object([]) do |match, used_numbers|
      used_numbers << match[1].to_i
    end
  end

  def text_unused_content(all_files, type, preselected = [])
    all_numbers = []
    all_files.each_with_index { |a, i| all_numbers << i+1 }
  
    unused_numbers = all_numbers - (text_used_content(type)+preselected)
  
    unused_files = []
    all_files.each_with_index do |a, i|
      unused_files << a if unused_numbers.include?(i+1)
    end
    unused_files
  end

  def text_used_images
    text_used_content('img')
  end
  
  def text_unused_images
    text_unused_content(assets.only_images, 'img', respond_to?(:apdown_preselect) && apdown_preselect || [])
  end

  def text_used_data_files
    text_used_content('file')
  end
  
  def text_unused_data_files
    text_unused_content(assets.only_data_files, 'file')
  end
  
end
