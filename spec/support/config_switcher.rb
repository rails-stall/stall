module ConfigSwitcher
  # Allows switching a "config" for the duration of the given block.
  #
  # This allows setting global configs to a given value and restoring it after
  # the test is executed, to avoid modifying global state of the app during a
  # specific test
  #
  # The method tries to be as smart as posible to set the config and to restore
  # the original config, this means that it will try :
  #
  #   For setting the config :
  #     - To assign with Target.config=(value)
  #     - Or with Target.config(value)
  #
  #   For resetting the original config :
  #     - To assign with Target.config=(original)
  #     - Or with Target.config(original)
  #     - Or to set the Target's @config to `original`
  #
  # Usage :
  #
  #   # For updating a global Stall.config param
  #   with_config :vat_rate, 0 do
  #     # Here Stall.config.vat_rate == 0
  #   end
  #
  #   # For updating a given object's param
  #   with_config MyObject, :config, false do
  #     # Here MyObject.config == false
  #   end
  #
  #   # If the config to set must be a block, you can pass a proc as the last argument
  #   # in place of a
  #   with_config MyObject, :is_nil, ->(value) { value == nil } do
  #     # Here MyObject.is_nil returns the given lambda
  #   end
  #
  def with_config(target, config, value = nil, &block)
    unless value
      value = config
      config = target
      target = Stall.config
    end

    original = target.send(config)
    assignation_method = target.respond_to?(:"#{ config }=") ? :"#{ config }=" : config

    if value.kind_of?(Proc)
      target.send(assignation_method, &value)
    else
      target.send(assignation_method, value)
    end

    block.call

    if original.kind_of?(Proc)
      target.send(assignation_method, &original)
    else
      if value.kind_of?(Proc) && (assignation_method == config)
        target.instance_variable_set(:"@#{ config }", original)
      else
        target.send(assignation_method, original)
      end
    end
  end
end
