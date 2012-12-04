module MyDNS
  class Record < Sequel::Model
    self.db = MyDNSDb
    self.set_dataset :mydns_rr

    many_to_one :soa, :key => :zone

    def fullname
      [name, soa.name].select {|f| f && f.size > 0}.join('.')
    end
  end
end
