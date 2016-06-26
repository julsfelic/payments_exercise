require 'rails_helper'

RSpec.describe Loan, type: :model do
  it { should have_many(:payments) }

  it 'calculates the outstanding_balance' do
    loan = Loan.create(funded_amount: 10_000.00)
    loan.payments.create(amount: 5000.00)
    loan.payments.create(amount: 2000.00)

    expect(loan.outstanding_balance).to eq 3000.0
  end

  it 'can check if a payment exceeds the loan' do
    loan = Loan.create(funded_amount: 10_000.00)
    payment = loan.payments.create(amount: 12_000.00)

    expect(loan.payment_under_balance?(payment)).to eq false
  end
end
