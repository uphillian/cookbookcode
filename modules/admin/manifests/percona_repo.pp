# Install Percona APT repo
class admin::percona_repo {
  exec { 'add-percona-apt-key':
    unless => '/usr/bin/apt-key list |grep percona',
    command => '/usr/bin/gpg --keyserver hkp://keys.gnupg.net --recv-keys 8507EFA5 && /usr/bin/gpg -a --export CD2EFD2A | apt-key add -',
    #command => '/usr/bin/gpg --keyserver hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && /usr/bin/gpg -a --export CD2EFD2A | apt-key add -',
    notify => Exec['percona-apt-update'],
  }
  exec { 'percona-apt-update':
    command => '/usr/bin/apt-get update',
    require => [
      File['/etc/apt/sources.list.d/percona.list'],    
      File['/etc/apt/preferences.d/00percona.pref']],
    refreshonly => true,
  }
  file { '/etc/apt/sources.list.d/percona.list':
    content => 'deb http://repo.percona.com/apt stretch main',
    notify => Exec['percona-apt-update'],
  }
  $percona = @(PERCONA)
    Package: *
    Pin: release o=Percona Development Team
    Pin-Priority: 1001
    | PERCONA
 file { '/etc/apt/preferences.d/00percona.pref':
   content => $percona,
   notify  => Exec['percona-apt-update'],
  }
}
