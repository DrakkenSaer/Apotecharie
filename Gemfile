source 'https://rubygems.org'

gem 'rails', '3.2.14'
gem 'bcrypt-ruby', '3.0.1'
gem 'spree', github: 'spree/spree', branch: '2-0-stable'
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '2-0-stable'
gem 'spree_i18n', github: 'spree/spree_i18n'
gem 'http_accept_language', '~> 2.0.0.pre'
gem 'routing-filter'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '2.11.0'
  # gem 'guard-rspec', '1.2.1'
  # gem 'guard-spork', '1.2.0'  
  # gem 'spork', '0.9.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "haml"
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'bootstrap-sass', '2.3.1.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', '0.7.0'
  # gem 'launchy', '2.1.0'
  # gem 'rb-fsevent', '0.9.1', :require => false
  # gem 'growl', '1.0.3'
end

group :production do
  gem 'mysql2'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'