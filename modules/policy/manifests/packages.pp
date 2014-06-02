# == Classification: Unclassified (provisional)

class policy::packages {

  # Configure solaris systems to ensure that listed packages are removed
  if $::operatingsystem == 'Solaris' {
    file { '/var/sadm/install/admin/puppet':
        source    => "puppet:///modules/policy/puppet",
        owner     => 'root',
        group     => 'sys',
        mode      => '0444',
      }
  # TODO: Reconfigure this file resource as a virtual resource (probably in
  # the common::data class) so that is is realised as required for any unattended
  # solaris package installations

    package { 'SUNWfirefox':
      ensure    => 'absent',
      adminfile => 'puppet',
      require   => File['/var/sadm/install/admin/puppet'],
    }
    
    package { 'SUNWcsu':
      ensure => installed,
    }
    
    # Disables core file generation on Solaris via the coreadm(1M) command.
    
    exec { 'coreadm':
      onlyif  => '/usr/bin/coreadm | /usr/bin/grep enabled',
      command => '/usr/bin/coreadm -d global -d global-setid -d log -d process -d proc-setid',
      require => Package['SUNWcsu'],
    }
  }

  # TODO: Extend this class to cover Redhat linux
  if $::operatingsystem == 'RedHat' or $::operatingsystem == 'CentOS' {
    # we need this package for facter lsb* facts to work
    package { 'redhat-lsb':
      ensure => installed,
    }
  }
  
  file { '/usr/bin/puppet-ls':
    ensure  => 'file',
    source  => "puppet:///modules/policy/puppet-ls",
    owner   => 'root',
    group   => 'sys',
    mode    => '755',
  }
  

}
