require 'logging'

module Betterdoc
  module Containerservice
    module Logging
      class StoreRequestIdIntoLoggingMdcMiddleware

        def initialize(app)
          @app = app
        end

        def call(env)
          ::Logging.mdc['request_id'] = ActionDispatch::Request.new(env).request_id
          @status, @headers, @response = @app.call(env)
        ensure
          ::Logging.mdc['request_id'] = nil
        end
        [@status, @headers, @response]

      end
    end
  end
end
