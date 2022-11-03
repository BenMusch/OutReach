if ENV["RACK_MINI_PROFILER"].to_i > 0
  require "rack-mini-profiler"

  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.authorization_mode = :whitelist if Rails.env.production?
end
