module Epilady
  class Logger
    def self.create_logger
      log_path = "#{Rails.root}/log/epilady.log"

      unless File.exists?(log_path)
        FileUtils.mkdir_p File.dirname(log_path)
        FileUtils.touch log_path
      end

      ::Logger.new(log_path)
    end

    def self.logger
      @@logger ||= create_logger
    end

    def self.log(message, severity = ::Logger::DEBUG)
      logger.log severity, message.to_s
    end
  end
end
