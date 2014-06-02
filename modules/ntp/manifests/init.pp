# == Classification: Unclassified (provisional)
#
# == Class: ntp
#
# Installs and configures ntp client
#
# == Future Directions
#
#
# == Parameters
#
#
# == Variables
#
#
# == Extlookup
#
# [*ntpservers*]
#   Comma separated list of ntp servers to use
# [*clustersystem*]
#   'true' or 'false', other than use a different conf file, not sure what this
#   variables greater plan/meaning is TODO
#
# == Examples
#
#   include ntp
#
# == Maintainers
#
# SSU
#
class ntp {
  require ntp::params
  $ntp_server_list = extlookup("ntpservers")
  $cluster_system = extlookup("clustersystem")

  package { 'ntp':
    ensure => installed,
    name   => $ntp::params::ntp_package,
  }

  file { 'ntp.conf':
    path    => $ntp::params::ntp_configfile,
    content => $cluster_system ? {
      'true'  => template("ntp/ntp.conf-${ntp::params::ntp_conf_version}.cluster"),
      'false' => template("ntp/ntp.conf-${ntp::params::ntp_conf_version}"),
    },
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => Service['ntp'],
    require => Package['ntp'],
  }

  if $ntp::params::ntp_dhcp_script != undef {
    file { $ntp::params::ntp_dhcp_script:
      ensure => absent
    }
  }

  service { 'ntp':
    ensure     => running,
    name       => $ntp::params::ntp_service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
