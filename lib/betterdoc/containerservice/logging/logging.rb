require 'logging'

Logging::Rails.configure do |config|

  # Configure the Logging framework with the default log levels
  Logging.init %w[debug info warn error fatal]

  # Objects will be converted to strings using the :inspect method.
  Logging.format_as :inspect

  # The default pattern used by the appenders.
  pattern = "rails #{Betterdoc::Containerservice::Metadata.compute_name} #{Betterdoc::Containerservice::Metadata.compute_version} %X{request_id} %l - %m\n"

  # Setup a color scheme called 'bright' than can be used to add color codes
  # to the pattern layout. Color schemes should only be used with appenders
  # that write to STDOUT or STDERR; inserting terminal color codes into a file
  # is generally considered bad form.
  if ENV['LOGGING_COLOR'] == 'true'
    Logging.color_scheme('bright', levels: { warn: :yellow, error: :red, fatal: %i[white on_red] }, date: :blue, logger: :cyan, message: :magenta)
    Logging.appenders.stdout('stdout', auto_flushing: true, layout: Logging.layouts.pattern(pattern: pattern, color_scheme: 'bright'))
  else
    Logging.appenders.stdout('stdout', auto_flushing: true, layout: Logging.layouts.pattern(pattern: pattern))
  end

  Logging.logger.root.level = config.log_level
  Logging.logger.root.appenders = 'stdout' unless Rails.env.test?

  # Under Phusion Passenger smart spawning, we need to reopen all IO streams
  # after workers have forked.
  #
  # The rolling file appender uses shared file locks to ensure that only one
  # process will roll the log file. Each process writing to the file must have
  # its own open file descriptor for `flock` to function properly. Reopening
  # the file descriptors after forking ensures that each worker has a unique
  # file descriptor.
  if defined? PhusionPassenger
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      Logging.reopen if forked
    end
  end

end
