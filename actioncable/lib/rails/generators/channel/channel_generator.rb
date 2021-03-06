module Rails
  module Generators
    class ChannelGenerator < NamedBase
      source_root File.expand_path("../templates", __FILE__)

      argument :actions, type: :array, default: [], banner: "method method"

      class_option :assets, type: :boolean

      check_class_collision suffix: "Channel"

      def create_channel_file
        template "channel.rb", File.join('app/channels', class_path, "#{file_name}_channel.rb")

        if options[:assets]
          template "assets/channel.coffee", File.join('app/assets/javascripts/channels', class_path, "#{file_name}.coffee")
        end

        generate_application_cable_files
      end

      protected
        def file_name
          @_file_name ||= super.gsub(/\_channel/i, '')
        end

        # FIXME: Change these files to symlinks once RubyGems 2.5.0 is required.
        def generate_application_cable_files
          return if self.behavior != :invoke

          files = [
            'application_cable/channel.rb',
            'application_cable/connection.rb'
          ]

          files.each do |name|
            path = File.join('app/channels/', name)
            template(name, path) if !File.exist?(path)
          end
        end
    end
  end
end
