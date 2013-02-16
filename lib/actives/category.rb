module Kiosk
  module Category
    extend ActiveSupport::Concern

    included do
      self.table_name = 'categories'
      has_many :posts

      validates_length_of :title, :minimum => 3
    end

  end
end
