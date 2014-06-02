module Ksk::Markdown
  extend ActiveSupport::Concern

  def text_used_content(type)
    Ksk::Markdown.parse_text(markdown_text, type).each_with_object([]) do |match, used_numbers|
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
    text_unused_content(assets.only_images, 'img', respond_to?(:markdown_preselect) && markdown_preselect || [])
  end

  def text_used_data_files
    text_used_content('file')
  end
  
  def text_unused_data_files
    text_unused_content(assets.only_data_files, 'file')
  end
  
  
  def markdown_text
    content
  end

  def content_long
    "#{intro} #{hidden_text}"
  end

  def content_short
    intro
  end

  def intro
    split_content[0]
  end

  def hidden_text
    split_content[1]
  end

  def split_content
    return [] if read_attribute(:content).blank?
    read_attribute(:content).split('@@@')
  end

  def content_has_more?
    !hidden_text.blank?
  end

  
  def self.parse_regex(type)
    /(\{#{type}_(\d{1,2})_?(\w+)?\})/i
  end
  
  def self.parse_text(text, type)
    text.to_s.scan(parse_regex(type))
  end
end
