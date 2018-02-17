module Puppet::Parser::Functions
  newfunction(:secret, :type => :rvalue) do |args|
    `/usr/bin/env gpg --no-tty -d #{args[0]}`
  end
end

