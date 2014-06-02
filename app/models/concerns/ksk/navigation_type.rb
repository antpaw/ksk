module Ksk::NavigationType
  extend ActiveSupport::Concern

  included do
    has_many :navigations
  end
  
end
