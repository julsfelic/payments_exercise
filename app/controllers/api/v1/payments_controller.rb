class Api::V1::PaymentsController < ApiController
  def create
    loan = Loan.find(params[:loan_id])
    payment = loan.payments.new(payment_params)

    if loan.payment_under_balance?(payment) && payment.save
      respond_with payment, location: nil
    else
      render json: { errors: payment.errors.full_messages }, status: :bad_request 
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:amount)
  end
end
