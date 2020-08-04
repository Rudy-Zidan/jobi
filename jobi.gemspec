require_relative 'lib/jobi/version'

Gem::Specification.new do |spec|
  spec.name          = "jobi"
  spec.version       = Jobi::VERSION
  spec.authors       = ["Rudy Zidan"]
  spec.email         = ["rz.zidan@gmail.com"]

  spec.summary       = "A simple message brokers framework for Ruby."
  spec.description   = "Jobi provides a full interaction between your app/micro-service and message brokers."
  spec.homepage      = "https://www.github.com/Rudy-Zidan/jobi"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/Rudy-Zidan/jobi"
  spec.metadata["changelog_uri"] = "https://www.github.com/Rudy-Zidan/jobi/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'bunny', ">= 2.14.1"
  spec.add_dependency 'logger'
end
