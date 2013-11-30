CarrierWave.configure do |config|
  config.root = Rails.root
  config.enable_processing = !Rails.env.test?
end
