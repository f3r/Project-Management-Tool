class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name

      t.timestamps
    end
    Status.create(:name => 'Not started')
    Status.create(:name => 'Started')
    Status.create(:name => 'Finished')
  end

  def self.down
    drop_table :statuses
  end
end
