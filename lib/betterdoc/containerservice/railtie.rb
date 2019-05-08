require "logging"
require "logging-rails"
require "lograge"

module Betterdoc
  module Containerservice
    class Railtie < Rails::Railtie

      initializer 'betterdoc.containerservice.autoload', before: :set_autoload_paths do |app|
        # Ensure that *all* the classes from the gem are visible throughout Rails
        app.config.autoload_paths += Dir["#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))}/**/"]
      end

      initializer 'betterdoc.containerservice.logging' do |app|

        # Lograge cleans up the default Rails logging.
        # The main feature that we use it *not* printing all the HTTP parametes to the Logger (and to the console)
        # so that any passwords or other sensitive data isn't leaked into our logs (and the log aggregator).
        # For more details visit: https://github.com/roidrage/lograge
        app.config.lograge.enabled = true

        # Our logging pattern includes the "request_id" passed either via an HTTP header or generated internally.
        # By default the Logging MDC doesn't contain the "request_id" so we have to introduce a new middleware into
        # the Rack stack that reads the "request_id" and makes it availble to the Logging MDC
        app.config.middleware.insert_after ActionDispatch::RequestId, Betterdoc::Containerservice::Logging::StoreRequestIdIntoLoggingMdcMiddleware

        # By default we don't want to have the SQL statements written in the logfiles as they might leak sensitive
        # information (like patient data, etc.)
        ::ActiveRecord::Base.logger.level = Logger::INFO

      end

      initializer 'betterdoc.containerservice.initialization' do

        # Make sure all our internal constraints are added to ActionController::Base
        # This way we ensure that all controllers require authentication via JWT, set the default headers expected
        # by Stacker and support some general functionality that makes our life a little easier
        class ActionController::Base
          include Betterdoc::Containerservice::Controllers::Concerns::HttpHelpersConcern
          include Betterdoc::Containerservice::Controllers::Concerns::HttpResponseMetadataConcern
          include Betterdoc::Containerservice::Controllers::Concerns::AuthenticationConcern
        end

      end

    end
  end
end
