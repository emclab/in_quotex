Rails.application.routes.draw do

  mount InQuotex::Engine => "/in_quotex"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount InitEventTaskx::Engine => '/init_event_task'
  mount Supplierx::Engine => '/supplierx'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount Searchx::Engine => '/search'
  mount ExtConstructionProjectx::Engine => '/project'
  mount EventTaskx::Engine => '/event_task'
  mount Kustomerx::Engine => '/customer'
  
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
