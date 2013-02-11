class Asset < ActiveRecord::Base
  
  belongs_to :fileable, polymorphic: true
  
  default_scope order: 'position ASC, created_at DESC'
  
  has_one :preview
  before_create :set_last_position


  #validates_attachment :file, :content_type => { :content_type => IMGTYPE }
  IMGTYPE = ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/tif', 'image/gif']
  
  scope :only_images, where(file_content_type: IMGTYPE)
  scope :first_image, only_images.limit(1)
  scope :other_images, only_images.offset(1)
  
  scope :only_data_files, where(['file_content_type not in (?)', IMGTYPE])
  scope :first_data_files, only_data_files.limit(1)
  
  
  has_attached_file :file, 
    :styles => {
      :banner => ['640>', :jpg],
      :medium => ['1000>', :jpg],
      :thumb  => ['200x200>', :jpg]
    },
    :storage => :s3,
    :bucket => ENV['S3_BUCKET_NAME'] || 'x', # TODO: config this
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'] || 'x', # TODO: config this
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] || 'x' # TODO: config this
    }
  
  before_file_post_process :allow_only_images

  def allow_only_images
    if !(file.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      return false
    end
  end 

  def is_image?
    IMGTYPE.include?(file.content_type)
  end

  def has_preview?
    preview && preview.assets.any?
  end
  
  def preview_file
    if has_preview?
      preview.assets.first.file
    end
  end

  def to_bhf_s
    "ID: #{id} - Name: #{file_file_name}"
  end
  
  private
    def set_last_position
      self.position = Asset.where(fileable_id: self.fileable_id).count+1
    end
  
end