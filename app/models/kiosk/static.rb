class Static < ActiveRecord::Base

  include Apdown
  
  has_one :navigation
  has_many :assets, :as => :fileable
  
  accepts_nested_attributes_for :assets, allow_destroy: true
  
    
  def apdown_text
    content.to_s+' '+contacts.to_s
  end
  
  def apdown_preselect
    [1] if banner_image?
  end
  
end
