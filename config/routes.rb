InQuotex::Engine.routes.draw do
  resources :quotes do
    #workflow_routes = Authentify::AuthentifyUtility.find_config_const('workflow_routes', 'in_quotex')
    #eval(workflow_routes) if workflow_routes.present?
    member do
      get :event_action
      put :accept
      put :reject
      put :submit
    end
  end

  root :to => 'quotes#index'
end
