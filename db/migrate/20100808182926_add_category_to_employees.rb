class AddCategoryToEmployees < ActiveRecord::Migration
  def self.up
      add_column :employees, :category_id, :integer
  end

  def self.down
      remove_column :employees, :category_id 
  end
end
