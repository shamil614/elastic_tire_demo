class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :bio
  has_many :posts


  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
