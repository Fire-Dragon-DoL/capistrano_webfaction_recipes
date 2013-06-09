require 'colored'
require 'active_support/all'
require File.expand_path("../helpers", __FILE__)

Capistrano::Configuration.instance(:must_exist).load do
  set(:log_file_path) { "#{fetch(:deploy_to)}/nginx/logs/error.log" }

  desc "String usable to print in shell for SSH variable sets"
  task :env_command do
    puts "export PATH=$PWD/bin:$PATH; export GEM_HOME=$PWD/gems; export RUBYLIB=$PWD/lib"
  end

  namespace :webapp do

    desc "Prepare webapp for capistrano deployment"
    task :prepare do
      # Replace hello_world in current
      run "cd #{fetch(:deploy_to)}; rm -rf hello_world/"
      run "cd #{fetch(:deploy_to)}/nginx/conf; sed -i 's/hello_world/current/g' nginx.conf"
    end

  end

  namespace :deploy do

    desc "Restart server"
    task :restart do
      run "#{fetch(:deploy_to)}/bin/restart"
    end

    desc "Start server"
    task :start do
      run "#{fetch(:deploy_to)}/bin/start"
    end

    desc "Stop server"
    task :stop do
      run "#{fetch(:deploy_to)}/bin/stop"
    end

    namespace :webfaction do

      desc "Setup the application, deploy it, migrate database"
      task :setup do
        webapp.prepare
        bundle.install_without_deploy
      end

      desc "Setup the application, deploy it, migrate database"
      task :full do
        webapp.prepare
        deploy.full.default
      end

    end

  end

  namespace :bundle do

    desc "Install bundle without deploy"
    task :install_without_deploy do
      if exists?(:local_gemfile_path)
        upload(fetch(:local_gemfile_path), "#{fetch(:deploy_to)}/Gemfile")
        env_to_ignore = ""
        if exists?(:bundle_without)
          env_to_ignore = " --without #{fetch(:bundle_without).join(' ')}"
        end
        run "cd #{fetch(:deploy_to)}; bundle install#{env_to_ignore}; rm -f Gemfile; rm -f Gemfile.lock" do |channel, stream, data|
          print data.to_s
        end
      else
        puts 'Requires :local_gemfile_path to be set'
      end
    end

  end

end