module Ksk::Category
  extend ActiveSupport::Concern

  included do
    has_many :posts

    validates_length_of :title, minimum: 3
  end

end
