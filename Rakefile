require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('Ordrin_API','0.9.27') do |p|
  p.description         = 'OrdrIn Ruby Wrapper for the API'
  p.url                 = 'http://ordr.in'
  p.author              = 'David Bates - OrdrIn'
  p.ignore_pattern      = ["tmp/*", "script/*", '*sublime*', 'demo/*']
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|ext| load ext}
