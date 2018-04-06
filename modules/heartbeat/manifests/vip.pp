# Manage a specific VIP with Heartbeat
class heartbeat::vip(
  String $node1,
  String $node2,
  String $ip1,
  String $ip2,
  String $vip,
  String $interface='eth0:1'
) {
  include heartbeat

  file { '/etc/ha.d/haresources':
    content => "${node1} IPaddr::${vip}/${interface}\n",
    require => Package['heartbeat'],
    notify  => Service['heartbeat'],
  }

  $ha_cf = @("HACF")
    use_logd yes
    udpport 694
    autojoin none
    ucast eth0 $ip1
    ucast eth0 $ip2
    keepalive 1
    deadtime 10
    warntime 5
    auto_failback off
    node $node1
    node $node2
    | HACF
  file { '/etc/ha.d/ha.cf':
    content => $ha_cf,
    require => Package['heartbeat'],
    notify  => Service['heartbeat'],
  }
}
