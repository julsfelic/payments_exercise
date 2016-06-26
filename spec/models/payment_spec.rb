require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { Payment.create(amount: '10000.00') }

  it { should belong_to(:loan) }
  it { should allow_value(10_000.00).for(:amount) }
  it { should_not allow_value(10_000.456).for(:amount) }
  it { should validate_numericality_of(:amount) }
  it { should validate_presence_of(:amount) }

  it 'should write amount as a decimal' do
    expect(payment.amount).to eq 10_000.00
  end

  it 'should have a human readable payment date upon creation' do
    expect(payment.payment_date).to eq Time.now.strftime('%B %d, %Y')
  end
end
