# == Classification: Unclassified (provisional)
#
# == Class: pam
#
# Manages PAM configuration
#
# == Future Directions
#
#
# == Parameters
#
# [*ldap*]
#   'enabled' to enable LDAP authentication through PAM
#   'disabled' is the default
#
# [*winbind*]
#   'enabled' to enable winbind authentication through PAM
#   'disabled' is the default
#
# == Variables
#
#
# == Extlookup
#
# [*reposerver*]
#   Under Solaris server used for repo to fetch DSDpamnetgroup from
#
# == Examples
#
#   include stages
#   class {'nsswitch': stage => pre4, type => 'local'}
#   include pam # defaults to LDAP & winbind disabled (local auth)
#
# == Maintainers
#
# SSU
#
class pam ($authentication='local', $do_nothing=false) {

  case $authentication {
    'ldap'    : { Class['pam'] -> Class['ldap']}
    'winbind' : { Class['pam'] -> Class['winbind'] }
    'local'   : {}
    'vas'     : {}
    default   : {fail('unrecognised authentication option')}
  }

  $pam_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'  => 'Solaris5.10',
    /Solaris10_u*/ => 'Solaris5.10',
    'Solaris5.11 ' => 'Solaris5.11',
    /RedHat5.*/    => 'RedHat5.0',
    /RedHat6.*/    => 'RedHat6.0',
    /CentOS6.*/    => 'RedHat6.0',
    default        => 'UNSUPPORTED',
  }

  if !($do_nothing) {
    case $pam_conf_ver {
      'RedHat5.0':   { class {'pam::redhat50':  authentication => $authentication } }
      'RedHat6.0':   { class {'pam::redhat60':  authentication => $authentication } }
      'Solaris5.10': { class {'pam::solaris10': authentication => $authentication } }
      'Solaris5.11': { class {'pam::solaris11': authentication => $authentication } }
      'UNSUPPORTED': {
        fail("${::operatingsystem}${::operatingsystemrelease} not supported") }
    }
  }

}
