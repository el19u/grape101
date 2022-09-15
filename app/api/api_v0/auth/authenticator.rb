module ApiV0
  class Authenticator < Grape::API
    desc 'Ping pong'
    get "/ping" do
      "pong"
    end
  end
end