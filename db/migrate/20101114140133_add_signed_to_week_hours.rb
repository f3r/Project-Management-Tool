class AddSignedToWeekHours < ActiveRecord::Migration
  def self.up
    add_column :week_hours, :signed, :boolean    
  end

  def self.down
    remove_column :week_hours, :signed
  end
end
