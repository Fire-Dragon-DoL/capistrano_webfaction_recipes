require 'rails'
require 'active_support/all'

module Webfaction
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      desc "Creates a deploy file that is well organized and makes easy webfaction task usage"

      def copy_deploy
        target_file = 'config/deploy.rb'
        if File.exists?(target_file)
          unless yes?('Deploy file already exists and will be overwritten, would you like to continue?')
            puts 'Operation aborted'
            return
          end
          remove_file(target_file)
        end
        @rails_app_root_dir_name        = File.basename(Dir.pwd)
        @server_ssh_user                = ask('Insert your server ssh username')
        @server_ssh_user                = 'PUT_SERVER_SSH_USER' if @server_ssh_user.blank?
        @remote_rails_app_root_dir_name = ask('Insert your remote rails application root directory name')
        @remote_rails_app_root_dir_name = 'PUT_REMOTE_RAILS_APP_ROOT_DIR_NAME' if @remote_rails_app_root_dir_name.blank?
        @bitbucket_user                 = ask('Insert your bitbucket username')
        @bitbucket_user                 = 'PUT_BITBUCKET_USER' if @bitbucket_user.blank?
        template "deploy.rb.erb", target_file
      end

    end
  end
end