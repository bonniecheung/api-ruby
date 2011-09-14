Ordr.in Ruby API
======================

A Ruby Gem wrapper for the Restaurant, User, and Order APIs provided by Ordr.in.

Usage
-----
    If you are using the gem:
        require "rubygems"
        require "ordrin"
    If you are using the library:
        $LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
        require 'ordrin'
        
    OrdrIn::API.new("shds1d6c4BGDGs8", "http://localhost") # developer key and site where hosted
    
    place = OrdrIn::Address.new("1 Main St", "College Station", "77840", "Suite 200", "Texas", "4044099661", "Home") # street, city, zip, street2, state, phone, nickname
    date_time = OrdrIn::DT.new
    date_time.asap = true ## Turns on ASAP mode

    subT = OrdrIn::Moneny.new(100)
    tip = OrdrIn::Moneny.new(15)
    
    r = OrdrIn::Restaurant.new
    r.delivery_list(date_time, place) # time, location
    r.def delivery_check("142", date_time, place) # subtotal, time, location
    r.delivery_fee("142", subT, tip, date_time, place) # restaurant ID, subtotal, tip, time, location
    r.details("142") # restaurant ID

    u = OrdrIn::User.new
    u.makeAcct("test@test.com", "pass", "John", "Doe")

    api = OrdrIn::API.new
    api.set_curr_acct("test@test.com", "pass") # user and pass required to be set before using rest of User API
    
    u.update_address(place) # sets address with such a nickname if it does not yet exists, updates it if otherwise
    u.get_address("home") # returns details on address with given nickname
    u.delete_address("home") # deletes address with nickname
    
    u.update_card("personal", "John Doe", "4111111111111111", "444", "02", "12", place) # sets card with such a nickname if it does not yet exists, updates it if otherwise
    u.get_card("personal") # returns details on card with given nickname
    u.delete_card("personal") # deletes card with nickname
    
    u.order_history("12") # returns previous order; if no ID given, all previous orders listed
    
    u.update_password("newPassword") # sets new password
    
    o = OrdrIn::Order.new
    o.submit("142", tray, tip, date_time, "test@testing.com", "John", "Doe", place, "John Doe", "4111111111111111", "444", "0212", place) # tray as [item ID][quantity][options]-[item ID-2][quantity]

       
Notes
----- 
API docs available at http://www.ordr.in/developers/api.
