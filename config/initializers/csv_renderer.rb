autoload :CSV, 'csv'

ActionController::Renderers.add :csv do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.respond_to?(:to_csv) ? obj.to_csv : obj.to_s

  # Dear Explorer: ...
  headers['Cache-Control'] = 'max-age=1'

  send_data(
    str,
    type: Mime::CSV,
    disposition: "attachment; filename=\"#{filename}.csv\""
  )
end
