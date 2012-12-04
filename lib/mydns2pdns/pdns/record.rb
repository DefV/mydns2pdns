require 'sequel'

module PDNS
  class Record < Sequel::Model
    self.db = Mydns2PDNS::Databases.pdns

    def can_be_replaced_with?(record)
      case record.type
      when 'TXT', 'CNAME'
        type == record.type && name == record.fullname
      when 'A', 'AAAA'
        type == record.type && content == record.data && name == record.fullname
      when 'MX', 'NS'
        type == record.type && content == record.data
      else
        raise "Unknown record type: #{record.type}"
      end
    end

    def import_mydns_record(record)
      self.type = record.type
      self.name = record.fullname
      self.content = record.data
      self.ttl = record.ttl
      self.prio = record.aux
    end

    def type
      self[:type]
    end
  end
end
