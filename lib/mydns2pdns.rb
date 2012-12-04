require 'rubygems'
require 'bundler/setup'

require 'mydns2pdns/databases'
require 'mydns2pdns/pdns'
require 'mydns2pdns/mydns'

class Mydns2PDNS
  def convert!
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
end
