module Stall
  class ServiceGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def store_services_folder_existence
      @services_folder_existed = File.exist?('app/services')
    end

    def copy_service_template
      template 'service.rb.erb', "app/services/#{ service_file_path }.rb"
    end

    def post_template_message
      puts "\n" +
           "Service class generated. Please add the service to the " +
           "`config.services` hash in your config/initializers/stall.rb file\n\n"

      return if @services_folder_existed

      puts " * Warning : app/services folder was just created, \n" +
           " * please restart your server to let Rails know that it should\n" +
           " * autoload this folder.\n\n"
    end

    private

    def service_class_name
      @service_class_name ||= service_file_path.camelize
    end

    def stall_service_class_name
      @stall_service_class_name ||= ['Stall', service_class_name.demodulize].join('::')
    end

    def service_file_path
      @service_file_path ||= [file_path.gsub(/service$/, ''), 'service'].join('_')
    end
  end
end
