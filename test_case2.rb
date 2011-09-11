#!/usr/bin/env ruby -wKU
#!/usr/bin/env ruby -wKU
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
# puts $LOAD_PATH

require 'api'

o = API::OrdrIn.new('1','2')
dt = API::DT.new

# o.setCurrAcct('dabates77@gmail.com','test')
o.setCurrAcct('1234','test')
puts o

dt._strAPI('month')
puts dt