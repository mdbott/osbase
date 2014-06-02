# == Classification: Unclassified (provisional)
#
class pam::redhat50 ($authentication='local') {

  $sssd_supported_release = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'RedHat5.8' => true,
    'RedHat5.9' => true,
    'RedHat5.10' => true,
    default     => false,
  }

  case $authentication {
    'ldap': {
      if $::sssd_supported_release {
        $ldaptype      = extlookup("ldaptype")
        $target = "${::authentication}-${::ldaptype}"
      }
      else {
        $target = "${::authentication}-old"
      }

    }
    'winbind': {
      $target = $authentication
    }
    'vas': {
      fail('pam module does not support vas for RHEL5')
    }
    default  : {
      $target = 'default'
    }
  }

  file { '/etc/pam.d/system-auth-ac':
    ensure => present,
    source => "puppet:///modules/pam/system-auth-ac-RedHat5.0-$target",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
