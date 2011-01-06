class ExpenseCategory < ActiveRecord::Base
  has_many :expensereports
end
