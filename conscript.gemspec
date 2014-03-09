$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "conscript/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "conscript"
  s.version     = Conscript::VERSION
  s.authors     = ["Maciej Kocyła"]
  s.email       = ["maciej.kocyla@gmail.com"]
  s.summary     = "gem creating basic users and authentication method"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"

  s.add_development_dependency "sqlite3"
end
