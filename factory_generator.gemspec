# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "factory_generator"
  spec.version       = FactoryGenerator::VERSION
  spec.authors       = ["GustavoCaso"]
  spec.email         = ["gustavocaso@gmail.com"]
  spec.summary       = %q{Easy generator to save time when creating them}
  spec.description   = %q{With this gem you will save time creating factory model,
                          with different options you will be able to create a full compatible
                          factory tree from your database
                          }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "activerecord", "~> 4.0.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
