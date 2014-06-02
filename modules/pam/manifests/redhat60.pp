# == Classification: Unclassified (provisional)
#
class pam::redhat60 ($authentication='local') {

  $sssd_supported_release = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'RedHat6.0' => true,
    'RedHat6.1' => true,
    'RedHat6.2' => true,
    'RedHat6.3' => true,
    'RedHat6.4' => true,
    'RedHat6.5' => true,
    default     => false,
  }

  case $authentication {
    'ldap': {
      if $sssd_supported_release {
        $ldaptype     = extlookup("ldaptype")
        $ldaphomedir  = extlookup("ldaphomedir")
        if $ldaphomedir == 'oddjob' {
          $target   = "ldap-${ldaptype}-oddjob"
        } else {
          $target   = "ldap-${ldaptype}"
        }
      }
      else {
        $target = "ldap-old"
      }

    }
    'winbind': {
      $target = $authentication
    }
    'vas': {
      $target = $authentication
    }
    default  : {
      $target = 'default'
    }
  }

  file {
    '/etc/pam.d/system-auth-ac':
      ensure => present,
      content => template("pam/system-auth-ac-RedHat6.0-$target.erb"),
      owner  => 'root',
      group  => 'root',
      mode   => '0644';

    '/etc/pam.d/password-auth-ac':
      ensure => present,
      content => template("pam/password-auth-ac-RedHat6.0-$target.erb"),
      owner  => 'root',
      group  => 'root',
      mode   => '0644';
  }
}
