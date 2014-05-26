require 'stringex'

module Ksk
  class Engine < Rails::Engine
    
    isolate_namespace Ksk
    
    config.bhf.css << 'ksk/application'
    config.bhf.js << 'ksk/application'
    
    initializer 'ksk.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Ksk::FrontendHelper
      end
    end
    
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
require 'paperclip/processor'
require 'paperclip_processors/ksk_crop'
