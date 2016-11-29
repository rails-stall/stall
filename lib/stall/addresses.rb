module Stall
  module Addresses
    extend ActiveSupport::Autoload

    autoload :CopierBase
    autoload :Copy
    autoload :CopySourceToTarget
    autoload :PrefillTargetFromSource
  end
end
