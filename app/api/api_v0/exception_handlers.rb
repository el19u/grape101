module ApiV0
  module ExceptionHandlers

    def self.included(base)
      base.instance_eval do
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          rack_response({
            error: {
              code: 1001,
              message: e.message,
            }
          }.to_json, e.status)
        end

        rescue_from ActiveRecord::RecordNotFound do
          rack_response({
            error: {
              code: 400,
              message: "404 not found."
            }
          }.to_json, 404)
        end

        route :any, "*path" do
          error!("404 not found.", 404)
        end
      end
    end
  end

  class Error < Grape::Exceptions::Base
    attr :code, :text

    def initialize(opts={})
      @code = opts[:code] || 2000
      @text = opts[:text] || ""

      @status = opts[:status] || 400
      @message = {error: { code: @code, message: @text }}
    end
  end

  class AuthorizationError < Error
    def initialize
      super(code: 2000, text: "Authorization failed.", status: 401)
    end
  end
end