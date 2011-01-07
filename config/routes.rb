ActionController::Routing::Routes.draw do |map|

  # ADD , :shallow => true abajo
  map.resources :projects, :has_many => :jobs, :shallow => true
  map.resources :clients
  map.resources :categories, :has_many => :employees
  map.resources :employees
  map.resources :expensereports

  map.hours '/hoursreports', :controller => 'hours', :action => 'index'
  
  map.connect 'hoursreports/:year/:week/saveHours',
             :controller => 'hours',
             :action     => 'saveHours',
             :conditions => { :method => :post }
 

  map.hoursreports 'hoursreports/:year/:week',
             :controller => 'hours',
             :action     => 'index'

  map.expense_report_by_date '/expensereports/:year/:month', :controller => 'expensereports', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/, :requirements => { :method => :get }
  map.expense_report_by_employee '/expensereports/:year/:month/employee/:employee_id', :controller => 'expensereports', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/, :requirements => { :method => :get }
  map.expense_report_by_category '/expensereports/:year/:month/employee/:employee_id/category/:category', :controller => 'expensereports', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/, :requirements => { :method => :get }

  map.get_jobs '/projects/:id/get_jobs', :controller => "projects", :action => "get_jobs", :requirements => { :method => :get }

  map.root :controller => "site", :action => 'index' 

  map.forgot_password '/forgot_password', :controller =>'site', :action => 'remind'
  map.reset_password '/reset_password/:reset_code', :controller =>'site', :action => 'reset'
  map.login '/login', :controller =>'site', :action => 'login'
  map.logout '/logout', :controller =>'site', :action => 'logout'
  
  map.change_picture '/employees/:id/change_picture', :controller => 'employees', :action => 'change_picture', :requirements => { :method => :get }
  map.change_password '/employees/:id/change_password', :controller => 'employees', :action => 'change_password', :requirements => { :method => :get }

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end