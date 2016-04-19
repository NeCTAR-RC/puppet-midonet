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

  if $::lsbdistcodename == 'xenial' {
    file {'/etc/systemd/system/midonet-cluster.service':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/midonet/cluster/midonet-cluster.service',
      before => Service['midonet-cluster'],
    }
  }

  service {'midonet-cluster':
    ensure  => running,
    enable  => true,
    require => Package['midonet-cluster'],
  }

}
