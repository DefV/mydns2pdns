require 'sequel'

module PDNS
  class Domain < Sequel::Model
    self.db = Mydns2PDNS::Databases.pdns

    one_to_many :records

    def import_zone(domain)
      self.db.transaction do
        seen = domain.records.inject([]) do |seen, record|
          pdns_record = records.find {|r| r.can_be_replaced_with?(record) }
          pdns_record = PDNS::Record.new unless pdns_record
          pdns_record.import_mydns_record record
          add_record pdns_record unless records.member?(pdns_record)

          seen << pdns_record
        end

        seen << update_or_create_soa_for(domain)

        (records(true) - seen).each do |record|
          record.destroy
        end
      end

      # Validate record sizes
      unless records(true).count == domain.records(true).count + 1
        puts "Something is wrong with #{name} - Record size don't add up - PDNS: #{records.count} MyDNS: #{domain.records.count + 1}"
      end
    end

    def update_or_create_soa_for(domain)
      record = PDNS::Record.find_or_create(:type => 'SOA', :domain_id => id)
      record.name = domain.name
      record.content = "#{domain.ns} #{domain.mbox} #{domain.serial} #{domain.refresh} #{domain.retry} #{domain.expire} #{domain.minimum}"
      record.ttl  = domain.ttl
      record.save if record.changed_columns.any?

      record
    end
  end
end
