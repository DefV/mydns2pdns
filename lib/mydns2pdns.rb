require 'rubygems'
require 'logger'
require 'bundler/setup'

require 'mydns2pdns/config'
require 'mydns2pdns/databases'

class Mydns2PDNS
  class << self
    def log(message)
      if $VERBOSE_LOGGING
        @logger ||= Logger.new(STDOUT)
        @logger.info message
      end
    end
  end
  attr_accessor :options

  def initialize(options = {})
    self.options = options
  end

  def convert!
    Mydns2PDNS::Databases.load(config)

   seen = mydns_domains.map do |domain|
      pdns_domain = PDNS::Domain.find_or_create(:name => domain.name, :type => 'NATIVE')

      pdns_domain.import_zone(domain)
      pdns_domain
    end

    (pdns_domains - seen).each do |domain|
      domain.destroy
    end
  end

  def mydns_domains
    @mydns_domains ||= MyDNS::Soa.all
  end

  def pdns_domains
    PDNS::Domain.all
  end

  def config
    @config ||= Mydns2PDNS::Config.new(options[:config])
  end
end
