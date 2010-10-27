ActionController::Routing::Routes.draw do |map|

  # ADD , :shallow => true abajo
  map.resources :projects, :has_many => :jobs, :shallow => true
  map.resources :clients
  map.resources :categories, :has_many => :employees
  map.resources :employees
  map.resources :expensereports
  #map.resources :jobs

  map.root :controller => "site", :action => 'index' 

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
