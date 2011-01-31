class CreateEmployeeClients < ActiveRecord::Migration
  def self.up
    create_table :employee_clients do |t|
      t.string :employee_id
      t.string :client_id
    end
  end

  def self.down
    drop_table :employee_clients
  end
end
