InQuotex::Engine.routes.draw do
  resources :quotes do
    collection do
      get :search
      get :search_results
      #get :stats
      #put :stats_results    
    end
#=begin
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('quote_wf_route', 'in_quotex')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?  #for rsepc. routes loaded before FactoryGirl.
      member do
        get :event_action
        put :accept
        put :reject
        put :submit
      end
      
      collection do
        get :list_open_process
      end
    end
#=end    
  end

  root :to => 'quotes#index'
end
