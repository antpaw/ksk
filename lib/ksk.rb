require 'stringex'

module Ksk
  class Engine < Rails::Engine
    
    config.css << 'ksk/application'
    
    config.ksk_routes = lambda {
      namespace :ksk, path: Bhf::Engine.config.mount_at do
        resources :navigations, only: [:create] do
          put :sort, on: :collection
        end
      end
    }
    
  end
end

require 'apdown'
require 'actives/asset'
require 'actives/category'
require 'actives/navigation'
require 'actives/navigation_type'
require 'actives/post'
require 'actives/preview'
require 'actives/static'
