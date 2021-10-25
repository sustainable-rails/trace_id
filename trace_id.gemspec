require_relative "lib/trace_id/version"

Gem::Specification.new do |spec|
  spec.name = "trace_id"
  spec.version = TraceId::VERSION
  spec.authors       = ["Dave Copeland"]
  spec.email         = ["davec@naildrivin5.com"]
  spec.summary       = %q{Small class and helpers to manage a request id from web to service calls to background jobs}
  spec.homepage      = "https://github.com/sustainable-rails/trace_id"
  spec.license       = "Hippocratic"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sustainable-rails/trace_id"
  spec.metadata["changelog_uri"] = "https://github.com/sustainable-rails/trace_id/releases"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("rspec")
  spec.add_development_dependency("rspec_junit_formatter")
end
