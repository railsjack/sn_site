source 'http://rubygems.org'
#source 'http://ruby.taobao.org'
ruby '2.6.0'
#gem 'rails', '4.2.8'

#https://stackoverflow.com/questions/32457657/rails-4-gemloaderror-specified-mysql2-for-database-adapter-but-the-gem-i
gem 'rails', '~> 4.2.4', git: "https://github.com/rails/rails.git", branch: '4-2-stable'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw] #-> Rails 4.1+

gem 'mysql2'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'devise'
gem 'pundit'
gem 'simple_form'
gem 'country_select'
gem 'will_paginate', '~> 3.0.pre2'
gem 'gmaps4rails'
gem 'underscore-rails'
gem 'rack-cors'
gem 'haml-rails'
gem 'twitter-typeahead-rails'
gem 'twilio-ruby', '~> 4.2.0'
gem 'paperclip'
gem 'geokit'
gem 'color', '~> 1.7.1'
gem 'geocoder', '~> 1.2.8'
gem 'gcm', '~> 0.1.0'
gem 'apns'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'select2-rails', '~> 3.5.9.3'
gem 'time_difference', '~> 0.4.2'
gem 'slim-rails', '~> 3.0.1'
gem 'sidekiq-failures'
gem 'sinatra', require: false
gem 'redis', '~> 3.2.1'
gem 'roo'
gem 'roo-xls', '~> 1.0.0'
gem 'iconv', '~> 1.0.3'
gem 'sidekiq', '~> 3.1.0'
gem 'cocoon', '~> 1.2.6'
gem 'cancancan', '~> 1.12.0'
gem 'audited', '~> 4.2.0'
gem 'audited-activerecord', '~> 4.0'
gem 'paranoia', '~> 2.1.3'
gem 'paranoia_uniqueness_validator', '~> 1.1.0'
gem 'pry', '~> 0.10.1'
gem 'whenever', '~> 0.9.4'
gem 'jquery-ui-rails'

# Uploading Files through JS requests
gem 'remotipart', '~> 1.2'

# Letter sending service
gem 'lob'

group :development do
  gem 'better_errors', '~> 1.1.0'
  #gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'binding_of_caller'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'annotate'
  # For deployment
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-sidekiq'
  gem 'capistrano-passenger'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :production do
  gem 'unicorn'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
end
