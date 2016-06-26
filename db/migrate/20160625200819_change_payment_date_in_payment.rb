class ChangePaymentDateInPayment < ActiveRecord::Migration
  def change
    change_column :payments, :payment_date, :text
  end
end
