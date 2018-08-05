# source 'https://rubygems.org'
source 'https://gems.ruby-china.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'

gem 'rake', '~> 12.3.1'
gem 'mysql2', '0.3.20'
gem 'activerecord-import'
gem 'redis', '~> 3.2'
gem 'redis-namespace'
gem 'redis-objects'
gem 'redis-rails'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# api
gem 'grape', '~> 0.19.2'
gem 'grape-entity', '~> 0.6.1'
gem 'grape-swagger', '0.27.1'
gem 'grape-swagger-entity'
gem 'grape-swagger-representable'
gem 'grape_logging'
gem 'will_paginate', '~> 3.1.0'
gem 'rack-cors', :require => 'rack/cors'


#sidekiq
gem 'sidekiq'

# config
gem 'config'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

#requests
gem 'typhoeus'


group :development, :test do
  gem 'byebug', platform: :mri
  gem 'database_cleaner'
  gem 'timecop'
  gem 'awesome_print'
  gem 'faker'
  gem 'foreman'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'pry'
end

group :production, :staging, :testing do
  gem 'puma', '~> 3.9.0'
end

group :development do
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma'
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', require: false
  gem 'rest-client'
end
