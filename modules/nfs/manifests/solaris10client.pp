# == Classification: Unclassified (provisional)
#
class nfs::solaris10client(
  $enabled = true
) {
  
  
  if $enabled==true {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }
    package { 'nfs':
      ensure => installed,
      name => $nfs::params::nfs_package,
    }

    $nfs4domain = $nfs::params::domain

    file { '/etc/default/nfs':
      ensure  => 'file',
      owner   => 'root',
      group   => 'sys',
      mode    => '644',
      content => template("nfs/nfs.erb"),
      notify  => Service['mapid']
    }

    service { 'mapid':
      ensure      => $ensure,
      enable      => $enabled,
      hasstatus   => true,
      hasrestart  => true,
      require     => Package['nfs']
    }


    service { 'nfs':
      ensure     => $ensure,
      name       => $nfs::params::nfs_service,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['nfs'],
    }

}
