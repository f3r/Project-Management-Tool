class CreateWeekHours < ActiveRecord::Migration
  def self.up
    create_table :week_hours do |t|
      t.integer :year
      t.integer :week
      t.integer :job_id
      t.float :h_mon
      t.float :h_tue
      t.float :h_wed
      t.float :h_thu
      t.float :h_fri

      t.timestamps
    end
  end

  def self.down
    drop_table :week_hours
  end
end
