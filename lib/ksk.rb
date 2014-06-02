module Ksk
  class Engine < Rails::Engine
    
    isolate_namespace Ksk
    
    config.bhf.css << 'ksk/application'
    config.bhf.js << 'ksk/application'
    
    initializer 'ksk.helper' do
      ActiveSupport.on_load :action_controller do
        helper Ksk::FrontendHelper
      end
    end
    
  end
end

require 'stringex'
require 'paperclip/processor'
require 'paperclip_processors/ksk_crop'
