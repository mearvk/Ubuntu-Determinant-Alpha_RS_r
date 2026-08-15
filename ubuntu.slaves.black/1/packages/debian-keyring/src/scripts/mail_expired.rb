#!/usr/bin/ruby
# coding: utf-8
require 'yaml'

ARGV[0] == '--send' or
  raise RuntimeError, 'This will send many mails! Are you sure? Tell me to "--send"'

%w(debian-keyring-gpg debian-maintainers-gpg debian-nonupload-gpg .git).each do |ck|
  Dir.exists?(ck) or raise RuntimeError, 'Please run this script from the base keyring-maint git tree'
end

data = `make test`.split(/\n/).select {|lin| lin=~/expired on/}
keys = {}
expired_keys = {'keyring' => [],
                'maintainers' => [],
                'nonupload' => []}

File.open('keyids','r') do |f|
  f.readlines.each do |l|
    l=~/^(0x[\dABCDEF]+) (.+) <(.+)>$/; keys[$1] = [$2,$3]
  end
end

data.each do |l|
  l=~/debian-(\w+).gpg:\s*(0x[\dABCDEF]+) expired on (.+) \(\)\s*$/
  persondata = keys[$2] || ['NM (?)', nil]
  expired_keys[$1] << {:key => $2, :name => persondata[0], :login => persondata[1],  :date => $3}
end

proposed_exp = (Time.now + 2*365*86400).strftime '%a %d %b %Y %I:%M:%S %p %Z'
expired_keys.each do |keyring, exp_k|
  next if keyring == 'maintainers'
  exp_k.each do |key|
    IO.popen('mutt %s@debian.org -c keyring-maint@debian.org -s "Expired key in Debian -- %s (since %s)" -H -' %
             [key[:login], key[:key], key[:date]], 'w') do |f|

      f.puts 'From: Debian Keyring Maintainers <keyring-maint@debian.org>

Hello %s <%s@debian.org>,

According to our records, your key «%s», part of the Debian
%s keyring, is expired since %s — Which means you will
be, among other issues, not able to perform package uploads or vote in GRs!

Please review your key\'s expiry date setting it to a sensible date in
the future, and send it to our HKP server:

    $ gpg --edit-key %s
    (...)
    gpg> expire
    (...)
    Key is valid for? (0) 2y
    Key expires at %s
    Is this correct? (y/N) y
    (...)
    gpg> save
    $ gpg --keyserver keyring.debian.org --send-key %s

And we will include it in our next keyring push (due towards the end
of each month).

Thanks,

    - Gunnar Wolf
      on behalf of the keyring maintenance team
' % [ key[:name], key[:login], key[:key], keyring, key[:date], key[:key], proposed_exp, key[:key]   ]
    end
  end
end
