class PaymentsController < ApplicationController
	def new
		@reservation = Reservation.find(params[:reservation_id])
	  @client_token = Braintree::ClientToken.generate
	end

	def create
		
	  @reservation = Reservation.find(params[:reservation_id])
	  nonce = params[:payment_method_nonce]
	  render action: :new and return unless nonce
	  result = Braintree::Transaction.sale(
	    amount: @reservation.total,
	    payment_method_nonce: nonce
	  )

	  if result.success?
	  flash[:notice] = "Payment successful"
	  byebug
	  @payment = current_user.payments.create(reservation_id: @reservation.id, braintree: result.transaction.id)
	  
	  else
	  	flash[:alert] = "Something is amiss." unless result.success?
	  end
	  redirect_to your_reservations_path
	end

	private
		def payment_params
				params.require(:payment).permit(:user_id, :reservation_id, :braintree)
		end

end

