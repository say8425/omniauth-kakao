# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'omniauth/kakao2/version'

Gem::Specification.new do |spec|
  spec.name        = 'omniauth-kakao2'
  spec.version     = Omniauth::Kakao2::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = 'Penguin'
  spec.email       = 'say8425@gmail.com'
  spec.homepage    = 'https://github.com/say8425/omniauth-kakao2'
  spec.summary     = 'OmniAuth strategy for Kakao'
  spec.description = 'OmniAuth strategy for Kakao(http://developers.kakao.com/)'
  spec.license     = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'omniauth', '~> 1.9.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.6.0'

  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rubocop', '~> 0.77.0'
end
