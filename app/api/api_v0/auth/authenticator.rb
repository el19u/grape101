module ApiV0::Auth
  class Authenticator
    def initialize(req,params)
      @req = req
      @params = params
    end
  
    def authenticate!
      check_token!
      token
    end

    def token
      @token = ApiAccessToken.joins(:user).where(key: @params[:token]).first
    end

    def check_token!
      return @params[:access_key] unless token
    end
end