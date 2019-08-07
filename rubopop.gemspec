# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubopop/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubopop'
  spec.version       = Rubopop::VERSION
  spec.authors       = ['kvokka']
  spec.email         = ['kvokka@yahoo.com']

  spec.summary       = 'Quick & clean Rubocop introduction.'
  spec.description   = 'Create 1 PR per 1 Rubocop linter, which allow to do review rubocop changes smoothly.'
  spec.homepage      = 'https://github.com/kvokka/rubopop'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 2.1'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '~> 0.57.0'
  spec.add_dependency 'activesupport', '>= 4.2.0', '< 6.0'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.27'
end
