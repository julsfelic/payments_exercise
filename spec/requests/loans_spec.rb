require 'rails_helper'

RSpec.describe 'GET /loans', type: :request do
  let(:first_loan) { Loan.create(funded_amount: 5000.0) }
  let(:second_loan) { Loan.create(funded_amount: 10_000.0) }

  it 'exposes outstanding balance for loans' do
    first_loan_payment = first_loan.payments.create(amount: 2000.0)
    second_loan_payment = second_loan.payments.create(amount: 3000.0)
    first_loan_balance = first_loan.funded_amount - first_loan_payment.amount
    second_loan_balance = second_loan.funded_amount - second_loan_payment.amount

    get '/loans'

    expect(response.status).to eq 200

    parsed_response = JSON.parse(response.body)

    expect(parsed_response[0]['id']).to eq first_loan.id
    expect(parsed_response[0]['funded_amount']).to eq first_loan.funded_amount.to_s
    expect(parsed_response[0]['outstanding_balance']).to eq first_loan_balance.to_s
    expect(parsed_response[1]['id']).to eq second_loan.id
    expect(parsed_response[1]['funded_amount']).to eq second_loan.funded_amount.to_s
    expect(parsed_response[1]['outstanding_balance']).to eq second_loan_balance.to_s
  end
end
