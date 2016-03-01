class midonet::cluster($zk_servers)
{

  package {'midonet-cluster':
    ensure  => present,
  }

  file {'/etc/midonet/midonet.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('midonet/midonet.conf.erb'),
    notify  => Service['midonet-cluster'],
    require => Package['midonet-cluster'],
  }

  service {'midonet-cluster':
    ensure  => running,
    enable  => true,
    require => Package['midonet-cluster'],
  }

}
