Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/history', to: 'static_pages#history'
  get '/illust', to: 'static_pages#illust'
  get '/other', to: 'static_pages#other'
  get '/special', to: 'static_pages#special'
  get '/downloadpdf/download', to: 'static_pages#downloadpdf'

  post '/ajax', to: 'static_pages#ajax'

end
