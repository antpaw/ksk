module Ksk::Post
  extend ActiveSupport::Concern

  included do
    include Ksk::Markdown

    belongs_to :category
    has_many :assets, as: :fileable
    accepts_nested_attributes_for :assets, allow_destroy: true

    scope :all_posts, -> {except(:where)}
    scope :top,       -> {where(top_news: true)}

  end


end
