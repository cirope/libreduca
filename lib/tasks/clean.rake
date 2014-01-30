desc 'Clear tmp, log, private, uploads and public dirs'
task :clean do
  dirs = ['tmp', 'log', 'private', 'uploads', 'public/assets', 'public/system']

  dirs.each do |dir|
    "#{Rails.root}/#{dir}".tap do |path|
      FileUtils.rm_rf Dir.glob("#{path}/*") if File.directory?(path)
    end
  end
end
