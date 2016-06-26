class LoanSerializer < ActiveModel::Serializer
  attributes :id, :funded_amount, :outstanding_balance, :created_at, :updated_at
end
