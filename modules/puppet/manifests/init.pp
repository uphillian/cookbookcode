class puppet {
  $papply = @("PAPPLY")
    #!/bin/sh
    cd /usr/local/git/cookbook
    sudo -u git git pull -q origin master
    sudo /opt/puppetlabs/bin/puppet apply \
      /usr/local/git/cookbook/manifests/site.pp \
      --modulepath=/usr/local/git/cookbook/modules $*
    | PAPPLY

  file { '/usr/local/bin/papply':
    content => $papply,
    mode    => '0755',
  }

  cron { 'run-puppet':
    ensure  => 'present',
    user    => 'root',
    command => '/usr/local/bin/papply',
    minute  => '*/10',
    hour    => '*',
    require => File['/usr/local/bin/papply'],
  }
}
