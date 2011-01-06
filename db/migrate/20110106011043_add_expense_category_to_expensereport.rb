class AddExpenseCategoryToExpensereport < ActiveRecord::Migration
  def self.up
    add_column :expensereports, :expense_category_id, :integer
  end

  def self.down
    remove_column :expensereports, :expense_category_id
  end
end
