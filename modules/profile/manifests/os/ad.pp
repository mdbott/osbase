# == Classification: Unclassified (provisional)
#
class profile::os::ad(
  $servers,
  $domain,
  $kerberosrealm,
  $username,
  $password
) {
  
  case "${::operatingsystem}${::operatingsystemrelease}" {
    'Solaris5.10' : {class {'profile::os::solaris::winbind':}}
    /Solaris10_u*/: {class {'profile::os::solaris::winbind':}}
    'Solaris5.11' : {class {'profile::os::solaris::winbind':}}
    /Solaris11_u*/: {class {'profile::os::solaris::winbind':}}
    /RedHat5\.[5-9]/: {class {'profile::os::redhat::winbind':}}
    /RedHat6.*/     : {class {'profile::os::redhat::sssdad': 
                                domain => $domain,
                                realm =>$kerberosrealm,
                                username => $username,
                                password => $password}}
    /CentOS6.*/     : {class {'profile::os::redhat::sssdad':}}
    default         : {fail("${::operatingsystem}${::operatingsystemrelease} is not supported")}
  }

}