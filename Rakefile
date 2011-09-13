require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('api-ruby','0.9.25') do |p|
  p.description         = 'OrdrIn Ruby Wrapper for the API'
  p.url                 = 'http://ordr.in'
  p.author              = 'David Bates - OrdrIn'
  p.ignore_pattern      = ["tmp/*", "script/*", '*sublime*', 'test_case*.rb', '*.iml']
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|ext| load ext}