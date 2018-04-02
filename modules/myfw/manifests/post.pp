class myfw::post {
  firewall { '9000 Drop all other traffic':
    proto  => 'all',
    action => 'drop',
    before => undef,
  } 
}

