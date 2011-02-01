class ChangeEmployeeClientColumnType < ActiveRecord::Migration
  def self.up
    change_column :employee_clients, :employee_id, :integer
    change_column :employee_clients, :client_id, :integer
  end

  def self.down
    change_column :employee_clients, :client_id, :string
    change_column :employee_clients, :employee_id, :string
  end
end
