class Expensereport < ActiveRecord::Base

  belongs_to :projects
  belongs_to :employees
  belongs_to :jobs
end
