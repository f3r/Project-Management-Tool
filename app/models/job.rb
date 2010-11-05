class Job < ActiveRecord::Base
    # Validations
    validates_presence_of :name, :description, :project_id

    # Relationships
    belongs_to  :employee
    belongs_to  :project
    has_many    :expensereports
    has_many    :week_hours

    #TODO Add that Job has_one :status

    def expenses
      return Expensereport.find_all_by_job_id(self.id).sum(&:amount)
    end
end
