module Stall
  module Addresses
    extend ActiveSupport::Autoload

    autoload :CopierBase
    autoload :CopySourceToTarget
    autoload :PrefillTargetFromSource
  end
end
