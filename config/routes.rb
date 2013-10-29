unless Bhf::Engine.config.remove_default_routes
  Rails.application.routes.draw(&Ksk::Engine.config.ksk_routes)
end