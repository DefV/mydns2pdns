module MyDNS
  class Soa < Sequel::Model
    self.db = MyDNSDb
    self.set_dataset :mydns_soa

    one_to_many :records, :key => :zone

    def name
      origin.gsub(/\.$/, '')
    end
  end
end
