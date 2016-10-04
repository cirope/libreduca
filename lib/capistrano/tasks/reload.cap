namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo 'systemctl reload-or-restart unicorn'
    end
  end
end
