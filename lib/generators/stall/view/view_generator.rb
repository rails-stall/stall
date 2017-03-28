module Stall
  class ViewGenerator < ::Rails::Generators::Base
    VIEWS_DIR = File.expand_path('../../../../../app/views', __FILE__)
    source_root VIEWS_DIR

    argument :file_paths, type: :array, required: true

    def copy_view_template
      paths = file_paths.map { |file_path| ViewTemplate.new(file_path) }

      paths.each do |view_template|
        template(view_template.source_path, view_template.target_path)
      end
    end


    class ViewTemplate
      class ViewNotFound < StandardError; end

      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def source_path
        source_file_for(file_path_with_ext)
      end

      def target_path
        "app/views/#{ file_path_with_ext }"
      end

      private

      def file_path_with_ext
        return @file_path_with_ext if @file_path_with_ext
        @file_path += '.html.haml' unless file_path.match(/\.html\.haml\z/)

        partial_path = [File.dirname(file_path), File.basename(file_path)].join('/_')

        stall_file_path = ['stall', file_path].join('/')
        stall_partial_path = ['stall', partial_path].join('/')

        paths = [file_path, partial_path, stall_file_path, stall_partial_path]

        paths.each do |path|
          if File.exist?(source_path = source_file_for(path))
            @file_path_with_ext = path
            return @file_path_with_ext
          end
        end

        raise ViewNotFound, "No Stall view was found for #{ file_path } !"
      end

      def source_file_for(path)
        File.join(Stall::ViewGenerator::VIEWS_DIR, path)
      end
    end
  end
end
