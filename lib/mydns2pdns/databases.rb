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

      def load(config)
        @@pdns  = Sequel.connect(config.pdns_db || 'mysql2://localhost/pdns')
        @@mydns = Sequel.connect(config.mydns_db || 'mysql2://localhost/mydns')

        require 'mydns2pdns/pdns'
        require 'mydns2pdns/mydns'
      end
    end
  end
end
