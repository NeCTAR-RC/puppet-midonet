# == Class: midonet::repository::ubuntu
# NOTE: don't use this class, use midonet::repository(::init) instead
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2015 Midokura SARL, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class midonet::repository::ubuntu (
  $midonet_repo,
  $midonet_stage,
  $midonet_openstack_repo,
  $midonet_thirdparty_repo,
  $midonet_key,
  $midonet_key_url,
  $openstack_release)
{
  # Adding repository for ubuntu
  if $::lsbdistrelease == '16.04' or $::lsbdistrelease == '14.04' or $::lsbdistrelease == '12.04' {
    if $::lsbdistrelease == '12.04' and $openstack_release == 'juno' {
      fail ('Ubuntu 12.04 only supports icehouse')
    }
    notice('Adding midonet sources for Debian-like distribution')

    # Update the package list each time a package is defined. That takes
    # time, but it ensures it will not fail for out of date repository info
    # Exec['apt_update'] -> Package<| |>


    if $::http_proxy and str2bool($::rfc1918_gateway) {
      $key_options = "http-proxy=${::http_proxy}"
    }
    else {
      $key_options = undef
    }

    apt::key { 'midonet':
      id      => $midonet_key,
      source  => $midonet_key_url,
      options => $key_options,
    }

    apt::source {'midonet':
      comment     => 'Midonet apt repository',
      location    => $midonet_repo,
      release     => $midonet_stage,
    }

    apt::source {'midonet-openstack-integration':
      comment     => 'Midonet apt plugin repository',
      location    => $midonet_openstack_repo,
      release     => $midonet_stage,
    }

    apt::source {'midonet-third-party':
      comment     => 'MidoNet 3rd Party Tools and Libraries repository',
      location    => $midonet_thirdparty_repo,
      release     => $midonet_stage,
    }
  }

  else
  {
    fail("${::lsbdistid} ${::lsbdistrelease} version not supported")
  }
}
