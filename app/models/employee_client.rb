class EmployeeClient < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
end
