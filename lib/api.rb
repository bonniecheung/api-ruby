#!/usr/bin/env ruby -wKU

### The Ordr In API Module

require 'net/http'
require 'date'
require 'cgi'
## TODO: I'm sure there will be more

module API
  attr :_errors

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
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - email invalid #{email}"
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
        @date = DateTime.now
      else
        @date = date
      end
      @asap = false
    end


    def _strAPI(ele)
      case ele.downcase
      when 'month'
        return sprintf('%02d', @date.month)
      when 'day'
        return sprintf('%02d', @date.day)
      when 'hour'
        return sprintf('%02d', @date.hour)
      when 'minute'
        return sprintf('%02d', @date.minute)
      else
        puts '0'
      end
    end

    def _convertForAPI
      unless @ASAP
        return @date.month + '-' + @date.day + '+' + @date.hour + ':' + @date.minute
      else
        puts "ASAP"
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

  ## -------------------------- Address CLASS ----------------------------------------------- ##
  class Address
    attr :street, :city, :zip, :street2, :state, :phone, :nick

    def initialize(street, city, zip, street2, state, phone, nick)
      @street=CGI::escape(street)
      @city=CGI::escape(city)
      @zip=zip
      @street2=CGI::escape(street2)
      @state=state
      @phone=phone
      @nick=nick
    end

    def _convertForAPI
      return @zip + '/' + @city + '/' + @street
    end

    def validate(element='all')
      if (element == 'zip' && !(@zip =~ %r{(^\d{5}$)|(^\d{5}-\d{4}$)}i)) ## Validate Zip
        puts "#{__LINE__}: ZIP Error, not a valid zip"
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Zip code invalid (#{@zip})"
      elsif (element == 'phone' && !(@phone =~ %r{(^\(?(\d{3})\)?[- .]?(\d{3})[- .]?(\d{4})$)}i))
        puts "#{__LINE__}: PHONE Error, not a valid phone"
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Phone number invalid (#{@phone})"
      elsif (element == 'city' && !(@city =~ %r{[A-z.-]}))
        puts "#{__LINE__}: CITY Error, not a valid city"
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - City (invalid, only letters/spaces allowed) (#{@city})"
      elsif (element == 'state' && !(@state =~ %r{^([A-z]){2}$}))
        puts "#{__LINE__}: STATE Error, not a valid state"
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - State (invalid, only letters allowed and must be passed as two-letter abbreviation) (#{@state})"
      else ## Do all 
        if (!(@zip =~ %r{(^\d{5}$)|(^\d{5}-\d{4}$)}i)) ## Validate Zip
          puts "#{__LINE__}: ZIP Error, not a valid zip"
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Zip code invalid (#{@zip})"
        end

        if (!(@phone =~ %r{(^\(?(\d{3})\)?[- .]?(\d{3})[- .]?(\d{4})$)}i))
          puts "#{__LINE__}: PHONE Error, not a valid phone"
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Phone number invalid (#{@phone})"
        end

        if (!(@city =~ %r{[A-z.-]}))
          puts "#{__LINE__}: CITY Error, not a valid city"
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - City (invalid, only letters/spaces allowed) (#{@city})"
        end

        if (!(@state =~ %r{^([A-z]){2}$}))
          puts "#{__LINE__}: STATE Error, not a valid state"
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - State (invalid, only letters allowed and must be passed as two-letter abbreviation) (#{@state})"
        end
      end
    end

    def to_s
      puts('********* DEBUG INFO - Class Address *********')
      printf("%10s : %s\n", 'Street', @street)
      printf("%10s : %s\n", 'City', @city)
      printf("%10s : %s\n", 'Zip', @zip)
      printf("%10s : %s\n", 'Street2', @street2)
      printf("%10s : %s\n", 'State', @state)
      printf("%10s : %s\n", 'Phone', @phone)
      printf("%10s : %s\n", 'Nick', @nick)
      puts '*' * 46
    end
  end
  ## ---------------------------------------------------------------------------------------- ##  

  ## -------------------------- Money   CLASS ----------------------------------------------- ##
  class Money
    attr :amount

    def initialize(amt)
      @amount = -0.00

      begin Float(amt)
        @amount = amt
      end
    rescue
      $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Money - Validation - must be a number, we got (#{amt})"
    end


    def to_s
      puts('********* DEBUG INFO - Class Money ***********')
      printf("%10s : %.2f\n", 'Amount', @amount)
      puts '*' * 46
    end
    
  end
  ## ---------------------------------------------------------------------------------------- ##  

end
