module Ksk::Asset
  extend ActiveSupport::Concern

  included do
    belongs_to :fileable, polymorphic: true

    default_scope -> { order('position ASC, created_at DESC') }

    has_one :preview
    before_create :set_last_position
    
    do_not_validate_attachment_file_type :file
    before_file_post_process :is_image?
    include Ksk::PaperclipCrop

    scope :only_images, -> {where(file_content_type: Bhf.configuration.paperclip_image_types)}
    scope :first_image, -> {only_images.limit(1)}
    scope :other_images, -> {only_images.offset(1)}

    scope :only_data_files, -> {where('file_content_type not in (?)', Bhf.configuration.paperclip_image_types)}
    scope :first_data_files, -> {only_data_files.limit(1)}
  end
  
  def is_image?
    Bhf.configuration.paperclip_image_types.include?(file.content_type)
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
  
  def ksk_images_for_crop
    { file: [] }
  end
  
end