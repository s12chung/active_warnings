# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_warnings/version'

Gem::Specification.new do |spec|
  spec.name          = "active_warnings"
  spec.version       = ActiveWarnings::VERSION
  spec.authors       = ["Steve Chung"]
  spec.email         = ["steve.chung7@gmail.com"]

  spec.summary       = "Separate ActiveModel::Validations for warnings."
  spec.homepage      = "https://github.com/s12chung/active_warnings"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", "~> 4.2"

end
