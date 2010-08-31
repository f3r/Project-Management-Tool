class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.integer :level
      t.float :hour_fee
      t.timestamps
    end
    # add_index(table_name, column_names, options)
    # add_index(categories, name, {:name => "users_name_index", :unique => true})
    Category.create(:name => 'admin',       :level => '10000',  :hour_fee => '0')
    Category.create(:name => 'Partner',     :level =>  '1000',  :hour_fee => '100')
    Category.create(:name => 'Manager 3',   :level =>   '900',  :hour_fee => '90')
    Category.create(:name => 'Manager 2',   :level =>   '800',  :hour_fee => '80')
    Category.create(:name => 'Manager 1',   :level =>   '700',  :hour_fee => '70')
    Category.create(:name => 'Associate 3', :level =>   '600',  :hour_fee => '60')
    Category.create(:name => 'Associate 2', :level =>   '500',  :hour_fee => '50')
    Category.create(:name => 'Associate 1', :level =>   '400',  :hour_fee => '40')
    Category.create(:name => 'Junior 3',    :level =>   '300',  :hour_fee => '30')
    Category.create(:name => 'Junior 2',    :level =>   '200',  :hour_fee => '20')
    Category.create(:name => 'Junior 1',    :level =>   '100',  :hour_fee => '10')
  end

  def self.down
    drop_table :categories
  end
end
