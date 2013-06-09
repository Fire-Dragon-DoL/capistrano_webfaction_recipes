require 'rails'

module CapistranoWebfactionRecipes
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a deploy file that is well organized and makes easy webfaction task usage"

      def copy_deploy
        target_file = 'config/deploy.rb'
        if File.exists?(target_file)
          return unless yes?('Deploy file already exists and will be overwritten, would you like to continue?')
          remove_file(target_file)
        end
        template "deploy.rb", target_file
      end
    end
  end
end