require 'bundler/capistrano'
require 'torquebox-capistrano-support'

server "10.10.10.11", :web, :app, :db, primary: true

set :application,       "torquebox_rails_sample"
set :user,              "torquebox"
set :deploy_to,         "/home/#{user}/apps/#{application}"
set :deploy_via,        :remote_cache
set :use_sudo,          false

set :scm,               :git
set :repository,        "git@github.com:jfturcot/#{application}.git"
set :branch,            "master"
set :scm_verbose,       true

set :torquebox_home,    "/opt/torquebox/current"
set :rails_env,         "production"

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

