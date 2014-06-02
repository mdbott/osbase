# == Classification: Unclassified (provisional)
# == Class: sudo
#
# Allocate additional rights to users with sudo
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
#
# == Examples
#
# # TODO how does this tie into admin_users usesudo option?
# node foo inherits dsdldapnode {
#   class {'pkg_management': stage => pre4 }
#   include sudo
#   sudo::user { 'username':
#     ensure   => present,
#     commands => '/bin/bash',
#   }
# }
#
# == Maintainers
#
# SSU
#
class sudo($authentication='local') {
  require sudo::params

  $fragment_dir = $sudo::params::fragment_dir

  package { 'sudo':
    ensure    => latest,
    name      => $sudo::params::sudo_package,
    provider  => $sudo::params::sudo_provider,
    before    => File["$sudo::params::sudo_configfile"]
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '0440',
  }

  file { "$sudo::params::sudo_configfile":
    ensure  => present,
    alias   => 'sudoers',
    content => template('sudo/sudoers.erb'),
  }
  
  
  
  file { "$fragment_dir":
    ensure  => directory,
    purge   => true,
    recurse => true,
    backup  => false,  
  }
  
  if $sudo::params::sudo_conf_version== 'Solaris' {
      file { "$sudo::params::sudo_configfile2":
        ensure  => present,
        alias   => 'sudoers2',
        content => template('sudo/sudoers.erb'),
      }  
  }
  
  if $authentication == 'ldap' {
    $ldap_servers      = extlookup("ldapservers")
    $base_dn_array     = split(extlookup("base_dn"),':')
    $base_dn           = inline_template("<%= @base_dn_array.flatten.join(',') %>")
    $ldapencrypt       = extlookup("ldapencrypt")
    if $ldapencrypt == 'yes' {
      $ldapuri = 'ldaps://'
    } else {
      $ldapuri = 'ldap://'
    }
    file { "/etc/sudo-ldap.conf":
      ensure  => present,
      content => template('sudo/sudo-ldap.conf.erb'),
    }
  }

}
