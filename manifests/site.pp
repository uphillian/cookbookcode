node cookbook {
  $mysql_password='TopSecret'
  file { '/usr/local/bin/backup-mysql':
    content => template('admin/backup-mysql.sh.erb'),
    mode    => '0755',
  }
  $ipaddresses = ['192.168.0.1','158.43.128.1', '10.0.75.207' ]
  file { '/tmp/addresslist.txt':
    content => template('base/addresslist.erb')
  }
  $message = secret('/etc/puppetlabs/code/environments/production/modules/admin/files/secret_message.gpg')
  notify { "The secret message is: ${message}": }
}

node webserver {
  #  class {'apache': }
  #apache::vhost { 'navajo.example.com':
  #  port    => '8080',
  #  docroot => '/var/www/navajo',
  #}
  #$navajo = @(NAVAJO)
  #  <html>
  #    <head>
  #      <title>navajo.example.com</title>
  #    </head>
  #    <body>http://en.wikipedia. org/wiki/Navajo_people
  #    </body>
  #  </html>
  #  | NAVAJO
  #file {'/var/www/navajo/index.html':
  #  content => $navajo,
  #  mode => '0644',
  #  require => Apache::Vhost['navajo.example.com']
  #}
  class {'nginx': }
  nginx::resource::vhost{ 'mescalero.example.com':
    www_root => '/var/www/mescalero',
  }
  file {'/var/www/mescalero':
    ensure  => 'directory',
    mode    => '0755',
    require => Nginx::Resource::Vhost['mescalero.example.com'],
  }
  $mescalero = @(MESCALERO)
    <html>
      <head>
        <title>mescalero.example.com</title>
      </head>
      <body>
        http:// en.wikipedia.org/wiki/Mescalero
      </body>
    </html>
    | MESCALERO
  file {'/var/www/mescalero/index.html':
    content => $mescalero,
    mode    => '0644',
    require => File['/var/www/mescalero'],
  }
}

node default {
  include base
  include puppet
}



