Rails.application.routes.draw do

  mount InQuotex::Engine => "/in_quotex"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount InitEventTaskx::Engine => '/init_event_task'
  mount Supplierx::Engine => '/supplierx'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount EventTaskx::Engine => '/event_task'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
