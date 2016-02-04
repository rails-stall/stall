module Stall
  class ModelGenerator < ::Rails::Generators::NamedBase
    class ModelModelNotFound < StandardError; end

    MODELS_DIR = File.expand_path('../../../../../app/models', __FILE__)
    source_root MODELS_DIR

    def copy_model_template
      if File.exist?(source_path)
        template source_path, "app/models/#{ file_path_with_ext }"
      else
        raise ModelModelNotFound,
              "Could not find any stall model for #{ class_name }"
      end
    end

    private

    def source_path
      @source_path ||= File.join(MODELS_DIR, file_path_with_ext)
    end

    def file_path_with_ext
      @file_path_with_ext ||= "#{ file_path }.rb"
    end
  end
end
