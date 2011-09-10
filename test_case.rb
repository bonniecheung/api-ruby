#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/OrdrIn'
# puts $LOAD_PATH

require 'ordrin'


# dT = dT.new

o = OrdrIn.new('mlJhC8iX4BGWVtn','https://r-test.ordr.in')
# o.setCurrAcct('1234', 'password1')
o.setCurrAcct('test','password')

# o2 = OrdrIn.new("3", "4")
# o2.setCurrAcct('dave@voygr.com', 'password1')

puts "In the test case"
puts o
# puts o2
