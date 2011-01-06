class CreateExpenseCategories < ActiveRecord::Migration
  def self.up
    create_table :expense_categories do |t|
      t.string :name
      t.string :slug
    end
  end

  def self.down
    drop_table :expense_categories
  end
end
