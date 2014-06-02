# == Classification: Unclassified (provisional)
#
class profile::osbase(
  $accountsource,
  $homedirsource
) {
  include stages
  class {'dns3':            stage => pre4}
  class {'policy':          stage => pre4}
  include ntp
  include sshd3
  class {'nsswitch3':       stage => pre4}
  class {'pam3':             stage => pre5}
  class {$accountsource:    stage => pre5}
  class {$homedirsource:    stage => pre5}
  include configpuppet::facts
  include configpuppet::owner_facts
}
class profile::os_monitoring {
  class {'pkg_management': stage => pre4 }
  include xymon
}

class profile::os_access {
  class {'pkg_management': stage => pre4 }
  include sudo
  sudo::netgroup { 'role-unix-support': ensure   => present,commands => 'ALL',}
  access::allowgroup { "access-${::fqdn}":        ensure => present}
  if $::operatingsystem == 'Solaris' {
    include role::solaris_essentials
  }
}
