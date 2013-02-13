require 'sequel'

class Mydns2PDNS
  class Databases
    class << self
      def pdns
        @@pdns
      end

      def mydns
        @@mydns
      end

      def logger
        @logger ||= Logger.new(STDOUT) if $VERBOSE_LOGGING
      end

      def load(config)
        @@pdns  = Sequel.connect(config.pdns_db || 'mysql2://localhost/pdns', :logger => logger)
        @@mydns = Sequel.connect(config.mydns_db || 'mysql2://localhost/mydns', :logger => logger)

        require 'mydns2pdns/pdns'
        require 'mydns2pdns/mydns'
      end
    end
  end
end
