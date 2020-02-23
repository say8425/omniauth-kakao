require 'spec/spec_helper'
require 'omniauth'
require 'omniauth/kakao2'

describe OmniAuth::Strategies::Kakao2 do
  let(:client_id)     { ENV['CLIENT_ID'] }
  let(:server_name)   { ENV['SERVER_NAME'] }
  let(:app)           { lambda { [200, {}, 'app'] } }
  subject(:kakao)         { OmniAuth::Strategies::Kakao2.new(app, client_id) }

  def make_request(url, opts = {})
    Rack::MockRequest.env_for(url, {
      'rack.session' => {},
      'SERVER_NAME' => server_name
    }.merge(opts))
  end

  describe 'GET /auth/kakao' do
    it 'should redirect to authorize page' do
      request = make_request('/auth/kakao')
      code, env = kakao.call(request)

      expect(code).to eq 302

      expect_url = <<-EXPECT
        https://kauth.kakao.com/oauth/authorize
          ?client_id=#{client_id}
          &redirect_uri=http://#{server_name}/oauth
          &response_type=code
      EXPECT
                   .gsub(/(\n|\t|\s)/, '')

      actual_url = URI.decode(env['Location'].split('&state')[0])

      actual_url.should == expect_url
    end
  end

  describe 'GET /oauth' do
    CODE = 'dummy-code'.freeze
    STATE = 'dummy-state'.freeze
    ACCESS_TOKEN = 'dummy-access-token'.freeze
    REFRESH_TOKEN = 'dummy-refresh-token'.freeze

    before do
      FakeWeb.register_uri(:post, 'https://kauth.kakao.com/oauth/token',
                           content_type: 'application/json;charset=UTF-8',
                           parameters: {
                             grant_type: 'authorization_code',
                             client_id: client_id,
                             redirect_uri: URI.encode("http://#{server_name}/oauth"),
                             code: CODE
                           },
                           body: {
                             access_token: ACCESS_TOKEN,
                             token_type: 'bearer',
                             refresh_token: REFRESH_TOKEN,
                             expires_in: 99_999,
                             scope: 'Basic_Profile'
                           }.to_json)

      FakeWeb.register_uri(:get, 'https://kapi.kakao.com/v2/user/me',
                           content_type: 'application/json;charset=UTF-8',
                           "Authorization": "Bearer #{ACCESS_TOKEN}",
                           body: {
                             id: 123_456_789,
                             properties: {
                               nickname: 'John Doe',
                               thumbnail_image: 'http://xxx.kakao.com/.../aaa.jpg',
                               profile_image: 'http://xxx.kakao.com/.../bbb.jpg'
                             }
                           }.to_json)
    end

    it 'should request access token and user information' do
      request = make_request("/oauth?code=#{CODE}&state=#{STATE}",
                             'rack.session' => {
                               'omniauth.state' => STATE
                             })

      code, env = kakao.call(request)

      code.should == 200

      response = env['omniauth.auth']

      response.provider.should == 'kakao2'
      response.uid.should == '123456789'

      information = response.info
      information.name.should == 'John Doe'
      information.image.should == 'http://xxx.kakao.com/.../aaa.jpg'

      credentials = response.credentials
      credentials.token.should == ACCESS_TOKEN
      credentials.refresh_token.should == REFRESH_TOKEN

      properties = response.extra.properties
      properties.nickname.should == 'John Doe'
      properties.thumbnail_image.should == 'http://xxx.kakao.com/.../aaa.jpg'
      properties.profile_image.should == 'http://xxx.kakao.com/.../bbb.jpg'
    end
  end
end
