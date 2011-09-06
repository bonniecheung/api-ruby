class OrdrIn
  attr_accessor :_email, :_password, :_url, :_key, :_errors
  @_email_regex = '^[a-zA-Z0-9._%-+]+@[a-zA-Z0-9._%-]+.[a-zA-Z]{2,6}$'

  def initialize(key, url)
    self._key=key
    self._url=url
  end

  def setCurrAcct(email, pass)
    #if /self.@_email_regex/.match(email)
    puts email =~ /@_email_regex/
    unless email =~ /@_email_regex/
      puts "if catch"
    else
      puts "Else if"
    end
    
    #self._email= email
    #self._password=pass
  end
  
  ## For debug, the string representation of this
  def to_s
    puts "** DEBUG INFORMATION **"
    printf "%10s : %s\n", "Key", self._key
    printf "%10s : %s\n", "URL", self._url
    printf "%10s : %s\n", "Email", self._email
    printf "%10s : %s\n", "Password", self._password
    printf "%10s : %s\n", "Errors", self._errors
    puts "*" * 23
  end
end