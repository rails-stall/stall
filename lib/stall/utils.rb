module Stall
  module Utils
    extend ActiveSupport::Autoload

    autoload :ConfigDSL

    class << self
      def try_load_constant(name)
        begin
          name.constantize
        rescue NameError
          begin
            require name.underscore
            name.constantize
          rescue LoadError, NameError => e
            nil
          end
        end
      end
    end
  end
end
