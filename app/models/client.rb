class Client < ActiveRecord::Base
  using_access_control

  has_many :projects, :dependent => :destroy
  has_many :jobs, :through => :projects
  has_many :employee_clients, :dependent => :destroy
  has_many :employees, :through => :employee_clients

  validates_presence_of   :name, :cif, :email
  validates_format_of     :email, :with => /^[A-Z0-9.+_%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
  validates_uniqueness_of :email, :cif

  def self.per_page
    DEFAULT_PER_PAGE
  end

  def number_of_hours
    # ES RECOMENDABLE HACER UN CACHE DE ESTO.
    begin
      hours = 0
      for job in self.jobs do
        hours = hours + job.hours.to_i
      end
      return hours
    rescue Exception => e
      logger.error { "Error [project.rb/number_of_hours] #{e.message}" }
    end
  end

  def total_billed
    # ES RECOMENDABLE HACER UN CACHE DE ESTO.
    begin
      total = 0
      for job in self.jobs do
        total = total + job.total_billed
      end
      return total
    rescue Exception => e
      logger.error { "Error [project.rb/total_billed] #{e.message}" }
    end
  end

end