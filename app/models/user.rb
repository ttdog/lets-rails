class User < ActiveRecord::Base
  has_many :preferred_dates
  has_many :user_friends
end
