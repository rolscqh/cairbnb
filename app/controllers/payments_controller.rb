class PaymentsController < ApplicationController
	def new
		@reservation = Reservation.find(params[:reservation_id])
	  @client_token = Braintree::ClientToken.generate
	end

	def create
		
	  @reservation = Reservation.find(params[:reservation_id])
	  nonce = params[:payment_method_nonce]
	  @room = @reservation.room
	  render action: :new and return unless nonce
	  result = Braintree::Transaction.sale(
	    amount: @reservation.total,
	    payment_method_nonce: nonce
	  )

	  if result.success?
	  flash[:notice] = "Payment successful"
	  @payment = current_user.payments.create(reservation_id: @reservation.id, braintree: result.transaction.id)
	  redirect_to your_reservations_path
	  else
	  	flash[:alert] = "Something is amiss. Please try again" 
	  	@reservation.destroy
	  	redirect_to room_path(@room)
	  end
	  
	end

	private
		def payment_params
				params.require(:payment).permit(:user_id, :reservation_id, :braintree)
		end

end

