$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'stall/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'stall'
  s.version     = Stall::VERSION
  s.authors     = ['vala']
  s.email       = ['vala@glyph.fr']
  s.homepage    = 'https://github.com/glyph-fr/stall'
  s.summary     = 'Rails e-commerce framework'
  s.description = 'Rails e-commerce framework'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 4.2', '<= 6.0'
  s.add_dependency 'coffee-rails', '~> 4.0'
  s.add_dependency 'pg', '~> 0.16'
  s.add_dependency 'haml-rails', '~> 0.1'
  s.add_dependency 'simple_form', '~> 3.0'
  s.add_dependency 'has_secure_token', '~> 1.0'
  s.add_dependency 'vertebra', '~> 0.1'
  s.add_dependency 'money-rails', '~> 1.6'
  s.add_dependency 'request_store', '~> 1.3'
  s.add_dependency 'country_select', '~> 2.0'
  s.add_dependency 'cocoon', '~> 1.0'
  s.add_dependency 'deep_merge', '~> 1.1'
  s.add_dependency 'closure_tree', '~> 6.2'
  s.add_dependency 'para'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers', '~> 3.0'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'database_cleaner', '~> 1.5'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'rubocop', '~> 0.36.0'
  s.add_development_dependency 'codeclimate-test-reporter'
end
