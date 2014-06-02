# == Classification: Unclassified (provisional)
#
# == Class: sudo3
#
# Installs the sudo package based on OS release.
# Installs a default sudoers configuration file and a custom sudoers directory.
# Allows custom user entries via sudo3::user
# Allows custom group entries via sudo3::group
# Allows custom netgroup entries via sudo3::netgroup
# Allows custom sudo ldap configuration entries via sudo3::ldap_conf
#
# === Parameters
#
# for resources sudo3::users, sudo3::group, sudo3::netgroup
#
# [*ensure*]
#  File attribute to specify if the custom entry should be 'absent' or 'present'. No default
#
# [*password*]
#  Boolean value 'true' or 'false' to specify if the NOPASSWD tag is not set. Default is 'true' - the tag is not set and authentication is required.
#
# [*commands*]
#  Specify ALL or one or more commands that can be run in an array. Default is ['ALL'].
#
# [*groups*]
#  Specify the groups (user) the command can be run as in comma delimited string. Default is 'ALL'
#
# [*hosts*]
#  Specify the hosts the command can be run on in comma delimited string. Default is 'ALL'
#
#
# === Hiera
#
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
# == Set up sudo to use local custom entries.
# = Node definitions
# include sudo3
# sudo3::user { 'bobsmith':  ensure   => present, password => true, commands => ['/usr/sbin/pwck, /usr/sbin/grpck'],}
# sudo3::group { 'sysadm': ensure   => present, commands => ['/usr/sbin/pwck'],}
# sudo3::netgroup { 'role-web-support': ensure   => present, groups => 'webadm', commands => ['ALL'],}
#
#
# == Set up sudo to use ldap
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
# === Variables
#
# [*packagename*]
# Defines OS specific package name
#
# [*package_provider*]
# Defines OS specific package provider
#
# [*configfile*]
# Defines the path of sudoers file
#
# [*configtemplate*]
# Specifies the template to use for the sudoers file
#
# [*sudo_conf_version*]
# Specifes the OS release
#
# [*fragment_dir*]
# Specifies the location/path for the diectory holding the custom user/group/netgroup entires
#
# === Templates
#
# sudoers.erb
# Defines the sudoers file
#
# line.erb
# Defines custom user/group/netgroup entires
#
# sudo-ladap.conf.erb
# Defines the sudo-ldap.conf file
#
# === Maintainers
#
# UPS
#
class sudo3 inherits sudo3::params {

  anchor {'sudo3::start':} -> class{'sudo3::package':} -> class{'sudo3::config':} -> anchor{'sudo3::end':}
  
}
