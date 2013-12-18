Ksk::Engine.routes.draw do

  resources :navigations, only: [:create] do
    put :sort, on: :collection
  end

end
