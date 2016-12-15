source 'https://rubygems.org'

ruby '2.1.10'

gem 'rails', '3.2.16'
gem 'omniauth-facebook'
gem 'oa-core'
gem 'rake', '< 11' # XXX Rails 3 のためのワークアラウンド: http://stackoverflow.com/questions/35893584/nomethoderror-undefined-method-last-comment-after-upgrading-to-rake-11

gem 'jpmobile'
gem 'eventmachine'
gem 'grape'

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'devise', '~> 3.0.0'
gem 'rails_autolink'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'ci_reporter'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end
