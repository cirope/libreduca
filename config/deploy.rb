set :application, 'libreduca.com'
set :user, 'deployer'
set :repo_url, 'git://github.com/cirope/libreduca.git'

set :format, :pretty
set :log_level, :info

set :deploy_to, "/var/www/#{fetch(:application)}"
set :deploy_via, :remote_cache
set :scm, :git

set :linked_files, %w{config/database.yml config/app_config.yml}
set :linked_dirs, %w{log private public/system}

set :rbenv_type, :user
set :rbenv_ruby, '2.1.0'

set :keep_releases, 5

namespace :deploy do
  after :finishing, 'deploy:cleanup'
end
