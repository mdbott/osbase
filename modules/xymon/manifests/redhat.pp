# == Classification: Unclassified (provisional)
#
class xymon::redhat inherits xymon::params {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    require => Package['xymon'],
  }

  $raidtype = extlookup("raidtype")
  $hobbitserver = extlookup("hobbitserver")
  $puppetmonitor = extlookup("puppetmonitor","false")

  # Install the package
  package { 'xymon':
    ensure   => "${xymon::params::xymon_ensure}",
    name     => "${xymon::params::xymon_pkg}",
    provider => "${xymon::params::pkg_provider}",
  }

   # Ensure the xymon service is running
  service { 'xymon':
    ensure     => running,
    name       => "${xymon::params::xymon_service}",
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require => Package['xymon'],
  }


  # Configure xymon for the site
  file { 'xymonclient.cfg':
    content => template('xymon/xymonclient.erb'),
    path    => "${xymon::params::xymon_cfg_location}",
    notify  => Service['xymon'],
  }

  # clientlaunch.d dir
  file { "${xymon::params::xymon_clientlaunchd_location}":
    ensure  => directory,
    recurse => true,
    alias   => 'xymon_launchd',
  }

  # Clientlaunch config
  file { "${xymon::params::xymon_clientlaunch_location}":
    content => template('xymon/clientlaunch.cfg.erb'),
    notify  => Service['xymon'],
    require => File['xymon_launchd'],
  }

  case $raidtype {
#    hphwraid: {
#       include hputils::packages
#       xymon::client_module { 'raid' :
#        cmd => 'hphwraid.sh',
#        cmd_base => "${xymon::params::xymon_home}/ext",
#        source   => "puppet:///modules/xymon/hphwraid.sh",
#        log_file => 'raidCtlr.log',
#      }
#    }
    swraid: {
      xymon::client_module{ 'raid':
        cmd      => 'raid.pl',
        cmd_base => "${xymon::params::xymon_home}/ext",
        source  => "puppet:///modules/xymon/raid.pl",
        log_file => 'raidCtlr.log',
      }
    }
  }

 package { 'perl-XML-Parser':
    ensure   => present,
 }

  file { "${xymon::params::xymon_home}/ext/treecheck-defines.pl":
    ensure  => present,
    alias   => 'treecheck-defines.pl',
    owner   => "${xymon::params::xymon_owner}",
    group   => "${xymon::params::xymon_group}",
    mode    => 755,
    source  => "puppet:///modules/xymon/treecheck-defines.pl",
  }

  file { "${xymon::params::xymon_home}/ext/treecheck-include.pl":
    ensure  => present,
    alias   => 'treecheck-include.pl',
    owner   => "${xymon::params::xymon_owner}",
    group   => "${xymon::params::xymon_group}",
    mode    => 755,
    source  => "puppet:///modules/xymon/treecheck-include.pl",
  }

  xymon::client_module{ 'scanner':
    cmd       => 'scanner.pl',
    cmd_base  => "${xymon::params::xymon_home}/ext",
    content   => template('xymon/scanner.pl.erb'),
    log_file  => 'scanner.log',
    require   => [File['treecheck-defines.pl'], File['treecheck-include.pl'], Package['perl-XML-Parser']],
  }

  if $puppetmonitor == "true" {
    $puppet_summary_location = "${xymon::params::puppet_summary_location}"
    xymon::client_module{ 'puppet':
      cmd       => 'puppet_check.rb',
      cmd_base  => "${xymon::params::xymon_home}/ext",
      content   => template('xymon/puppet_check.rb.erb'),
      log_file  => 'puppet_check.log',
    }
  } else {
     file { "${xymon::params::xymon_home}/ext/puppet_check.rb" : ensure => absent }
     file { "${xymon::params::xymon_home}/logs/puppet_check.log" : ensure => absent }
     file { "${xymon::params::xymon_clientlaunchd_location}/xymon_client_module_puppet.cfg" : ensure => absent }
  }

  # Temp work around the fact that scanner writes to CWD and not BBTMP
  file { '/opt/xymon' :
    ensure => directory,
    owner  => 'xymon',
    group  => 'daemon',
    mode   => 700,
  }

  # Ensure the permissions on the messages are set correctly...
  file { '/var/log/messages':
    ensure => 'present',
    group  => 'daemon',
    mode   => '640',
    before => Service['xymon'],
  }

  # ...and configure logrotate to leave it at the correct permissions
  file { '/etc/logrotate.d/syslog':
    ensure => 'present',
    source => "puppet:///modules/xymon/syslog-logrotate.d",
    before => Service['xymon'],
  }

  # ...but since syslog now manages then secure logs we need to remove the explicit one
  file { '/etc/logrotate.d/secure':
    ensure => 'absent',
    before => Service['xymon'],
  }

  file { '/etc/logrotate.d/messages':
    ensure => 'present',
    source => "puppet:///modules/xymon/messages-logrotate.d",
    before => Service['xymon'],
  }
  
  # Remove any pre-existing legacy startup scripts
#  file { '/etc/rc3.d/S80hobbit-client':
#    ensure => 'absent',
#    require=> Package['xymon']
#  }


}
