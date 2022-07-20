# frozen_string_literal: true

require_relative "lib/annotable/version"

Gem::Specification.new do |spec|
  spec.name = "annotable"
  spec.version = Annotable::VERSION
  spec.authors = ["Mathieu MOREL"]
  spec.email = ["mathieu@lamanufacture.dev"]

  spec.summary = "A simple method annotation gem"
  spec.description = "Provides a simple way to add annotations to your method declarations."
  spec.homepage = "https://gitlab.com/la-manufacture/rocket/annotable"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/-/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "rubocop", "~> 1.29"
  spec.add_development_dependency "rubocop-rspec", "~> 2.11"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "sord", "~> 4.0"
end
