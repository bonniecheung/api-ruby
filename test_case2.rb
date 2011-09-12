#!/usr/bin/env ruby -wKU
#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
# puts $LOAD_PATH

# require 'lib/api'
require 'api'

o = API::OrdrIn.new('1','2')
dt = API::DT.new

st =  API::Money.new(500.00)
tip =  API::Money.new(st.amount * 0.15)

o.setCurrAcct('dabates77@gmail.com','test')
# o.setCurrAcct('1234','test')
#puts o

# puts 'Month : ' + dt._strAPI('month')
# puts 'Day   : ' + dt._strAPI('day')
# puts 'Hour  : ' + dt._strAPI('hour')
# puts 'Minute: ' + dt._strAPI('minute')
# puts dt

a = API::Address.new('street with spaces', 'Cedar Rapids', '52404', 'street2','IA', '319-366-2309','nick')
#puts a.to_s

# puts "Starting Validation - Address"
a.validate
# puts "\nEnding Validation - Address"
# puts a

m = API::Money.new(23.44)
# puts m

r = API::Restaurant.new
# r.to_s
# r.delivery_check(33, dt, a)
# r.delivery_fee(33, st, tip, dt, a)
# r.details(33)


$_errors.map {|e| puts 'Error : ' + e} if !$_errors.empty?