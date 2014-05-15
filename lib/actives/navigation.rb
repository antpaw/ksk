module Ksk
  module Navigation
    extend ActiveSupport::Concern

    included do
      self.table_name = 'navigations'
      validates_uniqueness_of :slug
      validates_presence_of :static

      before_validation :static_setter

      default_scope -> {order 'position ASC, created_at DESC'}

      belongs_to :static
      belongs_to :navigation_type
      belongs_to :parent, foreign_key: 'parent_id', class_name: 'Navigation'
      has_many   :children, foreign_key: 'parent_id', class_name: 'Navigation', dependent: :delete_all

      scope :top_level, -> {where(parent_id: 0)}

      scope :not_hidden, -> {where(hidden: false)}

      before_save :set_slug, :set_link
    end


    def set_slug
      return if !slug.blank?
      write_attribute(:slug, title.to_url)
    end

    def static_setter
      write_attribute(:static_id, (self.static && self.static.id) || ::Static.all.first.id)
    end

    def set_link
      write_attribute(:link, get_link)
    end

    def get_link(x = '')
      a = '/'+slug+x
      if parent
        a = parent.get_link(a)
      end
      a
    end
    
    module ClassMethods
      def sort_items(ids)
        ids.each_pair do |i, id|
          find(id).update_attribute(:position, i.to_i)
        end
      end

      def show_bread_crum_desc(navi)
        a = [navi]
        if navi.parent
          a << show_bread_crum_desc(navi.parent)
        end
        a.flatten
      end

      def show_bread_crum(navi)
        show_bread_crum_desc(navi).reverse
      end
    end
    
  end
end
