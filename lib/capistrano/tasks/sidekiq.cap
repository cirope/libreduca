namespace :sidekiq do
  desc 'Start sidekiq workers'
  task :start do
    on roles(:app) do
      sudo 'systemctl start sidekiq'
    end
  end

  desc 'Stop sidekiq workers'
  task :stop do
    on roles(:app) do
      sudo 'systemctl stop sidekiq'
    end
  end

  desc 'Quiet Sidekiq workers and stop accepting jobs'
  task :quiet do
    on roles(:app) do
      sudo 'systemctl reload sidekiq'
    end
  end

  desc 'Restart sidekiq workers'
  task :restart do
    on roles(:app) do
      sudo 'systemctl restart sidekiq'
    end
  end
end
