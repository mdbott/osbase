# == Classification: Unclassified (provisional)
#
# == Class: buildslave
#
# Configure host as slave to buildbot
#
# This module doesn't work, it is a definite WIP
#
# == Future Directions
#
#
# == Parameters
#
# [*var1*]
#   TODO parameters the class takes
#
# == Variables
#
# [*common*::*data*::*stuff*]
#   TODO External variables this class uses
#
# == Extlookup
#
# [*extvar1*]
#   TODO Variables this class resolves via extlookup()
#
# == Examples
#
#   include TODO
#   class { 'module_template': var1 => "foo", }
#
# == Maintainers
#
# SSU
#
class buildslave ($buildmaster = 'study.itsupt.dsd', $buildmasterport = '9989') {
  require buildslave::params

  #Class['nfs::client'] -> Class['buildslave']

  if "${::operatingsystem}${::lsbmajdistrelease}" != 'RedHat6' {
    fail("${::operatingsystem}${::lsbmajdistrelease} not supported")
  }

  $build_bot_dir = $buildslave::params::build_bot_dir
  $instance_name = $buildmaster


  package { 'buildbot-slave':
    ensure => installed,
  }

  package { 'puppetvm':
    ensure => installed,
  }

  package { 'mercurial':
    ensure => installed,
  }

  package { ['qemu-kvm', 'libvirt-client']:
    ensure => installed,
  }

  file { '/opt': # TODO FIX
    ensure => directory,
    mode   => '0755',
  }


  file { "${build_bot_dir}/":
    ensure => directory,
    mode   => '0755',
  }

  file { '/root/puppetvm':
# TODO FIX
    ensure => symlink,
    target => '/puppetvm/'
  }

  file { '/opt/buildbot/study-slave/':
# TODO FIX
    ensure => symlink,
    target => "${build_bot_dir}/${instance_name}",
  }

  file { '/puppetvm/images/':
# TODO FIX
    ensure => directory,
    mode   => '0755',
    require => Package['puppetvm'],
  }


  mount { '/puppetvm/images':
# TODO FIX
    device => 'study.itsupt.dsd:/export/repositories/puppetvm/images',
    fstype   => 'nfs',
    ensure => 'mounted',
    options => 'defaults',
    atboot => 'true',
    require => File['/puppetvm/images'],
  }

  file { '/etc/init.d/buildbot-slave':
    ensure  => present,
    content => template('buildslave/etc-init.d-buildbot--slave.erb'),
    mode    => '0755',
    require => Package['buildbot-slave'],
  }

  service { 'buildbot-slave':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [ File['/etc/init.d/buildbot-slave'], Exec['setup_slave'] ],
  }

  file {'/usr/local/sbin/buildbotsetupstudyslave':
    ensure  => present,
    content => template('buildslave/usr-local-sbin-buildbotsetupstudyslave.erb'),
    mode    => '0755',
  }

  exec { 'setup_slave':
    command => '/usr/local/sbin/buildbotsetupstudyslave',
    #command => "cd ${build_bot_dir} && /usr/bin/buildslave ${instance_name} ${buildmaster}:${buildmasterport} $(hostname -s)",
    unless  => "/bin/ls ${build_bot_dir}/${instance_name}/",
# TODO FIX
    require => [ Package['buildbot-slave'], File['/usr/local/sbin/buildbotsetupstudyslave'], File['/root/puppetvm'], Mount['/puppetvm/images'], File['/opt/buildbot/study-slave/'] ],
  }


}
