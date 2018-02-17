module Puppet::Parser::Functions
  newfunction(:secret, :type => :rvalue) do |args|
    system("/bin/gpg --no-tty -d #{args[0]}")
  end
end

