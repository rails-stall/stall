module Stall
  class ApplicationController < Stall.config.application_controller_ancestor.constantize
    layout :_set_stall_layout

    private

    # Enforce app-level layout by defaulting to the "application" layout if
    # no parent layout was set before, thus avoiding the "stall/application"
    # layout to be rendered
    def _set_stall_layout
      parent_controller = self.class.ancestors.find do |ancestor|
        !ancestor.name.match(/^Stall::/)
      end

      parent_controller._layout ||= 'application'
    end
  end
end
