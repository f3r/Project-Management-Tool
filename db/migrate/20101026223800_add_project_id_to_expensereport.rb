class AddProjectIdToExpensereport < ActiveRecord::Migration
  def self.up
    add_column :expensereports, :project_id, :integer
  end

  def self.down
    remove_column :expensereports, :project_id
  end
end
