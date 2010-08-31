class Job < ActiveRecord::Base
    # Validations
    validates_presence_of :name, :description, :project_id

    # Relationships
    belongs_to  :employee
    belongs_to  :project

    #TODO Add that Job has_one :status

end
