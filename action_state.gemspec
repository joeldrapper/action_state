require_relative "lib/action_state/version"

Gem::Specification.new do |spec|
  spec.name        = "action_state"
  spec.version     = ActionState::VERSION
  spec.authors     = ["Joel Drapper"]
  spec.email       = ["joel@drapper.me"]
  spec.homepage    = "https://github.com/joeldrapper/action_state"
  spec.summary     = "Small DSL for defining Rails model states."
  spec.description = "Quickly define Rails model predicates and scopes at the same time."
  spec.license     = "MIT"
  
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/joeldrapper/action_state"
  spec.metadata["changelog_uri"] = "https://github.com/joeldrapper/action_state"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency 'rails', '~> 7.0'
end
