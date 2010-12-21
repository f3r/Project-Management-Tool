class AddStatusToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :status_id, :integer
  end

  def self.down
    remove_column :jobs, :status_id
  end
end
