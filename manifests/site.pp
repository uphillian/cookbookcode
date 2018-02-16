node cookbook {
  $mysql_password='TopSecret'
  file { '/usr/local/bin/backup-mysql':
    content => template('admin/backup-mysql.sh.erb'),
    mode    => '0755',
  }
}

node default {
  include base
  include puppet
}
