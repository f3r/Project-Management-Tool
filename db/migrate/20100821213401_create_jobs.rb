class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string  :name
      t.text    :description
      t.integer :employee_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
