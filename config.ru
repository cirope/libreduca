#\ -s puma -p 3000

require ::File.expand_path('../config/environment',  __FILE__)
run Libreduca::Application
