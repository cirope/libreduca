get '/dashboard(.:format)', to: 'dashboard#index', as: 'dashboard'

Job::TYPES.each do |job_type|
  get "/dashboard/#{job_type}(.:format)", to: "dashboard##{job_type}", as: "#{job_type}_dashboard"
end
