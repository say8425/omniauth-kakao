$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'omniauth-kakao/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-kakao'
  s.version     = Omniauth::Kakao::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Shayne Sung-Hee Kang']
  s.email       = ['shayne.kang@gmail.com']
  s.homepage    = 'https://github.com/shaynekang/omniauth-kakao'
  s.summary     = 'OmniAuth strategy for Kakao'
  s.description = 'OmniAuth strategy for Kakao(http://developers.kakao.com/)'
  s.license     = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.require_paths = ['lib']

  s.add_dependency 'omniauth', '~> 1.9.0'
  s.add_dependency 'omniauth-oauth2', '~> 1.6.0'

  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rubocop', '~> 0.76.0'
end
