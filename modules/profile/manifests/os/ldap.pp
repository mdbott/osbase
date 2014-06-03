# == Classification: UNCLASSIFIED
#
class profile::os::ldap (
  $servers,
  $basedn,
  $bindpassword,
  $encrypted,
  $certname,
  $servertype
) {

  case $servertype {
    'Solaris': {
       $group_container    = 'group'
       $netgroup_container = 'netgroup'
    }
    'Redhat': {
      $group_container    = 'groups'
      $netgroup_container = 'netgroups'
    }
  }

  $user_container = 'People'

  case "${encrypted}${::osfamily}" {
    'trueRedHat'  : { class { 'profile::os::redhat::ldaps': servers => $servers, basedn => $basedn } }
    'falseRedHat' : { class { 'profile::os::redhat::ldap': } }
    'trueSolaris' : { class { 'profile::os::solaris::ldaps': } }
    'falseSolaris': { class { 'profile::os::solaris::ldaps': } }
    default       : { fail("${::osfamily} is unsupported") }
  }

}
