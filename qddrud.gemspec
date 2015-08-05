# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qddrud/version'

Gem::Specification.new do |spec|
  spec.name          = 'qddrud'
  spec.version       = qddrud::VERSION
  spec.authors       = ['Jon Bogaty']
  spec.email         = ['jon@jonbogaty.com']
  spec.required_ruby_version = '>= 2.1.2'
  spec.summary       = 'Generates the README.md file for Chef cookbooks.'
  desc = 'Quick and dirty Drud local-mode only supporting grokking of an entire site-cookbook directory worth of metadata'

  spec.description   = desc
  spec.homepage      = 'https://github.com/newmediadenver/qddrud'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'chef', '>= 12.4.1'
end
