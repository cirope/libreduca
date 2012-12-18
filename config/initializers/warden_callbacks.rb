Warden::Manager.after_set_user(except: :fetch) do |record, warden, options|
  Login.create!(
    ip: warden.request.ip,
    user_agent: warden.request.user_agent,
    user_id: record.id
  )
end


Warden::Manager.before_failure do |env, opts|
  path = opts[:attempted_path]
  request = ::Rack::Request.new(env)
  port = request.port
  protocol = port == 443 ? 'https' : 'http'
  full_host = "#{protocol}://#{request.host}"

  full_host += ":#{port}" if port != 80 && port != 443
  opts.merge!(:attempted_path => "#{full_host}#{path}")
end
