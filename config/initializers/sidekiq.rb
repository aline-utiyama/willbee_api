require 'sidekiq'
require 'sidekiq-cron'
require 'sidekiq/web'
require 'rack/session'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }

  config.on(:startup) do
    schedule_file = Rails.root.join('config', 'sidekiq_schedule.yml')

    if File.exist?(schedule_file)
      cron_jobs = YAML.load_file(schedule_file) || {}
      Sidekiq::Cron::Job.load_from_hash cron_jobs
    else
      puts "⚠️ No cron jobs loaded. File not found: #{schedule_file}"
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

# Enable session store for Sidekiq Web UI
Sidekiq::Web.use Rack::Session::Cookie, key: '_sidekiq_session', secret: Rails.application.secret_key_base
