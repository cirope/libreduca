#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

X0Y0::Application.load_tasks

namespace :routes do
  desc 'Writes doc/routes.html. Requires Graphviz'
  task visualizer: :environment do
    FileUtils.mkdir_p 'doc'

    File.open(Rails.root.join('doc', 'routes.html'), 'w') do |f|
      f << Rails.application.routes.router.visualizer
    end
  end
end
