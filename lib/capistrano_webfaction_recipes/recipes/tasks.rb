require 'colored'
require 'active_support/all'
require File.expand_path("../helpers", __FILE__)

Capistrano::Configuration.instance(:must_exist).load do

  namespace :server_performance do
    desc "Get CPU and RAM usage"
    task :default do
      cpu_usage = capture("ps --no-headers -u #{fetch(:user)} -o pcpu | awk '{cpu += $1} END {print cpu}'").to_i
      ram_usage = capture("ps --no-headers -u #{fetch(:user)} -o rss | awk '{rss += $1} END {print rss}'").to_i.kilobytes
      puts "CPU usage: #{ Helpers.number_to_percentage(cpu_usage, precision: 0) }".bold
      puts "RAM usage: #{ Helpers.number_to_human_size(ram_usage) }".bold
      # run "echo CPU and RAM: `ps --no-headers -u #{fetch(:user)} -o pcpu,rss | awk '{cpu += $1; rss += $2} END {print cpu, rss}'`"
    end

    desc "Get CPU and RAM usage with process table"
    task :full do
      server_performance
      run "ps -u #{fetch(:user)} -o rss,etime,pid,command" do
        |channel, stream, data|
        print data.to_s
      end
      server_performance.default
    end
  end

  desc "Load schema from schema.rb"
  task :schema_load do
    run "cd #{fetch(:current_path)}; bundle exec rake db:schema:load RAILS_ENV=#{fetch(:rails_env)}"
  end

  desc "Seed the database"
  task :db_seed do
    run "cd #{fetch(:current_path)}; bundle exec rake db:seed RAILS_ENV=#{fetch(:rails_env)} RAILS_RAKE_TASK=1"
  end

  desc "Symlink an external assets directory, uploaded through FTP for example"
  task :external_assets_symlink do
    on_rollback do
      # Deletes the symlink
      if exists?(:external_assets_path)
        fetch(:external_assets_path).each do |external_path|
          assets_basename = File.basename(external_path)
          run "rm -rf #{fetch(:current_path)}/public/#{assets_basename}"
        end
      end
    end

    if exists?(:external_assets_path)
      fetch(:external_assets_path).each do |external_path|
        assets_basename = File.basename(external_path)
        run "rm -rf #{fetch(:current_path)}/public/#{assets_basename}"
        run "ln -s #{external_path} #{fetch(:current_path)}/public/#{assets_basename}"
      end
    else
      print "No external asset path available"
    end
  end
  after 'deploy:create_symlink', 'external_assets_symlink'

  desc "Display shell environment variables"
  task :show_env do
    if exists?(:default_environment)
      biggest_key_size = 0
      fetch(:default_environment).each do |key, value|
        str_key = key.to_s
        biggest_key_size = str_key.size if biggest_key_size < str_key.size
      end

      real_environment = {}
      fetch(:default_environment).each do |key, value|
        real_environment[key] = capture("echo $#{ key }")
      end
      real_environment.each do |key, value|
        print "#{ key }".ljust(biggest_key_size)
        puts " = #{ value }"
      end
    else
      puts "No environment set"
    end
  end

  desc "Install given gem name"
  task :gem_install do
    if exists?(:name)
      run "gem install #{fetch(:name)}" do |channel, stream, data|
        print data.to_s
      end
    else
      puts 'To install gem you must use -S name=value'
    end
  end

  namespace :logs do

    desc "Read the production log file interactively"
    task :watch do
      if exists?(:log_file_path)
        stream("tail -f #{fetch(:log_file_path)}")
      else
        print "No log_file_path set\n"
      end
    end

  end

  namespace :rake do  

    desc "Run a task on a remote server. Use it with cap rake:invoke task=task_name"
    task :invoke do
      run "cd #{fetch(:current_path)}; bundle exec rake #{ENV['task']} RAILS_ENV=#{fetch(:rails_env)} RAILS_RAKE_TASK=1"
    end

  end

  desc "Display local gemfile path"
  task :show_gemfile_path do
    puts "Local:  #{fetch(:local_gemfile_path)}".bold
    puts "Remote: #{fetch(:deploy_to)}/Gemfile".bold
  end

  # XXX: Everything is commented because the install is already implemented, while
  #      the update tasks require to setup the rails environment and other variables
  # namespace :bundle do

  #   desc "Run update with bundle"
  #   task :update do
  #     run "cd #{fetch(:current_path)}; bundle update"
  #   end

  #   desc "Run bundle install and update"
  #   task :default do
  #     bundle.install
  #     bundle.update
  #   end
  # end

  namespace :deploy do

    desc "Print paths"
    task :paths do
      puts fetch(:deploy_to).to_s
      puts fetch(:current_path).to_s
    end

    desc "Cleanup everything, deleting old releases"
    task :cleanup_all do
      set :keep_releases, 0
      cleanup
    end

    desc "Cleanup everything except last"
    task :cleanup_all_but_one do
      set :keep_releases, 1
      cleanup
    end

    # FIXME: Some recipes here are not behaving correctly
    # desc "Setup the project and loads the database"
    # task :cold do
    #   transaction do
    #     update
    #     schema_load
    #     start
    #   end
    # end

    # namespace :full do
    #   desc "Install gems, setup database with load, restart server"
    #   task :default do
    #     transaction do
    #       update
    #       bundle
    #       schema_load
    #       start
    #     end
    #   end

    #   desc "Install gems, setup database with load, seed database, restart server"
    #   task :seed do
    #     transaction do
    #       update
    #       bundle
    #       schema_load
    #       db_seed
    #       start
    #     end
    #   end

    #   desc "Run migrate instead of load"
    #   task :migrate do
    #     transaction do
    #       update
    #       bundle
    #       migrate
    #       start
    #     end
    #   end
    # end
  end

end