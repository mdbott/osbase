# == Classification: Unclassified (provisional)
#
# == Class: winbind
#
# Enables winbind authentication. As the AD servers are specified by name not ip this module has an
# explicit dependency on the dns module which should be executed prior to winbind
#
# Requires dns class for /etc/nsswitch.conf
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
#   [*adservers*]
#     TODO
#   [*addomain*]
#     TODO
#   [*kerberosrealm*]
#     TODO
#   [*kerberosdomains*]
#     TODO
#   [*defaultkerberosdomain*]
#     TODO
#   [*adusername*]
#     TODO
#   [*adpassword*]
#     TODO
#
# == Examples
#
#   include stages
#   class {'dns':         stage => pre4 }
#   class {'winbind':    stage => pre5 }
#
# == Maintainers
#
# SSU
#

class winbind(
  $adservers,
  $addomain,
  $kerberosrealm,
  $kerberosdomains,
  $defaultkerberosdomain,
  $adusername,
  $adpassword,
  $hostsallow) {

  Class['dns'] -> Class['winbind']

  $winbind_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10' => 'Solaris5.10',
    'RedHat5.9'   => 'RedHat5.0',
    'RedHat5.10'  => 'RedHat5.0',
    'RedHat6.0'   => 'RedHat6.0',
    'RedHat6.1'   => 'RedHat6.0',
    'RedHat6.2'   => 'RedHat6.0',
    'RedHat6.3'   => 'RedHat6.0',
    'RedHat6.4'   => 'RedHat6.0',
    default       => 'UNSUPPORTED',
  }

  case $winbind_conf_ver {
    'RedHat5.0':   { include winbind::redhat50 }
    'RedHat6.0':   { include winbind::redhat60 }
    'Solaris5.10': { include winbind::solaris10 }
    'UNSUPPORTED': { fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
  }

}
