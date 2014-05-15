module Ksk
  module Static
    extend ActiveSupport::Concern

    included do
      self.table_name = 'statics'

      include Apdown

      has_one :navigation
      has_many :assets, as: :fileable
      # TODO: needs on_delete hook to destroy navigation if Navigation is availible for this object

      accepts_nested_attributes_for :assets, allow_destroy: true
    end

  end
end
