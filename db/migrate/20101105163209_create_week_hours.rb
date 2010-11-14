class CreateWeekHours < ActiveRecord::Migration
  def self.up
    create_table :week_hours do |t|
      t.integer  :year
      t.integer  :week
      t.integer  :job_id
      t.float    :h_mon, :default => 0
      t.float    :h_tue, :default => 0
      t.float    :h_wed, :default => 0
      t.float    :h_thu, :default => 0
      t.float    :h_fri, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :week_hours
  end
end
