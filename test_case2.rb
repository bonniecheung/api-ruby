#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
# puts $LOAD_PATH

# require 'lib/api'
require 'api'

api = API::OrdrIn.new('1','2')
dt = API::DT.new
dt.asap = true;

st =  API::Money.new(500.00)
tip =  API::Money.new(st.amount * 0.15)

api.setCurrAcct('dabates77@gmail.com','test')
# api.setCurrAcct('1234','test')
puts api

# puts 'Month : ' + dt._strAPI('month')
# puts 'Day   : ' + dt._strAPI('day')
# puts 'Hour  : ' + dt._strAPI('hour')
# puts 'Minute: ' + dt._strAPI('minute')
# puts dt

a = API::Address.new('street with spaces', 'Cedar Rapids', '52404', 'street2','IA', '319-366-2309','nick')
# puts a.to_s

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

o = API::Order.new
# o.submit(33, 'tray1', tip, dt, 'dabates77@gmail.com', 'David', 'Bates', a, 'Discover', '6011000990139424', '040', '052011', a)

u = API::User.new
api.setCurrAcct('dabates77@gmail.com', 'testb')
puts api
u.update_address(a)

$_errors.map {|e| puts 'Error : ' + e} if !$_errors.empty?