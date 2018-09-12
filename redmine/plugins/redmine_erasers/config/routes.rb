RedmineApp::Application.routes.draw do
  resources :erasers, :only => [:create, :destroy] do
    collection { put :autosave }
    member { put :restore }
  end
end
