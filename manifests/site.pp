#node cookbook {
  #$mysql_password='TopSecret'
  #file { '/usr/local/bin/backup-mysql':
  #  content => template('admin/backup-mysql.sh.erb'),
  #  mode    => '0755',
  #}
  #$ipaddresses = ['192.168.0.1','158.43.128.1', '10.0.75.207' ]
  #file { '/tmp/addresslist.txt':
  #  content => template('base/addresslist.erb')
  #}
  #$message = secret('/etc/puppetlabs/code/environments/production/modules/admin/files/secret_message.gpg')
  #notify { "The secret message is: ${message}": }
  #include myfw
  #firewall {'0080 Allow HTTP':
  #  proto  => 'tcp',
  #  action => 'accept',
  #  dport  => 80,
  #}
  #}
node cookbook,cookbook2 {
  class { 'keepalived':
    real_servers => ['192.168.50.10', '192.168.50.8'],
    vip          => '192.168.50.100',
  }
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
  service {'httpd': ensure => false }
  class {'nginx': }
  nginx::resource::server{ 'mescalero.example.com':
    www_root => '/var/www/mescalero',
  }
  file {'/var/www/mescalero':
    ensure  => 'directory',
    mode    => '0755',
    require => Nginx::Resource::Server['mescalero.example.com'],
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

node dbserver {
  class { 'mysql::server':
    root_password    => 'PacktPub',
    override_options => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }
  mysql::db { 'drupal':
    host     => 'localhost',
    user     => 'drupal',
    password => 'Cookbook',
    sql      => '/root/drupal.sql',
    require  => File['/root/drupal.sql']
  }
  $drupal = @(DRUPAL)
    CREATE TABLE users (
      id INT PRIMARY KEY AUTO_INCREMENT,
      title VARCHAR(255),
      body TEXT);
    INSERT INTO users (id, title, body) VALUES (1,'First Node','Contents of first Node');
    INSERT INTO users (id, title, body) VALUES (2,'Second Node','Contents of second Node');
    | DRUPAL
  file { '/root/drupal.sql':
    ensure => present,
    content => $drupal,
  }
  mysql_grant { 'drupal@localhost/drupal.nodes':
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'drupal.nodes',
    user       => 'drupal@localhost',
  }
}

node default {
  include base
  include puppet
}



