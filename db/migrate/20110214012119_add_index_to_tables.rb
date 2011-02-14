class AddIndexToTables < ActiveRecord::Migration
  def self.up
    add_index :expensereports, :job_id
    add_index :expensereports, :employee_id
    add_index :expensereports, :project_id
    add_index :expensereports, :expense_category_id
    add_index :jobs, :employee_id
    add_index :jobs, :project_id
    add_index :jobs, :status_id
    add_index :projects, :partner_id
    add_index :projects, :manager_id
    add_index :projects, :client_id
    add_index :projects, :status_id
    add_index :week_hours, :job_id
    add_index :week_hours, :signed
  end

  def self.down
    remove_index :expensereports, :job_id
    remove_index :expensereports, :employee_id
    remove_index :expensereports, :project_id
    remove_index :expensereports, :expense_category_id
    remove_index :jobs, :employee_id
    remove_index :jobs, :project_id
    remove_index :jobs, :status_id
    remove_index :projects, :partner_id
    remove_index :projects, :manager_id
    remove_index :projects, :client_id
    remove_index :projects, :status_id
    remove_index :week_hours, :job_id
    remove_index :week_hours, :signed
  end
end
