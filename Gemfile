source "https://rubygems.org"

ruby '2.1.1'

gem 'sinatra', '~> 1.4'
gem 'sinatra-contrib'

group :development, :test do
  gem 'rspec', "~> 2.14"
  gem 'rack-test'
  gem 'webmock'
end

group :production do
  gem 'unicorn', '~> 4.8.2'
end
