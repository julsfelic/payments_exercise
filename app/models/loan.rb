class Loan < ActiveRecord::Base
  has_many :payments

  def outstanding_balance
    funded_amount - payments.sum(:amount)
  end

  def payment_under_balance?(payment)
    if payment.amount.to_f > outstanding_balance
      payment.errors.add(:amount, 'cannot exceed outstanding loan balance')
      return false
    end
    true
  end
end
