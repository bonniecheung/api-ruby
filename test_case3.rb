#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
# puts $LOAD_PATH

# require 'lib/api'
require 'api'

api = API::OrdrIn.new('mlJhC8iX4BGWVtn','https://r-test.ordr.in')
dt = API::DT.new
st =  API::Money.new(500.00)
tip =  API::Money.new(st.amount * 0.15)
a = API::Address.new('street with spaces', 'Cedar Rapids', '52404', 'street2','IA', '319-366-2309','nick')
m = API::Money.new(23.44)

dt.asap = true;
api.set_curr_acct('dave@batez-consulting.com','password')

r = API::Restaurant.new
$_url = 'https://r-test.ordr.in'
r.delivery_check(33, dt, a)

o = API::Order.new
$_url = 'https://o-test.ordr.in'
# o.submit(33, 'tray1', tip, dt, 'dabates77@gmail.com', 'David', 'Bates', a, 'Discover', '6011000990139424', '040', '052011', a)

u = API::User.new
$_url = 'https://u-test.ordr.in'

$_errors.map {|e| puts 'Error : ' + e} unless $_errors.empty?