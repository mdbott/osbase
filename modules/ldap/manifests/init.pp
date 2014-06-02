# == Classification: Unclassified (provisional)
#
# == Class: ldap
#
# Enables LDAP authentication. As the ldap servers are specified by name not ip this module has an explicit
# dependency on the dns module which should be executed prior to ldap
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
# [*ldapservers*]
#   Comma separated list of LDAP servers to use for lookups
# [*base_dn*]
#   Base DN to use for LDAP lookups
# [*ldapprofile*]
#   Sets NS_LDAP_PROFILE variable in /var/ldap/ldap_client_file, Solaris only
# [*ldapcachettl*]
#   Sets NS_LDAP_CACHETTL variable in /var/ldap/ldap_client_file, Solaris only
# [*domainname*]
#   Sets the host's domain name in /etc/defaultdomain, Solaris only
#
# == Examples
#
#  class {'dns':                stage => pre4 }
#  class {'nsswitch':           stage => pre4, type => 'ldap' }
#  class {'pkg_management':     stage => pre4 }
#  class {'pam':                stage => pre5, authentication => 'ldap'}
#  class {'ldap':           stage => pre5 }
#
# == Maintainers
#
# SSU
#
class ldap {

  Class['dns']      -> Class['ldap']
  Class['nsswitch'] -> Class['ldap']
  Class['pam']      -> Class['ldap']

  $ldap_servers      = extlookup("ldapservers")
  $base_dn_array     = split(extlookup("base_dn"),':')
  $base_dn           = inline_template("<%= @base_dn_array.flatten.join(',') %>")
  $ldap_bindpassword = extlookup("ldapbindpassword")
  $ldap_profile      = extlookup("ldapprofile")
  $ldap_cachettl     = extlookup("ldapcachettl")
  $useldapprofile    = extlookup("useldapprofile")
  $domainname        = extlookup("domainname")
  $ldaptype          = extlookup("ldaptype")
  $ldapencrypt       = extlookup("ldapencrypt")
  $ldapcertname      = extlookup("ldapcertname")
  $ldapservertype    = extlookup("ldapservertype")
  $ldaphomedir       = extlookup("ldaphomedir")

  if $ldapencrypt == 'yes' {
    $ldapuri = 'ldaps://'
  } else {
    $ldapuri = 'ldap://'
  }

  $ldap_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'  => 'Solaris5.10',
    /Solaris10_u*/ => 'Solaris5.10',
    /RedHat5.*/    => 'RedHat5.0',
    /RedHat6.*/    => 'RedHat6.0',
    /CentOS6.*/    => 'RedHat6.0',
    default        => 'UNSUPPORTED',
  }

  case $ldap_conf_ver {
    'RedHat5.0':   { include ldap::redhat50 }
    'RedHat6.0':   { include "ldap::redhat60${ldaptype}" }
    'Solaris5.10': { include ldap::solaris10 }
    'UNSUPPORTED': { fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }
}
