require 'sequel'

module PDNS
  class Domain < Sequel::Model
    self.db = PDNSDb

    one_to_many :records

    def import_zone(domain)
      seen = domain.records.inject([]) do |seen, record|
        pdns_record = records.find {|r| r.can_be_replaced_with?(record) }
        pdns_record = PDNS::Record.new unless pdns_record
        pdns_record.import_mydns_record record
        pdns_record.save
        add_record pdns_record

        seen << pdns_record
      end

      seen << update_or_create_soa_for(domain)

      (records(true) - seen).each do |record|
        puts "#{record.id} - Destroying #{record.type} - #{record.name} - #{record.content}"
        record.destroy
      end

      # Validate record sizes
      unless records.count == domain.records.count + 1
        puts "Something is wrong with #{name} - Record size don't add up - PDNS: #{records.count} MyDNS: #{domain.records.count + 1}"
      end
    end

    def update_or_create_soa_for(domain)
      record = PDNS::Record.find_or_create(:type => 'SOA', domain_id: id)
      record.name = domain.name
      record.content = "#{domain.ns} #{domain.mbox} #{domain.serial} #{domain.refresh} #{domain.retry} #{domain.expire} #{domain.minimum}"
      record.ttl  = domain.ttl
      record.save

      record
    end
  end
end
