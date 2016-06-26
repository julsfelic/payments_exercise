class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.datetime :payment_date
      t.references :loan, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
