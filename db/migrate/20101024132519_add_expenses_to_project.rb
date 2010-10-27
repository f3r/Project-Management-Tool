class AddExpensesToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :date_start, :date
    add_column :projects, :date_end,   :date
  end

  def self.down
    remove_column :projects, :date_start
    remove_column :projects, :date_end
  end
end
