module Puppet::Parser::Functions
  newfunction(:secret, :type => :rvalue) do |args|
    `/bin/gpg --no-tty -d #{args[0]}`
  end
end

