#
# Order.in Ruby Library Alpha
# dT Class - Date Time Functions
#
# http://ordr.in
#
# (c) 2011
# Last update: September 2011
#

class DT < OrdrIn
	attr :date

	def initialize(date) 
		unless date.empty?
			@date = Date.today
		else
			@date = date
	end

	def to_s
		puts('********* DEBUG INFO - Class dT *********')
		printf("%10s : %s", 'Date', @date)
		puts '*' * 41
	end
end
