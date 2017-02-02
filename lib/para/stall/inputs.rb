module Para
  module Stall
    module Inputs
      extend ActiveSupport::Autoload

      autoload :VariantInputHelper
      autoload :VariantsMatrixInput
      autoload :VariantSelectInput
    end
  end
end

SimpleForm.custom_inputs_namespaces << 'Para::Stall::Inputs'
