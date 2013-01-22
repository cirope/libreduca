namespace :routes do
  desc 'Writes doc/routes.html. Requires Graphviz'
  task visualizer: :environment do
    FileUtils.mkdir_p 'doc'

    File.open(Rails.root.join('doc', 'routes.html'), 'w') do |f|
      f << Rails.application.routes.router.visualizer
    end
  end
end
