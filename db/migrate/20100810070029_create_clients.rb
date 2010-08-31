class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.string :cif
      t.string :address
      t.string :fax
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :website
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
