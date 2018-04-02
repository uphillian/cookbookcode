class myfw::post {
  firewall { '8999 Drop all other traffic':
    proto  => 'all',
    action => 'drop',
    before => undef,
  } 
}

