class ExpenseCategory < ActiveRecord::Base
  has_many :expensereports, :dependent => :destroy
  validates_uniqueness_of :name, :slug
end
