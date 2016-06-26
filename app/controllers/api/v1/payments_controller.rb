class Api::V1::PaymentsController < ApiController
  def index
    respond_with Loan.find(params[:loan_id]).payments
  end

  def show
    payments = Loan.find(params[:loan_id]).payments
    respond_with payments.find(params[:id])
  end

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
