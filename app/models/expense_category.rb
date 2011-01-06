class ExpenseCategory < ActiveRecord::Base
  has_many :expensereports
  validates_uniqueness_of :name, :slug
end
