class OrdrIn
  attr_accessor :_email, :_password, :_url, :_key, :_errors
  # @@_email_regex = '^[a-zA-Z0-9._%-+]+@[a-zA-Z0-9._%-]+.[a-zA-Z]{2,6}$'
  # @@_email_regex = '^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$';
  @@_email_regex = %r{^[0-9a-z][0-9a-z.+]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z]$}xi

  def initialize(key, url)
    self._key=key
    self._url=url

    self._errors = []
  end

  def setCurrAcct(email, pass)

    unless email =~ @@_email_regex
      ## Error
      @@_errors[] = __FILE__ + " setCurrAcct - validation - email invalid ($email)";
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
    printf "%10s : %s\n", "Errors", self._errors
    puts "*" * 23
  end
end