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

  s.add_dependency 'rails', '~> 4.2'
  s.add_dependency 'pg'
  s.add_dependency 'haml-rails'
  s.add_dependency 'simple_form'
  s.add_dependency 'has_secure_token', '~> 1.0'
  s.add_dependency 'vertebra'

  s.add_development_dependency 'rspec-rails'
end
