# == Classification: Unclassified (provisional)
#
# == Class: nsswitch
#
# Setup /etc/nsswitch.conf
#
# Should be run in the same stage as the dns module
#
# The reason this is in the separate module is multiple
# modules have to touch this file, so it seemed cleanest
# to have a separate module, also solved race conditions
#
# == Future Directions
#
#
# == Parameters
#
# [*type*]
#   nsswitch.conf variant, either 'ldap' or 'local',
#   defaults to local
#
# == Variables
#
#
# == Examples
#
#   # Local auth
#   include stages
#   class {'dns':      stage => pre4 }
#   class {'nsswitch': stage => pre4, type => 'local' }
#
# == Maintainers
#
# SSU
#
class nsswitch ($type = 'local') {
  
  $sssd_supported_release = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10' => false,
    'Solaris5.11' => false,
    'RedHat6.0' => true,
    'RedHat6.1' => true,
    'RedHat6.2' => true,
    'RedHat6.3' => true,
    'RedHat6.4' => true,
    'RedHat6.5' => true,
    'RedHat5.5' => false,
    'RedHat5.6' => false,
    'RedHat5.7' => false,
    'RedHat5.8' => true,
    'RedHat5.9' => true,
    default     => false,
  }

  Class['dns'] -> Class['nsswitch']
  case $type {
    'ldap': {
      Class['nsswitch'] -> Class['ldap']
      if $sssd_supported_release {
        $ldaptype = extlookup("ldaptype")
        $authtype = "ldap-${ldaptype}"
      } 
      else {
        $authtype = "ldap-old"
      }
      
    }  
    'winbind': {  
      Class['nsswitch'] -> Class['winbind']
      $authtype = $type
    }
    'barry': {  
      package { 'libsss_sudo':
        ensure => present,
      }
      $authtype = $type
    }
    default  : {
      $authtype = $type
      }
    
    }
  if "${::operatingsystem}${::operatingsystemrelease}" == 'Solaris5.11' {
    
    file { '/etc/nsswitch.conf':
      ensure => 'present',
      owner  => 'root',
      group  => 'sys',
      mode   => '0644',
      source => "puppet:///modules/nsswitch/etc_nsswitch.conf.${authtype}.Solaris11",
    }
    exec { 'import nsswitch':
      command     => "/usr/sbin/nscfg import -f svc:/system/name-service/switch:default",
      refreshonly => true,
      subscribe   => File["/etc/nsswitch.conf"],
    }
    service {'name-service/switch':
      ensure     => running,
      enable     => true,
      require => Exec['import dns'],
    }
  } else {
    file { '/etc/nsswitch.conf':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/nsswitch/etc_nsswitch.conf.${authtype}",
    }
  }
  

}
