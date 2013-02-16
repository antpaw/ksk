unless Bhf::Engine.config.remove_default_routes
  Rails.application.routes.draw(&Kiosk::Engine.config.routes)
end