module ActiveJob
  module Cron
    class Supervisor < Celluloid::SupervisionGroup
      supervise ActiveJob::Cron::Clock, as: :active_job_clock
      if handler_pool_size = ActiveJob::Cron.config.handler_pool_size
        pool ActiveJob::Cron::Handler,
             as: :cron_job_handler,
             size: handler_pool_size
      else
        pool ActiveJob::Cron::Handler,
             as: :cron_job_handler
      end

      class << self
        def clock
          run! if Celluloid::Actor[:active_job_clock].nil?
          Celluloid::Actor[:active_job_clock]
        end

        def handler
          run! if Celluloid::Actor[:corn_job_handler].nil?
          Celluloid::Actor[:cron_job_handler]
        end

        def run
          raise "Sidetiq::Supervisor should not be run in foreground."
        end
      end
    end
  end
end
