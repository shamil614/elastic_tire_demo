class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :bio
  has_many :posts
  after_save { self.posts.each{ |p| p.tire.update_index } }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
