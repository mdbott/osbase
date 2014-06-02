# == Classification: Unclassified (provisional)
class autofs::solaris10 ($automounts) {

  package { 'autofs':
    ensure => installed,
    name   => $autofs::params::autofs_package,
  }

  service { 'autofs':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Service['nfs'],
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
}
