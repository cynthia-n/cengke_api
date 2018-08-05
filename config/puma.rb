tag 'Web'
ENV['RACK_ENV'] ||= ENV['RAILS_ENV'] ||= Rails.env ||= 'development'
if ENV['RACK_ENV'] == 'development'
  workers = 1
  threads = 1
  daemonize false
else
  APP_ROOT = ENV['RACK_ROOT'] || ENV['PWD']
  threads_count = ENV['THREADS'] || 4
  workers_count = ENV['WORKERS'] || 4

  directory APP_ROOT
  pidfile "#{APP_ROOT}/tmp/pids/puma.pid"
  state_path "#{APP_ROOT}/tmp/pids/puma.state"

  # bind 'tcp://0.0.0.0:4000'
  bind "unix://#{APP_ROOT}/tmp/sockets/puma.sock"
  stdout_redirect 'log/puma.log', 'log/puma_error.log', true

  # worker_timeout 30

  daemonize true
  threads threads_count, threads_count
  workers workers_count

  prune_bundler

  GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true
end
