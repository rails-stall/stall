module ConfigSwitcher
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
      target.send(assignation_method, original)
    end
  end
end
