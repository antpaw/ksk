module Ksk::PaperclipCrop
  extend ActiveSupport::Concern
  
  included do
    after_initialize :resize_attr_accessors
    before_save :crop_thumbs, if: :cropping?
  end
  
  def resize_attr_accessors
    ksk_images_for_crop.each_pair do |image_name, style_names|
      send(image_name).styles.each_pair do |style, meta|
        self.class.send(:attr_accessor, "#{image_name}_#{style}_x")
        self.class.send(:attr_accessor, "#{image_name}_#{style}_y")
        self.class.send(:attr_accessor, "#{image_name}_#{style}_w")
        self.class.send(:attr_accessor, "#{image_name}_#{style}_h")
      end
    end
  end
  
  def cropping?
    needs_crop = false
    ksk_images_for_crop.each_pair do |image_name, style_names|
      send(image_name).styles.each_pair do |style, meta|
        unless needs_crop
          needs_crop = cords_set?(image_name, style)
        end
      end
    end
    needs_crop
  end
  
  def cords_set?(image_name, style)
    !send("#{image_name}_#{style}_x").blank? && !send("#{image_name}_#{style}_y").blank? && !send("#{image_name}_#{style}_w").blank? && !send("#{image_name}_#{style}_h").blank?
  end
  
  def crop_thumbs
    ksk_images_for_crop.each_pair do |image_name, style_names|
      image = send(image_name)
      image.styles.each_pair do |style, meta|
        if cords_set?(image_name, style)
          resize_banner style, [send("#{image_name}_#{style}_x"), send("#{image_name}_#{style}_y"), send("#{image_name}_#{style}_w"), send("#{image_name}_#{style}_h")], meta.attachment.options[:styles][style][0]
          send("#{image_name}_#{style}_x=", false)
        end
      end
      image.save
      image.instance.save
    end
  end
  
  def resize_banner(name, cords, resize)
    ksk_images_for_crop.each_pair do |image_name, style_names|
      image = send(image_name)
      image.queued_for_write[name] = Paperclip.processor(:ksk_crop).make(image, cords, image)
      style = Paperclip::Style.new(name, [resize, :jpg], image)
      image.queued_for_write[name] = Paperclip.processor(:thumbnail).make(image.queued_for_write[name], style.processor_options, image.queued_for_write[name])
      image.queued_for_write[name] = Paperclip.io_adapters.for(image.queued_for_write[name])
    end
  end
  
end