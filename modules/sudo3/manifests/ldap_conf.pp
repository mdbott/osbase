# == Classification: Unclassified (provisional)
#
# == Class: sudo3::ldap_conf
#
# Allows custom sudo ldap configuration entries via sudo3::ldap_conf
#
# === Parameters
#
# [*ldapuri*]
# Specifies an array of one or more URIs describing the LDAP server(s) to connect to. Default is 'undef'.
#
# [*sudoers_base*]
# Specifies an array of one or more base DN to use when performing sudo LDAP queries. Default is 'undef'.
#
# [*bind_timelimit*]
# Specifies in a string the BIND_TIMELIMIT parameter, the amount of time to wait while trying to connect to an LDAP server. Default is 'undef'.
#
# [*timelimit*]
# Specifies in a string the TIMELIMIT parameter, the amount of time to wait for a response to an LDAP query. Default is 'undef'.
#
# [*tls_cacertdir*]
# Specifies in a string the TLS_CACERT parameter, the path to the TLS CA certificate directory. Default is 'undef'.
#
# [*sudoers_debug*]
# This sets the debug level for sudo LDAP queries. Debugging information is printeed to the standard error. Default is 'undef'.
#
#
# === Examples
#
# = Node definitions
# include sudo3
# include sudo3::ldap_conf
#
# = Hiera definitions
# nsswitch3::sudoers: 
#   - ldap
# sudo3::ldap_conf::ldapuri:
#   - ldaps://aqamgv002.qa.aicnet.ic.gov.au:1636
# sudo3::ldap_conf::sudoers_base:
#   - ou=SUDOERS,ou=Authorisation,o=IC,c=au
# sudo3::ldap_conf::timelimit: 30
# sudo3::ldap_conf::tls_cacertdir: /etc/openldap/cacerts
#
#
# === Hiera
#
# [*ldapuri*]
# Specifies an array of one or more URIs describing the LDAP server(s) to connect to. Default is 'undef'.
#
# [*sudoers_base*]
# Specifies an array of one or more base DN to use when performing sudo LDAP queries. Default is 'undef'.
#
# [*bind_timelimit*]
# Specifies in a string the BIND_TIMELIMIT parameter, the amount of time to wait while trying to connect to an LDAP server. Default is 'undef'.
#
# [*timelimit*]
# Specifies in a string the TIMELIMIT parameter, the amount of time to wait for a response to an LDAP query. Default is 'undef'.
#
# [*tls_cacertdir*]
# Specifies in a string the TLS_CACERT parameter, the path to the TLS CA certificate directory. Default is 'undef'.
#
# [*sudoers_debug*]
# This sets the debug level for sudo LDAP queries. Debugging information is printeed to the standard error. Default is 'undef'.
#
#
# === Variables
#
# Not applicable
#
# === Templates
#
# sudo-ladap.conf.erb
# Defines the sudo-ldap.conf file
#
# === Maintainers
#
# UPS
#
class sudo3::ldap_conf ( 
  $ldapuri = undef,
  $sudoers_base = undef,
  $bind_timelimit = undef,
  $timelimit = undef,
  $tls_cacertdir = undef,
  $sudoers_debug = undef
) {
  file { 'sudo-ldap-conf':
    ensure  => present,
    path    => '/etc/sudo-ldap.conf',
    content => template("sudo3/sudo-ldap.conf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    require => Class['sudo3'],
  }
}
