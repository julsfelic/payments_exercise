class Api::V1::PaymentsController < ApiController
  def create
    loan = Loan.find(params[:loan_id])
    respond_with loan.payments.create(payment_params), location: nil
  end

  private

  def payment_params
    params.require(:payment).permit(:amount)
  end
end
