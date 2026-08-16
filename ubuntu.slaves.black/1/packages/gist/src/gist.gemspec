# encoding: utf-8
require './lib/gist'
Gem::Specification.new do |s|
  s.name          = 'gist'
  s.version       = Gist::VERSION
  s.summary       = 'Just allows you to upload gists'
  s.description   = 'Provides a single function (Gist.gist) that uploads a gist.'
  s.homepage      = 'https://github.com/defunkt/gist'
  s.email         = ['conrad.irwin@gmail.com', 'rkingist@sharpsaw.org']
  s.authors       = ['Conrad Irwin', '☈king']
  s.license       = 'MIT'
  s.files         = Dir.glob("**/*").select {|v| v !~ /^debian/}
  s.require_paths = ["lib"]

  s.executables << 'gist-paste'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'ronn'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rspec', '>3'
end
