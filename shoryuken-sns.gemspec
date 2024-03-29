require_relative 'lib/shoryuken/sns/version'

Gem::Specification.new do |spec|
  spec.name          = "shoryuken-sns"
  spec.version       = Shoryuken::Sns::VERSION
  spec.authors       = ["Steven Eksteen"]
  spec.email         = ["steven.eksteen@fuseuniversal.com"]

  spec.summary       = "Shoryuken with SNS"
  spec.description   = "Publish messages to SNS using Shoryuken"
  spec.homepage      = "https://github.com/Fuseit/shoryuken-sns"
  spec.license       = "BSD 3-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Fuseit/shoryuken-sns/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-sns"
  spec.add_dependency "aws-sdk-sqs"
  spec.add_dependency "activesupport"
  spec.add_dependency "shoryuken", "5.0.3"
end
