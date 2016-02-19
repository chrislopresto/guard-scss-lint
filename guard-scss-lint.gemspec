# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/scss-lint/version'

Gem::Specification.new do |spec|
  spec.name          = 'guard-scss-lint'
  spec.version       = '0.0.5'
  spec.authors       = ['Chris LoPresto']
  spec.email         = ['chrislopresto@gmail.com']
  spec.summary       = %q{Guard plugin for scss-lint}
  spec.description   = %q{A Guard plugin to lint your .scss files using scss-lint}
  spec.homepage      = 'https://github.com/chrislopresto/guard-scss-lint'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_path  = 'lib'

  spec.add_dependency 'guard', '~> 2.0'
  spec.add_dependency 'guard-compat', '~>1.0'
  spec.add_dependency 'scss_lint', '>=0.43.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop'
end
