class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :amount, format: { with: /\A\d+\.?\d{0,2}\z/ }
  validates :amount, numericality: true
  validates :amount, presence: true

  before_save :save_payment_date

  def amount=(val)
    write_attribute :amount, val.to_f if numeric?(val)
  end

  private

  def numeric?(val)
    !!Kernel.Float(val)
  rescue TypeError, ArgumentError
    false
  end

  def save_payment_date
    write_attribute :payment_date, Time.now.strftime('%B %d, %Y')
  end
end
