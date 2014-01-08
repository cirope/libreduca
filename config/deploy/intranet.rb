set :stage, :production
set :rails_env, 'production'
set :branch, 'intranet'

role :all, %w{10.241.161.239}
#role :web, %w{10.1.74.148}
#role :app, %w{10.241.161.239}
#role :db,  %w{10.241.161.241}

server '10.241.161.239', user: 'deployer', roles: %w{web app db}
