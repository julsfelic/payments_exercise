class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :amount, format: { with: /\A\d+\.?\d{0,2}\z/ }
  validates :amount, numericality: true
  validates :amount, presence: true
end
