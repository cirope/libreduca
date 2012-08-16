require 'bundler/capistrano'
require 'sidekiq/capistrano'

set :application, 'libreduca'
set :repository,  'https://github.com/francocatena/libreduca.git'
set :deploy_to, '/var/rails/libreduca'
set :user, 'deployer'
set :group_writable, false
set :shared_children, %w(config log pids private public)
set :use_sudo, false

set :scm, :git
set :branch, 'master'

role :web, 'www.libreduca.com'
role :app, 'www.libreduca.com'
role :db, 'www.libreduca.com', primary: true

before 'deploy:finalize_update', 'deploy:create_shared_symlinks'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc 'Creates the symlinks for the shared folders'
  task :create_shared_symlinks, roles: :app, except: { no_release: true } do
    shared_paths = [['config', 'app_config.yml']]

    shared_paths.each do |path|
      shared_files_path = File.join(shared_path, *path)
      release_files_path = File.join(release_path, *path)

      run "ln -s #{shared_files_path} #{release_files_path}"
    end
  end
end
