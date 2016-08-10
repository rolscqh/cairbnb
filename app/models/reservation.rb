class Reservation < ActiveRecord::Base

	belongs_to :user
  	belongs_to :room
  	has_many :payments, dependent: :destroy

end
