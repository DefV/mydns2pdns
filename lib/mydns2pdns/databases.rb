require 'sequel'

PDNSDb = Sequel.connect('mysql2://root:@localhost/pdns')
MyDNSDb = Sequel.connect('mysql2://root:@localhost/services')
