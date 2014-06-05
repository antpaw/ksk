module Ksk::Asset
  extend ActiveSupport::Concern

  included do
    belongs_to :fileable, polymorphic: true

    default_scope -> {order 'position ASC, created_at DESC'}

    has_one :preview
    before_create :set_last_position
    
    after_initialize :resize_attr_accessors
    before_save :crop_thumbs, if: :cropping?

    do_not_validate_attachment_file_type :file

    scope :only_images, -> {where(file_content_type: Bhf::PAPERCLIP_IMAGE_TYPES)}
    scope :first_image, -> {only_images.limit(1)}
    scope :other_images, -> {only_images.offset(1)}

    scope :only_data_files, -> {where('file_content_type not in (?)', Bhf::PAPERCLIP_IMAGE_TYPES)}
    scope :first_data_files, -> {only_data_files.limit(1)}

    before_file_post_process :is_image?
  end
  
  def resize_attr_accessors
    file.styles.each_pair do |style, meta|
      self.class.send(:attr_accessor, "#{style}_x")
      self.class.send(:attr_accessor, "#{style}_y")
      self.class.send(:attr_accessor, "#{style}_w")
      self.class.send(:attr_accessor, "#{style}_h")
    end
  end
  
  def cropping?
    needs_crop = false
    file.styles.each_pair do |style, meta|
      if !needs_crop
        needs_crop = cords_set?(style)
      end
    end
    needs_crop
  end
  
  def cords_set?(style)
    !send("#{style}_x").blank? && !send("#{style}_y").blank? && !send("#{style}_w").blank? && !send("#{style}_h").blank?
  end
  
  def crop_thumbs
    file.styles.each_pair do |style, meta|
      if cords_set?(style)
        resize_banner style, [send("#{style}_x"), send("#{style}_y"), send("#{style}_w"), send("#{style}_h")], meta.attachment.options[:styles][style][0]
        send("#{style}_x=", false)
      end
    end
    file.save
    file.instance.save
  end
  
  def resize_banner(name, cords, resize)
    file.queued_for_write[name] = Paperclip.processor(:ksk_crop).make(file, cords, file)
    style = Paperclip::Style.new(name, [resize, :jpg], file)
    file.queued_for_write[name] = Paperclip.processor(:thumbnail).make(file.queued_for_write[name], style.processor_options, file.queued_for_write[name])
    file.queued_for_write[name] = Paperclip.io_adapters.for(file.queued_for_write[name])
  end
  
  def is_image?
    Bhf::PAPERCLIP_IMAGE_TYPES.include?(file.content_type)
  end

  def has_preview?
    preview && (preview.assets.any? || !preview.name.blank?)
  end

  def has_preview_image?
    preview.assets.any? and preview.assets.first.file
  end

  def preview_file
    if has_preview?
      preview.assets.first.file
    end
  end

  def to_bhf_s
    "ID: #{id} - Name: #{file_file_name}"
  end
  
  def set_last_position
    self.position = self.class.where(fileable_id: self.fileable_id).count + 1
  end
  
end
