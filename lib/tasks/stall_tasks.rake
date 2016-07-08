# desc "Explaining what the task does"
# task :stall do
#   # Task goes here
# end

namespace :stall do
  namespace :carts do
    task clean: :environment do |task, args|
      require 'stall/carts_cleaner'

      model = (args.extras.first || 'Cart').constantize
      Stall::CartsCleaner.new(model).clean!
    end
  end
end
