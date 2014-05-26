module Ksk
  module Post
    extend ActiveSupport::Concern

    included do
      self.table_name = 'posts'

      include Apdown

      belongs_to :category
      has_many :assets, as: :fileable
      accepts_nested_attributes_for :assets, allow_destroy: true

      scope :all_posts, -> {except(:where)}
      scope :top,       -> {where(top_news: true)}

    end


    def apdown_text
      content
    end

    def content_long
      "#{intro} #{hidden_text}"
    end

    def content_short
      intro
    end

    def intro
      split_content[0]
    end

    def hidden_text
      split_content[1]
    end

    def split_content
      return [] if read_attribute(:content).blank?
      read_attribute(:content).split('@@@')
    end

    def content_has_more?
      !hidden_text.blank?
    end

  end
end
