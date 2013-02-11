class Category < ActiveRecord::Base

  has_many :posts

  validates_length_of :title, :minimum => 3

end
