Rails.application.routes.draw do
  devise_for :users

  mount(ApiRoot, at: ApiRoot::PREFIX)
end