set :stage, :production
set :rails_env, 'production'

role :all, %w{libreduca.com}

server 'libreduca.com', user: 'deployer', roles: %w{web app db}
