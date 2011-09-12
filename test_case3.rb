#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
# puts $LOAD_PATH

# require 'lib/api'
require 'api'

api = API::OrdrIn.new('mlJhC8iX4BGWVtn','https://r-test.ordr.in')
# api = API::OrdrIn.new('','')
dt = API::DT.new
dt.asap = true;

st =  API::Money.new(500.00)
tip =  API::Money.new(st.amount * 0.15)

api.set_curr_acct('dave@batez-consulting.com','password')
# puts api
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
$_url = 'https://o-test.ordr.in'
o.submit(33, 'tray1', tip, dt, 'dabates77@gmail.com', 'David', 'Bates', a, 'Discover', '6011000990139424', '040', '052011', a)

u = API::User.new
# puts api

# u.update_address(a)
# u.get_card
# u.get_card('DISC')
# u.update_password('test2')
# $_url = 'https://u-test.ordr.in'
# u.get_acct

$_errors.map {|e| puts 'Error : ' + e} if !$_errors.empty?