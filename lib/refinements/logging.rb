# This is needed for logging-rails to work with Rails 6
# which wraps `Logging::Logger` with `ActiveSupport::TaggedLogging`.
# Without it Rails 6 throws `NoMethodError: undefined method `formatter=' for #<Logging::Logger...` error
#
# See https://github.com/TwP/logging-rails/issues/27 for more info

if Rails::VERSION::MAJOR == 6
  module Logging
    module RailsCompat
      def tagged(*_args)
        yield self
      end
    end
  end
end
