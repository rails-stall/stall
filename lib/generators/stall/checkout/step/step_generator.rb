module Stall
  module Checkout
    class StepGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def copy_step_template
        template 'step.rb.erb', "lib/#{ file_path }.rb"
      end

      def create_view_template
        template 'step.html.haml.erb', "app/views/checkout/steps/_#{ base_file_name }.html.haml"
      end

      private

      # Override provided file name to include checkout_wizard at the end and
      # allow every NamedBase helpers to use that name
      #
      def file_name
        @_file_name ||= [@file_name, 'checkout_step'].join('_')
      end

      def base_file_name
        @file_name
      end
    end
  end
end
