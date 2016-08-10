class ReservationMailer < ApplicationMailer

	default from: "cchanxt@gmail.com"

	def reservation_email(user, reservation)
	    @user = user
	    @reservation = reservation
	    mail(to: @user.email, subject: 'confirmation of your reservation')
	  end

	def reservation_host(reservation, user)
	    @user = user
	    @reservation = reservation
	    mail(to: @user.email, subject: 'your room has been booked!')
	  end
end
