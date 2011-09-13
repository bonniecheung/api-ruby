#!/usr/bin/env ruby -wKU

## Attempt to pull in the GEM
begin
  require 'rubygems'
  require 'ordrin'
rescue Exception => msg
  ## Okay no good .. add the lib and use that
  puts "Gem is not installed, loading local library"
  $LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
  require 'ordrin'
end

puts "OrdrIn RUBY API Demo"
puts "Defaulting to time: ASAP"
puts "Defaulting to College Station, TX address"

place = OrdrIn::Address.new("1 Main St", "College Station", "77840", '', "TX", "7777777777", 'home')
dt = OrdrIn::DT.new
dt.asap = true
$api = OrdrIn::API.new('', '')

## --------- Functions ------------ ##
def raw_input(prompt)
  print prompt
  input = STDIN.gets
  input.strip!
end

def setup_account
  user = raw_input('Username: ')
  pass = raw_input('Password: ')
  $api.set_curr_acct(user,pass)
end
######################################



if ARGV.empty?
  ## Ask 
  puts "Which API do try?"
  type = raw_input("[R]estaurant [U]ser [O]rder: ")
else
  type = ARGV[0]
end

type.strip!

case type.downcase
when 'r'
  $api = OrdrIn::API.new('mlJhC8iX4BGWVtn', 'https://r-test.ordr.in')
  setup_account
  action = raw_input('Which action would you like to run? [a] Delivery list [b] Delivery check [c] Delivery fee [d] Restaurant details (enter nothing to exit) ')
  r = OrdrIn::Restaurant.new

  case action.downcase
  when 'a'
    r.delivery_list(dt, place)
  when 'b'
    rid = raw_input("Restaurant ID? ")
    r.delivery_check(rid, dt, place)
  when 'c'
    rid = raw_input("Restaurant ID? ")
    st = OrdrIn::Moneny.new(raw_input("Subtotal: "))
    tip = OrdrIn::Moneny.new(raw_input("Tip: "))
    r.delivery_fee(rid, st, tip, dt, place)
  when 'd'
    rid = raw_input("Restaurant ID? ")
    r.details(rid)
  else
    Process.exit
  end
when 'u'
  $api = OrdrIn::API.new('mlJhC8iX4BGWVtn', 'https://u-test.ordr.in')
  u = OrdrIn::User.new

  action = raw_input("What kind of action would you like to run? [a] Account [b] Address [c] Card [d] Previous order[s] (enter nothing at any time to exit) ")
  case action.downcase
  when 'a'
    subaction = raw_input("[a] Make account [b] Get account details [c] Update password")
    case subaction.downcase
    when 'a'
      email = raw_input('Email: ')
      password = raw_input('Password: ')
      fname = raw_input('First Name: ')
      lname = raw_input('Last Name :')
      u.make_acct(email, password, fname, lname)
    when 'b'
      setup_account
      u.get_acct
    when 'c'
      setup_account
      newpass = raw_input('New Password: ')
      u.update_password(newpass)
    else
      Process.exit
    end ## Subaction
  when 'b'
    setup_account
    subaction = raw_input("[a] Get address [b] Update address [c] Delete address ")
    case subaction.downcase
    when 'a'
      nick = raw_input('Address nickname (enter none to return list): ')
      u.get_address(nick)
    when 'b'
      nick = raw_input('Address nickname: ')
      street = raw_input('Street: ')
      street2 = raw_input('Street 2: ')
      city = raw_input('City: ')
      state = raw_input('State (2 letter abbreviation): ')
      zip = raw_input('Zip: ')
      phone = raw_input('Phone: ')
      addr = OrdrIn::Address.new(street, city, zip, street2, state, phone, nick)
      u.update_addr(addr)
    when 'c'
      nick = raw_input('Address nickname: ')
      u.delete_address(nick)
    else
      Process.exit
    end ## Subaction
  when 'c'
    setup_account
    subaction = raw_input("[a] Get card [b] Update card [c] Delete card ")
    case subaction.downcase
    when 'a'
      nick = raw_input('Card Nickname (enter none to return list): ')
      u.get_card(nick)
    when 'b'
      nick = raw_input('Card Nickname: ')
      name = raw_input('Name on card: ')
      number = raw_input('Card Number: ')
      cvc = raw_input('Security Code: ')
      expM = raw_input('Expiry Month: ')
      expY = raw_input('Expiry Year : ')
      street = raw_input('Street : ')
      street2 = raw_input('Street2:')
      city = raw_input('City: ')
      state = raw_input('State (2 letter abbreviation): ')
      zip = raw_input('Zip: ');
      phone = raw_input('Phone: ')
      addr = OrdrIn::Address.new(street, city, zip, street2, state, phone)
      u.update_card(nick, name, number, cvc, expM, expY, addr)
    when 'c'
      nick = raw_input('Card Nickname: ')
      u.delete_card(nick)
    else
      Process.exit
    end ## Subaction
  when 'd'
    setup_account
    subaction = raw_input('Type in order ID (or nothing to list all): ')
    u.order_history(subaction)
  else
    Process.exit
  end
when 'o'
  $api = OrdrIn::API.new('mlJhC8iX4BGWVtn', 'https://o-test.ordr.in')
  o = OrdrIn::Order.new
  setup_account

  rid = raw_input('Restaurant ID: ')
  tray = raw_input('Tray [itemid][quantity],[itemid2][quantity],... : ')
  tip = raw_input('Tip: ')
  email = raw_input('Email: ');
  fname = raw_input('First Name: ')
  lname = raw_input('Last Name : ')
  cardnum = raw_input('Card Number: ')
  cvc = raw_input('Card Security Code: ')
  exp = raw_input('Expiration month+year (MM/YY): ')
  o.submit(rid, tray, OrdrIn::Money.new(tip), dt, email, fname, lname, place, "#{fname} #{lname}", cardnum, cvc, exp, place)

end # CASE TYPE
