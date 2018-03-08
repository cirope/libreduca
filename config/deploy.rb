set :application, 'libreduca.com'
set :user, 'deployer'
set :repo_url, 'git://github.com/cirope/libreduca.git'

set :format, :pretty
set :log_level, :info

set :deploy_to, "/var/www/#{fetch(:application)}"
set :deploy_via, :remote_cache
set :scm, :git

set :linked_files, %w{config/app_config.yml}
set :linked_dirs, %w{log private public/system tmp/pids}

set :rbenv_type, :user
set :rbenv_ruby, '2.3.6'
set :rbenv_path, "/home/#{fetch(:user)}/.rbenv"

set :keep_releases, 5

namespace :deploy do
  after :publishing, :restart
  after :finishing,  :cleanup
end

after  'deploy:published', 'sidekiq:restart'
