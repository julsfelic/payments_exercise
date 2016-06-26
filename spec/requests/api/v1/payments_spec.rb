require 'rails_helper'

RSpec.describe 'POST /api/v1/loans/:load_id/payments', type: :request do
  let(:loan) { Loan.create(funded_amount: 10_000.00) }

  context 'with valid data' do
    it 'creates a payment record for the specified loan' do
      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 5000.00 }

      expect(response.status).to eq 201

      parsed_response = JSON.parse(response.body)
      payment = loan.payments.last

      expect(parsed_response['id']).to eq payment.id
      expect(parsed_response['amount']).to eq '5000.0'
      expect(parsed_response['payment_date']).to eq payment.payment_date
    end
  end

  context 'with invalid data' do
    it 'should return validation errors' do
      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 'jf' }

      expect(response.status).to eq 400

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['errors']).to eq(
        [
          'Amount is invalid',
          'Amount is not a number',
          "Amount can't be blank"
        ]
      )
    end
  end

  context 'when the payment exceeds the outstanding balance of a loan' do
    it 'should return a error message' do
      post "/api/v1/loans/#{loan.id}/payments", payment: { amount: 12_000.00 }

      expect(response.status).to eq 400

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['errors'][0]).to eq 'Amount cannot exceed outstanding loan balance'
    end
  end
end

RSpec.describe 'GET /api/v1/loans/:loan_id/payments' do
  let(:loan) { Loan.create(funded_amount: 10_000.0) }

  it 'shows all payments for the specified loan' do
    first_payment = loan.payments.create(amount: 2000.0)
    second_payment = loan.payments.create(amount: 4000.0)

    get "/api/v1/loans/#{loan.id}/payments"

    expect(response.status).to eq 200

    parsed_response = JSON.parse(response.body)

    expect(parsed_response[0]['id']).to eq first_payment.id
    expect(parsed_response[0]['amount']).to eq first_payment.amount.to_s
    expect(parsed_response[0]['payment_date']).to eq first_payment.payment_date
    expect(parsed_response[1]['id']).to eq second_payment.id
    expect(parsed_response[1]['amount']).to eq second_payment.amount.to_s
    expect(parsed_response[1]['payment_date']).to eq second_payment.payment_date
  end
end

RSpec.describe 'GET /api/v1/loans/:loan_id/payments/:id' do
  let(:loan) { Loan.create(funded_amount: 10_000.0) }

  it 'shows all payments for the specified loan' do
    loan.payments.create(amount: 2000.0)
    second_payment = loan.payments.create(amount: 4000.0)

    get "/api/v1/loans/#{loan.id}/payments/#{second_payment.id}"

    expect(response.status).to eq 200

    parsed_response = JSON.parse(response.body)

    expect(parsed_response['id']).to eq second_payment.id
    expect(parsed_response['amount']).to eq second_payment.amount.to_s
    expect(parsed_response['payment_date']).to eq second_payment.payment_date
  end
end
