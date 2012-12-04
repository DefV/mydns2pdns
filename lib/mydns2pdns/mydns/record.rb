module MyDNS
  class Record < Sequel::Model
    self.db = Mydns2PDNS::Databases.mydns
    self.set_dataset :mydns_rr

    many_to_one :soa, :key => :zone

    def fullname
      [name, soa.name].select {|f| f && f.size > 0}.join('.')
    end

    def type
      self[:type]
    end
  end
end
