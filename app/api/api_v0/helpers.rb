module ApiV0
  module Helpers
    def authenticate!
      current_user or raise AuthorizationError
    end

    def current_user
      @current_user ||= User.find_by_id(@env["api_v0.user"])
    end
  end
end