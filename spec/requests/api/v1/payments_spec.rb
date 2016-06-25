require 'rails_helper'

RSpec.describe 'POST /api/v1/loans/:id/payments', type: :request do
  context 'with valid data' do
    it 'creates a payment record for the specified loan' do
      loan = Loan.create(funded_amount: 10_000.00)

      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 5000.00 }

      expect(body.response).to eq 201

      parsed_response = JSON.parse(response.body)
      payment = loan.payments.last

      expect(parsed_response).to eq(
        payment_date: payment.payment_date,
        amount: 5000.00
      )
    end
  end
end
