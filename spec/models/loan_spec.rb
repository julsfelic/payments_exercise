require 'rails_helper'

RSpec.describe Loan, type: :model do
  it { should have_many(:payments) }
end
