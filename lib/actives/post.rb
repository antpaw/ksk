module Kiosk
  module Post
    extend ActiveSupport::Concern

    included do
      self.table_name = 'posts'

      include Apdown

      belongs_to :category
      belongs_to :event
      has_many :assets, as: :fileable
      accepts_nested_attributes_for :assets, allow_destroy: true

      default_scope order: 'created_at DESC'
      default_scope where(published: true)

      scope :all_posts,   except(:where)
      scope :top,         where(top_news: true)

      validates_length_of :headline, minimum: 3
      validates_length_of :content, minimum: 10, maximum: 5000

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
