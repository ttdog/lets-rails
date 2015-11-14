class User < ActiveRecord::Base
  has_many :preferred_dates
end
