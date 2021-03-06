class ReservationsController < ApplicationController
	before_action :authenticate_user!

	def preload
		room = Room.find(params[:room_id])
		today = Date.today
		reservations = room.reservations.where("start_date >= ? OR end_date >= ?", today, today)

		render json: reservations	
	end

	def preview
		start_date = Date.parse(params[:start_date])
		end_date = Date.parse(params[:end_date])

		output = {
			conflict: is_conflict(start_date, end_date)
		}

		render json: output
	end

	def create
		@reservation = current_user.reservations.create(reservation_params)
		ReservationMailer.reservation_email(current_user, @reservation).deliver_later
		ReservationMailer.reservation_host(@reservation, @reservation.room.user).deliver_later
		redirect_to new_reservation_payment_path(@reservation), notice: "Your reservation has been created..."
	end

	def your_trips
		@trips = current_user.reservations
	end

	def your_reservations
		@reservations = current_user.reservations
	end

	def destroy
		@reservation = Reservation.find(params[:id])
		@reservation.destroy
		redirect_to your_reservations_path
	end

	private
		def is_conflict(start_date, end_date)
			room = Room.find(params[:room_id])

			check = room.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
			check.size > 0? true : false
		end

		def reservation_params
			params.require(:reservation).permit(:start_date, :end_date, :price, :total, :room_id)
		end
end