module MyDNS
  class Soa < Sequel::Model
    self.db = Mydns2PDNS::Databases.mydns
    self.set_dataset :mydns_soa

    one_to_many :records, :key => :zone

    def name
      origin.gsub(/\.$/, '')
    end
  end
end
