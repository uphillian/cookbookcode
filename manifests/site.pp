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
  $message = secret('/etc/puppet/environments/production/modules/admin/files/secret_message.gpg')
  notify { "The secret message is: ${message}": }
}

node default {
  include base
  include puppet
}
