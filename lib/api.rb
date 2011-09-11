#!/usr/bin/env ruby -wKU

### The Ordr In API Module

require 'net/http'
require 'date'
## TODO: I'm sure there will be more

module API
  $_errors = Array.new

  ## -------------------------- ORDRIN CLASS ------------------------------------------------ ##
  class OrdrIn
    attr_accessor :_email, :_password, :_url, :_key
    @@_email_regex = %r{^[0-9a-z][0-9a-z.+]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z]$}xi

    def initialize(key, url)
      self._key=key
      self._url=url
    end

    def setCurrAcct(email, pass)

      unless email =~ @@_email_regex
        ## Error
        $_errors << sprintf("%s setCurrAcct - validation - email invalid (%s)", File.basename(__FILE__), email);
      else
        self._email= email
        self._password=pass
      end
    end
    
    ## For debug, the string representation of this
    def to_s
      puts "** DEBUG INFORMATION **"
      printf "%10s : %s\n", "Key", self._key
      printf "%10s : %s\n", "URL", self._url
      printf "%10s : %s\n", "Email", self._email
      printf "%10s : %s\n", "Password", self._password
      printf "%10s : %s\n", "Errors", $_errors
      print "*" * 23
    end
  end ## OrdrIn Class
  ## ---------------------------------------------------------------------------------------- ##  

  ## -------------------------- DT     CLASS ------------------------------------------------ ##
  class DT
    attr :date, :asap

    def initialize(date=nil) 
      unless date
        puts "Date is nil, trying to set with today"
        @date = Date.today()
      else
        puts 'Setting date to passed'
        @date = date
      end
      @asap = false
    end


    def _strAPI(ele)
      case ele
      when 'month'
        puts 'Month'
      when 'day'
        puts 'Day'
      end
    end
    def to_s
      puts('********* DEBUG INFO - Class dT *********')
      printf("%10s : %s\n", 'Date', @date)
      printf("%10s : %s\n", 'ASAP', @asap)
      puts '*' * 41
    end
  end
  ## ---------------------------------------------------------------------------------------- ##  

end