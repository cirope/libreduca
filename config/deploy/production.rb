set :stage, :production
set :rails_env, 'production'

role :web, %w{deployer@libreduca.com}
role :app, %w{deployer@libreduca.com}
role :db,  %w{deployer@libreduca.com}

server 'libreduca.com', user: 'deployer', roles: %w{web app db}
