class Status < ActiveRecord::Base
  has_many :jobs
  has_many :projects
  
  def self.list
     # Rails.cache.fetch('status_list', :expires_in => 86400) { all.reverse }
     all.reverse
  end
end
