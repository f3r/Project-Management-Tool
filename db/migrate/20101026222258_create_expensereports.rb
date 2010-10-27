class CreateExpensereports < ActiveRecord::Migration
  def self.up
    create_table :expensereports do |t|
      t.integer :job_id
      t.integer :employee_id
      t.decimal :amount
      t.date :expenseDate

      t.timestamps
    end
  end

  def self.down
    drop_table :expensereports
  end
end
