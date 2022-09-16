module ApiV0
  module Auth
    class Middleware < Grape::Middleware::Base
      def before
        if auth_provided?
          @env["api_v0.token"] = Authenticator.new(request, params).authenticate!
          @env["api_v0.user"] ||= @env["api_v0.token"].try(:user)
      end

      def after
        # Do something after the endpoint is called.
      end
    end
  end
end