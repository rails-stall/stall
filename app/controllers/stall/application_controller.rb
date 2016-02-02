module Stall
  class ApplicationController < Stall.config.application_controller_ancestor.constantize
    before_action :_set_request_variant
    layout :_set_stall_layout

    private

    def _set_request_variant
      request.variant = :xhr if request.xhr?
    end

    # Enforce app-level layout by defaulting to the "application" layout if
    # no parent layout was set before, thus avoiding the "stall/application"
    # layout to be rendered
    def _set_stall_layout
      return false if request.xhr?

      parent_controller = self.class.ancestors.find do |ancestor|
        !ancestor.name.match(/^Stall::/)
      end

      parent_controller._layout ||= 'application'
    end
  end
end
