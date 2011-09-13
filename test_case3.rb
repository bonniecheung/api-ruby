#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
# puts $LOAD_PATH

# require 'lib/api'
require 'api'

api = API::OrdrIn.new('mlJhC8iX4BGWVtn','https://r-test.ordr.in')
dt = API::DT.new
st =  API::Money.new(500.00)
tip =  API::Money.new(st.amount * 0.15)
a = API::Address.new('1 Main Street', 'College Station', '77840', '','TX', '319-132-5648','nick')
m = API::Money.new(23.44)

dt.asap = true;
api.set_curr_acct('dave@batez-consulting.com','password')

r = API::Restaurant.new
$_url = 'https://r-test.ordr.in'
# r.delivery_check(33, dt, a)
# puts r.delivery_list(dt, a)
# r.details(1)

o = API::Order.new
$_url = 'https://o-test.ordr.in'
# puts o.submit(141, 'tray1', tip, dt, 'dabates77@gmail.com', 'David', 'Bates', a, 'Discover', '6011000990139424', '040', '052011', a)

u = API::User.new
$_url = 'https://u-test.ordr.in'
api.set_curr_acct('test0@testing.com','test0')
# puts u.make_acct('dabates77@gmail.com', 'password', 'Dave','Bates')
puts u.get_acct

$_errors.map {|e| puts 'Error : ' + e} unless $_errors.empty?