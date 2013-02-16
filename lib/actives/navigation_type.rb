module Kiosk
  module NavigationType
    extend ActiveSupport::Concern

    included do
      self.table_name = 'navigation_types'
      has_many :navigations
    end
    
  end
end
