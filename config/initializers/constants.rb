DB_ADAPTER = ActiveRecord::Base.connection.adapter_name
PRIVATE_PATH = Pathname.new("#{Rails.root}/private")
RESERVED_SUBDOMAINS = ['admin', 'avatars', 'www']
SCORE_SUCCESS_THRESHOLD = 90.0
SCORE_FAIL_THRESHOLD = 70.0
