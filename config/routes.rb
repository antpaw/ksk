Kiosk::Application.routes.draw do
  
  get 'admin', to: 'admin#login', as: :admin
  get 'admin/sort_navi', to: 'admin#sort_navi',  as: :admin_sort_navi
  get 'admin/create_navi', to: 'admin#create_navi',  as: :admin_create_navi
  
end
