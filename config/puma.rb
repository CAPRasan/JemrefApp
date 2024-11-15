# herokuでのみ適用する設定
if ENV["RACK_ENV"] == "production" || ENV["RAILS_ENV"] == "production"
  workers Integer(ENV["WEB_CONCURRENCY"] || 2)
  threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
  threads threads_count, threads_count

  preload_app!

  on_worker_boot do
    # Worker-specific setup for Rails 4.1+
    ActiveRecord::Base.establish_connection
  end
  rackup      DefaultRackup if defined?(DefaultRackup)
  port        ENV["PORT"]     || 3000
  environment ENV["RACK_ENV"] || "development"
else
  # ローカルでのみ適用する設定
  threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
  threads threads_count, threads_count
  # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
  port ENV.fetch("PORT", 3000)
  # Allow puma to be restarted by `bin/rails restart` command.
  plugin :tmp_restart
  # Run the Solid Queue supervisor inside of Puma for single-server deployments
  plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]
  # Only use a pidfile when requested
  pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
end
