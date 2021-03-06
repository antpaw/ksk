module Ksk::Preview
  extend ActiveSupport::Concern

  included do
    belongs_to :asset
    has_many :assets, :as => :fileable

    accepts_nested_attributes_for :assets, allow_destroy: true

    validates_presence_of :asset_id
  end


  def file_assets
    assets.only_data_files
  end
  
      
end
