InQuotex::Engine.routes.draw do
  resources :quotes do
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('quote_workflow_routes', 'in_quotex')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    else
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
    
  end

  root :to => 'quotes#index'
end
