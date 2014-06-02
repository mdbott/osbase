# == Classification: Unclassified (provisional)
#
class nslcd::package{
  package { 'nss-pam-ldapd':
    ensure => present,
  }
}