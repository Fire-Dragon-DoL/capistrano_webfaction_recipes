require 'bundler/capistrano'
load 'capistrano_webfaction_recipes/recipes'

# Webfaction settings
set :application,           '%rails_root_dir_name%'
set :user,                  '%ssh_user%'
set :branch,                :master
set :ssh_options,           { forward_agent: true }
set :app_short,             '%remote_rails_root_dir_name%'
set :external_assets_path,  []
set :local_gemfile_path,    File.expand_path('../../Gemfile', __FILE__)
set :bitbucket,             '%bitbucket_user%'
set :uploaded_assets_paths, []

# Calculated options
# logger.level              = Capistrano::Logger::INFO
default_run_options[:pty] = true

set(:repository)   { "git@bitbucket.org:#{fetch(:bitbucket)}/#{fetch(:application)}.git" }
set(:deploy_to)    { "/home/#{fetch(:user)}/webapps/#{fetch(:app_short)}" }
set(:scm_username) { fetch(:user) }

set :deploy_via,          :remote_cache

set :stages,              %w(production staging)
set :default_stage,       'production'
require                   'capistrano/ext/multistage'

set :scm,                 :git
set :migrate_env,         '' # Not using :production because of a capistrano issue
set :bundle_without,      [:development, :test]
set :use_sudo,            false
set(:default_environment) do
  {
    'RAILS_ENV' => fetch(:migrate_env).to_s,
    'PATH'      => "#{fetch(:deploy_to)}/bin:$PATH",
    'GEM_HOME'  => "#{fetch(:deploy_to)}/gems",
    'RUBYLIB'   => "#{fetch(:deploy_to)}/lib"
  }
end
if exists?(:uploaded_assets_paths)
  set(:shared_children, []) unless exists?(:shared_children)
  set(:shared_children, fetch(:shared_children) + fetch(:uploaded_assets_paths))
end

server "#{fetch(:user)}.webfactional.com", :web, :app, :db, primary: true