class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
        t.integer :partner_id
        t.integer :manager_id
        t.integer :client_id
        t.string  :name
        t.text    :description
        t.integer :status_id    
        t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
