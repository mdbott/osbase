class xymon::solaris10 {

  package { 'DSDhobbit-tree':
    ensure => present,
    provider => $xymon::params::pkg_provider,
    before   => Service['xymon'],
  }
  $hobbitserver = extlookup("hobbitserver")
  $xymon_clientlaunchd_location = $xymon::params::xymon_clientlaunchd_location

  # Install the package
  package { 'xymon':
    ensure   => present,
    name     => $xymon::params::xymon_pkg,
    provider => $xymon::params::pkg_provider,
  }

   # Ensure the xymon service is running
  service { 'xymon':
    ensure     => running,
    name       => $xymon::params::xymon_service,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    require => Package['xymon'],
  }

  File {
    owner   => 'root',
    group   => 'root',
  }

  # Configure xymon for the site
  file { 'hobbit':
    content => template('xymon/hobbit.erb'),
    path    => "${xymon::params::xymon_cfg_location}",
    mode    => 644,
    notify  => Service['xymon'],
    require => Package['xymon'],
  }

  # clientlaunch.d dir
  file { $xymon::params::xymon_clientlaunchd_location:
    ensure => directory,
    mode   => 755,
    require => Package['xymon'],
    alias   => 'xymon_launchd',
  }

  # Clientlaunch config
  file { $xymon::params::xymon_clientlaunch_location:
    content => template('xymon/clientlaunch.cfg-Solaris10.erb'),
    mode    => 644,
    notify  => Service['xymon'],
    require => [Package['xymon'], File[$xymon::params::xymon_clientlaunchd_location]],
  }

  xymon::client_module{ 'vxvm':
    cmd      => 'vxvm.pl',
    cmd_base => "${xymon::params::xymon_home}/ext",
    source  => "puppet:///modules/xymon/vxvm.pl",
    log_file => 'vxvm.log',
  }

  # Create the manifest for the xymon client
  file {'/var/svc/manifest/application/monitoring':
      ensure => 'directory',
      owner  => root,
      group  => root,
      mode   => '755',
  }
  file {'/var/svc/manifest/application/monitoring/xymon.xml':
      ensure => 'directory',
      owner  => root,
      group  => root,
      mode   => '755',
      source => "puppet:///modules/xymon/xymon.xml",
      require=> File['/var/svc/manifest/application/monitoring'],
  }

  # Remove any pre-existing legacy startup scripts
  file { '/etc/rc3.d/S99hobbit-client':
    ensure => 'absent',
    require=> Package['xymon']
  }
  file { '/etc/rc3.d/S99hobbit':
    ensure => 'absent',
  }

  # Import the xymon manifest into the svc database
  exec {'install xymon.xml manifest':
    path => "/usr/sbin:/usr/bin:/sbin:/bin",
    user => root,
    command => "/usr/sbin/svccfg import /var/svc/manifest/application/monitoring/xymon.xml",
    unless => "/usr/sbin/svccfg list application/monitoring/xymon|grep xymon",
    require => File['/var/svc/manifest/application/monitoring/xymon.xml','/etc/rc3.d/S99hobbit-client','/etc/rc3.d/S99hobbit'],
  	before => Service['xymon'],
  }
}
