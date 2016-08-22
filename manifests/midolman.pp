class midonet::midolman(
  $zk_servers,
  $resource_type='compute',
  $resource_flavor='large',
  $template=undef,
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

  if $template {
    $_template = $template
  } else {
    $_template = "agent-${resource_type}-${resource_flavor}"
  }

  exec {'mn-set-template':
    command => "mn-conf template-set -h local -t ${_template}",
    path    => '/usr/bin:/bin',
    unless  => "mn-conf template-get -h local | grep ${_template}",
    require => Package['midolman'],
  }

  file {'/etc/midolman/midolman-env.sh':
    ensure  => link,
    target  => "/etc/midolman/midolman-env.sh.${resource_type}.${resource_flavor}",
    require => Package['midolman'],
    notify  => Service['midolman'],
  }

}
