# == Classification: Unclassified (provisional)
#
class pam::solaris11 ($authentication='local') {

  $access_control = extlookup('accesscontrol')
  if $authentication == 'ldap' {

    # Unfortunately pamlist isn't in older versions of Solaris 10, so we have to
    # account for that in terms of puppet:///modules/pam/etc/pam.conf.old
    # /usr/lib/security/pam_netgroup.so.1 and /usr/lib/security/pam_netgroup.so
    if $::pamlist == 'false' {
      $reposerver = extlookup("reposerver")
      file { '/var/sadm/install/admin/auto':
        content => template("pam/auto.erb"),
        owner     => 'root',
        group     => 'sys',
        mode      => '0444',
      }
      package { 'DSDpamnetgroup':
        ensure   => present,
        name     => 'DSDpamnetgroup',
        provider => sun,
        adminfile => 'auto',
        source  => "http://${reposerver}/corporate/solaris/${::hardwareisa}/5.10/DSDpamnetgroup-1.0-Oracle10-${::hardwareisa}.pkg",
        require   => File['/var/sadm/install/admin/auto'],
      }
      $target = 'ldap-old'

    } elsif $access_control == 'false' {
      $target = 'ldap-nocontrol'

    } else {
      $target = 'ldap'
    }

  } elsif $authentication == 'winbind' {
    $target = 'winbind'

  } else {
    $target = 'default'
  }


  file { '/etc/pam.d/login':
    ensure => present,
    content => template("pam/login-Solaris5.11-$target.erb"),
    owner  => 'root',
    group  => 'sys',
    mode   => '0644',
  }
  file { '/etc/pam.d/other':
    ensure => present,
    content => template("pam/other-Solaris5.11-$target.erb"),
    owner  => 'root',
    group  => 'sys',
    mode   => '0644',
  }
}
