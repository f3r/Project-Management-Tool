class RenameExpenseDateOnExpensereport < ActiveRecord::Migration
  def self.up
    rename_column :expensereports, :expenseDate, :expense_date 
  end

  def self.down
    rename_column :expensereports, :expense_date, :expenseDate 
  end
end
