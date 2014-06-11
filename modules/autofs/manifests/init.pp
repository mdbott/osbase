# == Classification: Unclassified (provisional)
# == Class: autofs
#
# Enables autofs mounting of users $HOME directories. As this queries the LDAP
# servers for the automounter maps this has an implicit dependency on the ldap
# module
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
# [*base_dn*]
#   Base DN for LDAP auto_home lookups
# [*automastersource*]
#   Set to 'ldap' to enable getting auto_master from LDAP, Solaris only
# [*directmount*]
#   Set to 'none' if unused, otherwise name of direct map file
#
# == Examples
#
#   include stages
#   class {'dns'    : stage => pre4 }
#   class {'nfs::client':      stage => pre4}
#   class {'pam':      stage => pre5, authentication => 'ldap' }
#   class {'ldap': stage => pre5}
#   class {'autofs':   stage => pre5}
#
# == Maintainers
#
# SSU
#
class autofs (
  $automounts = {},
  $basedn=undef,
  $automastersource=undef,
  $directmount=undef 
    ) {
  require autofs::params

  Class['nfs::client'] -> Class['autofs']

  if $automounts == {} {
    case $autofs::params::autofs_conf_ver {
      'RedHat5.0': {
        $platform_automounts = {
          'home' => { 'autofs_file' => "ldap:automountMapName=auto_home,${base_dn}",
                      'options'     => '' }
        }
      }
      'RedHat6.0': {
        $platform_automounts = {
          'home' => { 'autofs_file' => "ldap:automountMapName=auto_home,${base_dn}",
                      'options'     => '' }
        }
      }
      'Solaris5.10': {
        $platform_automounts = {
          'net'  => { 'autofs_file' => '-hosts',
                      'options'     => '-nosuid,nobrowse' },
          'home' => { 'autofs_file' => 'auto_home',
                      'options'     => '-nobrowse' }
        }
      }
      'UNSUPPORTED': {
        fail("${::operatingsystem}${::operatingsystemrelease} not supported")
      }
    }
  } else {
    $platform_automounts = $automounts
  }

  case $autofs::params::autofs_conf_ver {
    'RedHat5.0':   { class {'autofs::redhat50':  automounts => $platform_automounts} }
    'RedHat6.0':   { class {'autofs::redhat60':  automounts => $platform_automounts} }
    'Solaris5.10': { class {'autofs::solaris10': automounts => $platform_automounts} }
    'UNSUPPORTED': {
      fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }
}
