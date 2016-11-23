module Stall
  class ViewGenerator < ::Rails::Generators::Base
    class ViewNotFound < StandardError; end

    VIEWS_DIR = File.expand_path('../../../../../app/views', __FILE__)
    source_root VIEWS_DIR

    argument :file_paths, type: :array, required: true

    def copy_view_template
      paths = file_paths.map do |file_path|
        source_path = source_path_for(file_path)
        raise ViewNotFound, "Could not find any stall view for #{ file_path }" unless File.exist?(source_path)
        target_path = "app/views/#{ file_path_with_ext_for(file_path) }"

        [source_path, target_path]
      end

      paths.each do |source_path, target_path|
        template(source_path, target_path)
      end
    end

    private

    def source_path_for(file_path)
      @source_path ||= File.join(VIEWS_DIR, file_path_with_ext_for(file_path))
    end

    def file_path_with_ext_for(file_path)
      @file_path_with_ext ||= if file_path.match(/\.html\.haml\z/)
        file_path
      else
        "#{ file_path }.html.haml"
      end
    end
  end
end
