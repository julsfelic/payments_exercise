require 'rails_helper'

RSpec.describe 'POST /api/v1/loans/:load_id/payments', type: :request do
  context 'with valid data' do
    it 'creates a payment record for the specified loan' do
      loan = Loan.create(funded_amount: 10_000.00)

      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 5000.00 }

      expect(response.status).to eq 201

      parsed_response = JSON.parse(response.body)
      payment = loan.payments.last

      expect(parsed_response['id']).to eq payment.id
      expect(parsed_response['amount']).to eq '5000.0'
      expect(parsed_response['payment_date']).to eq payment.payment_date
    end
  end

  context 'when the payment exceeds the outstanding balance of a loan' do
    it 'should return a error message' do
      loan = Loan.create(funded_amount: 10_000.00)

      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 12_000.00 }

      expect(response.status).to eq 400

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['errors'][0]).to eq 'Amount cannot exceed outstanding loan balance'
    end
  end
end
