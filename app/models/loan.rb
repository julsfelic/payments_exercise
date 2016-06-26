class Loan < ActiveRecord::Base
  has_many :payments

  def outstanding_balance
    funded_amount - payments.sum(:amount)
  end

  def payment_under_balance?(payment)
    if payment.amount.nil? || payment.amount > outstanding_balance
      payment.errors.add(:amount, 'cannot exceed outstanding loan balance')
      return false
    end
    true
  end
end
