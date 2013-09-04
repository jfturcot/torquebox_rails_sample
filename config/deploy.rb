require 'bundler/capistrano'
require 'torquebox-capistrano-support'
require 'dotenv'
require 'dotenv/capistrano'

Dotenv.load!

server ENV['OPENSHIFT_HOST'], :web, :app, :db, primary: true

set :application,       "torquebox_rails_sample"
set :user,              ENV['OPENSHIFT_USER']
set :deploy_to,         "/var/lib/openshift/#{user}/app-root/data/apps/#{application}"
set :deploy_via,        :remote_cache
set :use_sudo,          false

set :scm,               :git
set :repository,        "git@github.com:jfturcot/#{application}.git"
set :branch,            "master"
set :scm_verbose,       true

set :torquebox_home,    "/var/lib/openshift/#{user}/app-root/data/torquebox"
set :jboss_home,        "/var/lib/openshift/#{user}/jbossas"
set :rails_env,         "production"
set :app_host,          "torquebox-rails-sample.site"

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

namespace :deploy do

  namespace :torquebox do

    task :deployment_descriptor, :except => { :no_release => true } do
      puts "creating deployment descriptor"
      dd_str = YAML.dump( create_deployment_descriptor(current_path) )
      dd_file = "#{jboss_home}/standalone/deployments/#{torquebox_app_name}-knob.yml"
      put dd_str, dd_file
    end

    task :rollback_deployment_descriptor do
      puts "rolling back deployment descriptor"
      dd_str = YAML.dump_stream( create_deployment_descriptor(previous_release) )
      dd_file = "#{jboss_home}/standalone/deployments/#{application}-knob.yml"
      put dd_str, dd_file
    end

  end

end

after "deploy", "deploy:cleanup"

