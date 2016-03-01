class midonet::midolman(
  $zk_servers,
  $resource_type='compute',
  $resource_flavor='large',
)
{

  package {'midolman':
    ensure  => present,
  }

  file {'/etc/midolman/midolman.conf':
    ensure  => present,
    content => template('midonet/midonet.conf.erb'),
    require => Package['midolman'],
    notify  => Service['midolman'],
  }

  service {'midolman':
    ensure  => running,
    require => Package['midolman'],
  }

  exec {'mn-set-template':
    command => "mn-conf template-set -h local -t agent-${resource_type}-${resource_flavor}",
    path    => '/usr/bin:/bin',
    unless  => "mn-conf template-get -h local | grep agent-${resource_type}-${resource_flavor}",
    require => Package['midolman'],
  }

  file {'/etc/midolman/midolman-env.sh':
    ensure  => link,
    target  => "/etc/midolman/midolman-env.sh.${resource_type}.${resource_flavor}",
    require => Package['midolman'],
    notify  => Service['midolman'],
  }

}
