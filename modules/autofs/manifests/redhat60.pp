#0 == Classification: Unclassified (provisional)
class autofs::redhat60 (
  $automounts,
  $autofs_protocol="3"         
) {

  package { 'autofs':
    ensure => installed,
    name   => $autofs::params::autofs_package,
  }

  file { "/etc/sysconfig/autofs":
    backup => true,
    owner  => "root",
    group  => "root",
    mode   => 644,
    content => template("autofs/autofs.erb"),
    notify => Service["autofs"]
  }

  file { 'automaster':
    path    => "/etc/$autofs::params::automaster_file",
    content => template("autofs/$autofs::params::automaster_file.erb"),
    owner   => 'root',
    group   => $autofs::params::automaster_file_grp,
    mode    => '0644',
    notify  => Service['autofs'],
    require => Package['autofs'],
  }

  service { 'autofs':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    #subscribe => File['/etc/openldap/ldap.conf']
  }
}
