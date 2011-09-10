#
# Order.in Ruby Library Alpha
# http://ordr.in
#
# (c) 2011
# Last update: September 2011
#

$_errors  = Array.new ## Errors array

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
end