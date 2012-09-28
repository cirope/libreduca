Warden::Manager.after_set_user(except: :fetch) do |record, warden, options|
  Login.create!(
    ip: warden.request.ip,
    user_agent: warden.request.user_agent,
    user_id: record.id
  )
end
