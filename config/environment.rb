# Be sure to restart your server when you modify this file

RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'aws-s3', :lib => 'aws/s3'
  config.gem 'uuidtools', :version => '2.1.1'
  config.gem 'paperclip', :version => '2.3.3'
  config.gem 'validates_timeliness', :version => '2.3'
  config.gem 'declarative_authorization', :version => '0.5.1'
  config.gem 'right_aws', :version => '2.0.0'
  config.gem 'uuidtools', :version => '2.1.1'

  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  CATEGORY_ADMIN = 27

  #Form Elements Options
  TEXT_FIELD_SIZE_MINI = 10
  TEXT_FIELD_SIZE = 30
  TEXT_FIELD_MAX_LENGTH = 70
  TEXT_FIELD_MAX_LENGTH_LONG = 250 
  TEXT_AREA_ROWS = 10
  TEXT_AREA_COLS_LONG = 80
  TEXT_AREA_COLS = 30  
  
  # Default results per page
  DEFAULT_PER_PAGE = 20
end
