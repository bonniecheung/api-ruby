#!/usr/bin/env ruby -wKU

### The Ordr In API Module

require 'net/http'
require 'net/https'
require 'date'
require 'cgi'
require 'digest/md5'
require 'digest/sha1'
require 'digest/sha2'

## TODO: I'm sure there will be more

module OrdrIn
  attr_accessor :_errors, :_key, :_url, :_email, :_password

  $_errors = Array.new
  $_cc_re = %r{^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$}i
  $_email_regex = %r{^[0-9a-z][0-9a-z.+]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z]$}i

  def set_url(url)
    $_url = url
  end

  ## -------------------------- ORDRIN CLASS ------------------------------------------------ ##
  class API
    attr :_api_data

    def initialize(key, url)
      $_key=key
      $_url=url
    end

    def set_curr_acct(email, pass)
      unless email =~ $_email_regex
        ## Error
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - email invalid #{email}"
      else
        $_email= email
        $_password=pass
      end
    end

    ## You can use a Hash or regular array here
    def _make_request_str(ar, sep)
      ## Do the Hash version
      ret_str = ''
      if ar.kind_of?(Hash)
        ret_str = ar.map do |k,v|
          "#{k}=#{v}"
        end.join sep

      elsif ar.kind_of?(Array)
         ret_str = ar.map {|v| '#{v}' }.join sep
      end

      return ret_str
    end

    def _request(data)
      if $_key.nil? || $_key.empty? ; $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - initialization - must initialize with developer key for API" ; end
      if $_url.nil? || $_url.empty? ; $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - initialization - must initialize with site at with API is running" ; end

      post_type = data['type']
      method = data['method']
      headers = {
        'X-NAAMA-CLIENT-AUTHENTICATION' => 'id="' + $_key + '", version="1"',
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
      query = _make_request_str(data['data_params'], '&')

      method = 'u' if method == 'uN'
      url_params = "/#{method}/" + (data['url_params'].join '/')

      rest_url = "#{$_url}#{url_params}"
      # puts "REST URL: #{rest_url}"

      uri = URI.parse(rest_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl=true;http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme.downcase == 'https'

      if (data['method'] == 'u')
        if ($_email.empty? || $_email.nil?) || ($_password.empty? || $_password.nil?)
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - user API - valid email and password required to access user API"
        end

        headers['X-NAAMA-AUTHENTICATION'] = 'username="' + $_email + '", response="'  + (Digest::SHA2.new << ($_password+ $_email + url_params)).to_s + '", version="1"';
      end

      unless $_errors.empty?
        raise 'Errors Encountered: ' + ($_errors.join '\n')
      end

      # puts "Do my request" 
      # puts "URL     : #{$_url}"
      # puts "Type    : #{post_type}\nMethods : #{method}"
      # puts "Data    : " + data.inspect
      # # puts "Headers : " + headers.inspect
      # headers.map {|h,h2| puts "Header  : #{h}: #{h2}"}
      # puts 'Header F:' + headers.inspect
      # puts "Query   : " + query
      # puts "URL P   : " + url_params

      ## Do the call
      case post_type.downcase
      when 'get'
        return http.get(uri.path, headers).body
      when 'post'
        return  http.post(uri.path, query, headers).body
      when 'delete'
        return http.delete(uri.path, headers).body
      else
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - user API - Invalid request method (#{post_type})"
        raise 'Errors Encountered: ' + ($_errors.join '\n')
      end ## CASE
    end


    ## For debug, the string representation of this
    # def to_s
    #   puts "** DEBUG INFORMATION **"
    #   printf "%10s : %s\n", "Key", $_key
    #   printf "%10s : %s\n", "URL", $_url
    #   printf "%10s : %s\n", "Email", $_email
    #   printf "%10s : %s\n", "Password", $_password
    #   printf "%10s : %s\n", "Errors", $_errors
    #   print "*" * 23
    # end

    def valid_number(num)
      begin Float(num)
        return true
      end
    rescue
      return false
    end

  end ## OrdrIn Class
  ## ---------------------------------------------------------------------------------------- ##  

  ## -------------------------- DT     CLASS ------------------------------------------------ ##
  class DT
    attr_accessor :date, :asap

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
        return '0'
      end
    end

    def _convertForAPI
      unless @asap
        return @date.month.to_s + '-' + @date.day.to_s + '+' + @date.hour.to_s + ':' + @date.minute.to_s
      else
        return "ASAP"
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
    attr_accessor :street, :city, :zip, :street2, :state, :phone, :nick

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
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Zip code invalid (#{@zip})"
      elsif (element == 'phone' && !(@phone =~ %r{(^\(?(\d{3})\)?[- .]?(\d{3})[- .]?(\d{4})$)}i))
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Phone number invalid (#{@phone})"
      elsif (element == 'city' && !(@city =~ %r{[A-z.-]}))
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - City (invalid, only letters/spaces allowed) (#{@city})"
      elsif (element == 'state' && !(@state =~ %r{^([A-z]){2}$}))
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - State (invalid, only letters allowed and must be passed as two-letter abbreviation) (#{@state})"
      else ## Do all 
        if (!(@zip =~ %r{(^\d{5}$)|(^\d{5}-\d{4}$)}i)) ## Validate Zip
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Zip code invalid (#{@zip})"
        end

        if (!(@phone =~ %r{(^\(?(\d{3})\)?[- .]?(\d{3})[- .]?(\d{4})$)}i))
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Phone number invalid (#{@phone})"
        end

        if (!(@city =~ %r{[A-z.-]}))
          $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - City (invalid, only letters/spaces allowed) (#{@city})"
        end

        if (!(@state =~ %r{^([A-z]){2}$}))
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
    attr_accessor :amount

    def initialize(amt)
      @amount = -0.00

      begin Float(amt)
        @amount = amt
      end
    rescue
      $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") - validation - Money - Validation - must be a number, we got (#{amt})"
    end

    def _convertForAPI
      if @amount.is_a?String
        @amount = @amount.to_f
      end

      return @amount
    end

    def to_s
      puts('********* DEBUG INFO - Class Money ***********')
      printf("%10s : %.2f\n", 'Amount', @amount)
      puts '*' * 46
    end
  end
  ## ---------------------------------------------------------------------------------------- ##  

  ## Main Classes ##
  ## -------------------------- Restaurant CLASS -------------------------------------------- ##
  class Restaurant < API
    def initialize
    end

    def delivery_list(dt, addr)
      addr.validate
      return _request({
        'type' => 'GET',
        'method' => 'dl',
        'url_params' => [dt._convertForAPI, addr.zip, addr.city, addr.street],
        'data_params' => {}
      })
    end

    def delivery_check(id, dt, addr)
      unless valid_number(id) 
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Restaurant - delivery_check - Validation - restaurant ID (invalid, must be numeric) we got (#{id})"
      end

      addr.validate
      return _request({
        'type' => 'GET',
        'method' => 'dc',
        'url_params' => [id, dt._convertForAPI, addr.zip, addr.city, addr.street],
        'data_params' => {}
      })
    end

    def delivery_fee(id, subtotal, tip, dt, addr)
      unless valid_num(id)
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Restaurant - delivery_check - Validation - restaurant ID (invalid, must be numeric) we got (#{id})"
      end

      addr.validate
      return _request({
        'type' => 'GET',
        'method' => 'fee',
        'url_params' => [
          id, 
          subtotal._convertForAPI,
          tip._convertForAPI,
          dt._convertForAPI,
          addr.zip,
          addr.city,
          addr.street
        ],
        'data_params' => {}
      })
    end

    def details(id)
      unless valid_number(id)
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Restaurant - delivery_check - Validation - restaurant ID (invalid, must be numeric) we got (#{id})"
      end

      return _request({
        'type' => 'GET',
        'method' => 'rd',
        'url_params' => [id],
        'data_params' => {}
      })
    end

    def to_s
      str = '********* DEBUG INFO - Class Restaurant ***********' 
      puts str
      puts '*' * str.size
    end
  end
  ## ---------------------------------------------------------------------------------------- ##  

  ## -------------------------- Order      CLASS -------------------------------------------- ##
  class Order < API
    def initialize      
    end

    def submit(id, tray, tip, dt, email, first_name, last_name, addr, card_name, card_number, card_cvc, card_exp, cc_addr)

      #Do the validations
      addr.validate
      cc_addr.validate
      unless valid_number(id)
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Order - submit - Validation - restaurant ID (invalid, must be numeric) we got (#{id})"
      end
      
      unless card_number =~ $_cc_re
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Order - submit - Validation - credit card number (invalid) (#{card_number})"
      end

      unless valid_number(card_cvc)
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Order - submit - Validation - credit card security code (invalid, must be numeric) (#{card_cvc})"
      end

      unless email =~ $_email_regex
        $_errors << File.basename(__FILE__) + " (" + __LINE__.to_s + ") Order - submit - Validation - email (invalid) (#{email})"
      end

      if (dt.asap)
        date = "ASAP"
        time = ""
      else
        date = dt._strAPI('month') + '-' + dt._strAPI('day')
        time = dt._strAPI('hour') + ':' + dt._strAPI('minute')
      end

      return _request({
        'type' => 'POST',
        'method' => 'o',
        'url_params' => [id],
        'data_params' => {
          'tray' => tray,
          'tip' => tip._convertForAPI,
          'delivery_date' => date,
          'delivery_time' => time,
          'first_name' => first_name,
          'last_name' => last_name,
          'addr' => addr.street,
          'city' => addr.city,
          'state' => addr.state,
          'zip' => addr.zip,
          'phone' => addr.phone,
          'em' => email,
          'card_name' => card_name,
          'card_number' => card_number,
          'card_expiry' => card_exp,
          'card_cvc' => card_cvc,
          'card_bill_addr' => cc_addr.street,
          'card_bill_addr2' => cc_addr.street2,
          'card_bill_city' => cc_addr.city,
          'card_bill_state' => cc_addr.state,
          'card_bill_zip' => cc_addr.zip,
          'type' => 'RES'
        }
      })
    end


  end
  ## ---------------------------------------------------------------------------------------- ##  

  ## -------------------------- Order      CLASS -------------------------------------------- ##
  class User < API
    def initialize
    end
    
    def make_acct(email, password, first_name, last_name)
      return _request({
        'type' => 'POST',
        'method' => 'uN',
        'url_params' => [email],
        'data_params' => {
          'password' => password,
          'first_name' => first_name,
          'last_name' => last_name
        }
      })
    end
    
    def get_acct
      return _request({
        'type' => 'GET',
        'method' => 'u',
        'url_params' => [$_email],
        'data_params' => {}
      })
    end
    
    def get_address(addr_nick=nil)
      if (addr_nick.empty?)
        return _request({
          'type' => 'GET',
          'method' => 'u',
          'url_params' => [
            $_email,
            'addrs',
            addr_nick
          ]
        })
      else
        return _request({
          'type' => 'GET',
          'method' => 'u',
          'url_params' => [
            $_email,
            'addrs'
          ],
          'data_params' => {}
        })
      end
    end
    
    def update_address(addr)
      addr.validate
      
      return _request({
        'type' => 'PUT',
        'method' => 'u',
        'url_params' => [
          $_email,
          'addrs',
          addr.nick
        ],
        'data_params' => {
          'addr' => addr.street,
          'addr2' => addr.street2,
          'city' => addr.city,
          'state' => addr.state,
          'zip' => addr.zip,
          'phone' => addr.phone
        }
      })
    end
    
    def delete_address(addr_nick)
      return _request({
        'type' => 'DELETE',
        'method' => 'u',
        'url_params' => [
          $_email,
          'addrs',
          addr_nick
        ],
        'data_params' => {}
      })
    end

    def get_card(card_nick=nil)
      unless card_nick.nil?
        return _request({
          'type' => 'GET',
          'method' => 'u',
          'url_params' => [
            $_email,
            'ccs',
            card_nick
          ],
          'data_params' => {}
        })
      else
        return _request({
          'type' => 'GET',
          'method' => 'u',
          'url_params' => [
            $_email,
            'ccs',
          ],
          'data_params' => {}
        })
      end      
    end

    def update_card(card_nick, name, number, cvv, exp_month, exp_year, addr)
      addr.validate

      return _request({
        'type' => 'PUT',
        'method' => 'u',
        'url_params' => [
          $_email,
          'ccs',
          card_nick
        ],
        'data_params' => {
          'name' => name,
          'number' => number,
          'cvc' => cvv,
          'expiry_month' => expiry_month,
          'expiry_year' => expiry_year,
          'bill_addr' => addr.street,
          'bill_addr2' => addr.street2,
          'bill_city' => addr.city,
          'bill_state' => addr.state,
          'bill_zip' => addr.zip,
        }
      })
    end

    def delete_card(card_nick)
        return _request({
          'type' => 'DELETE',
          'method' => 'u',
          'url_params' => [
            $_email,
            'ccs',
            card_nick
          ],
          'data_params' => {}
        })
    end

    def order_history(id=nil)
      unless id.nil?
        return _request({
          'type' => 'GET',
          'method' => 'u',
          'url_params' => [
            $_email,
            'order',
            id
          ],
          'data_params' => {}
        })
      else
        return _request({
          'type' => 'GET',
          'method' => 'u',
          'url_params' => [
            $_email,
            'orders'
          ],
          'data_params' => {}
        })
      end
    end

    def update_password(password)
        return _request({
          'type' => 'PUT',
          'method' => 'u',
          'url_params' => [
            $_email,
            'password'
          ],
          'data_params' => {
            'password' => (Digest::SHA2.new << $_password).to_s
          }
        })
    end
  end ## End User Class
  ## ---------------------------------------------------------------------------------------- ##  
end
