module Stall
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_migrations
      rake 'stall_engine:install:migrations'
    end

    def copy_initializer
      copy_file 'initializer.rb', 'config/initializers/stall.rb'
    end

    def copy_default_checkout_wizard
      generate 'stall:checkout:wizard', 'default'
    end

    def mount_engine_in_routes
      say "Mounting Stall engine in routes"
      gsub_file 'config/routes.rb', /mount_stall.+\n/, ''
      route "mount_stall '/'"
    end
  end
end
