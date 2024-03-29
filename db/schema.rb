# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110214012119) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.float    "hour_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "cif"
    t.string   "address"
    t.string   "fax"
    t.string   "phone"
    t.string   "mobile"
    t.string   "email"
    t.string   "website"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_clients", :force => true do |t|
    t.integer "employee_id"
    t.integer "client_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nif"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "join_date"
    t.string   "password"
    t.string   "reset_uuid"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  create_table "expense_categories", :force => true do |t|
    t.string "name"
    t.string "slug"
  end

  create_table "expensereports", :force => true do |t|
    t.integer  "job_id"
    t.integer  "employee_id"
    t.integer  "amount",              :limit => 10, :precision => 10, :scale => 0
    t.date     "expense_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "expense_category_id"
  end

  add_index "expensereports", ["employee_id"], :name => "index_expensereports_on_employee_id"
  add_index "expensereports", ["expense_category_id"], :name => "index_expensereports_on_expense_category_id"
  add_index "expensereports", ["job_id"], :name => "index_expensereports_on_job_id"
  add_index "expensereports", ["project_id"], :name => "index_expensereports_on_project_id"

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "employee_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "jobs", ["employee_id"], :name => "index_jobs_on_employee_id"
  add_index "jobs", ["project_id"], :name => "index_jobs_on_project_id"
  add_index "jobs", ["status_id"], :name => "index_jobs_on_status_id"

  create_table "projects", :force => true do |t|
    t.integer  "partner_id"
    t.integer  "manager_id"
    t.integer  "client_id"
    t.string   "name"
    t.text     "description"
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_start"
    t.date     "date_end"
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["manager_id"], :name => "index_projects_on_manager_id"
  add_index "projects", ["partner_id"], :name => "index_projects_on_partner_id"
  add_index "projects", ["status_id"], :name => "index_projects_on_status_id"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "week_hours", :force => true do |t|
    t.integer  "year"
    t.integer  "week"
    t.integer  "job_id"
    t.float    "h_mon",      :default => 0.0
    t.float    "h_tue",      :default => 0.0
    t.float    "h_wed",      :default => 0.0
    t.float    "h_thu",      :default => 0.0
    t.float    "h_fri",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "signed"
  end

  add_index "week_hours", ["job_id"], :name => "index_week_hours_on_job_id"
  add_index "week_hours", ["signed"], :name => "index_week_hours_on_signed"

end
