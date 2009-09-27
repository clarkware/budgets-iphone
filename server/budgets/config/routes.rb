ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'budgets'
  map.resources :budgets, :has_many => :expenses
  map.resources :sessions, :users
    
  map.with_options(:controller => 'sessions') do |sessions|
    sessions.login  'login',  :action => 'new'
    sessions.logout 'logout', :action => 'destroy'
  end
  
  map.signup 'signup', :controller => 'users', :action => 'new'  
end
