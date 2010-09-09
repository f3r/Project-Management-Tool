class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :nif
      t.string    :email
      t.string    :phone
      t.string    :mobile
      t.datetime  :join_date
      t.string    :password
      t.string    :reset_uuid
      # paperclip inherited
      t.string    :photo_file_name     # original filename
      t.string    :photo_content_type  # MIME type
      t.string    :photo_file_size     # Filesize in bytes

      t.timestamps
    end
    # fer@wadomo.com / w4d0m0
    Employee.create(
        :first_name => "admin", 
        :last_name => "admin", 
        :nif => "123456789", 
        :email => "fer@wadomo.com", 
        :password => "6b5fb18df4b219c16a57ed8bd5cde3e261ac00f5")
    
  end

  def self.down
    drop_table :employees
  end
end
