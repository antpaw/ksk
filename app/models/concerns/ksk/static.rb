module Ksk::Static
  extend ActiveSupport::Concern

  included do
    has_one :navigation
    has_many :assets, as: :fileable
    # TODO: needs on_delete hook to destroy navigation if Navigation is availible for this object

    accepts_nested_attributes_for :assets, allow_destroy: true

    has_rich_text :content
  end

end
