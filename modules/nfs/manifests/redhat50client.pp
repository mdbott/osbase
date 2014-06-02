# == Classification: Unclassified (provisional)
#
class nfs::redhat50client {
  package { 'nfs':
    ensure => installed,
    name => $nfs::params::nfs_package,
  }

  $nfs4domain = $nfs::params::nfs4domain
  file { '/etc/idmapd.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      content => template("nfs/idmapd.conf.RedHat5.0.erb"),
      require => Package['nfs'],
      notify  => Service['rpcidmapd']
    }
  service { 'portmap':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nfs'],
  }

  service { 'rpcidmapd':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['nfs']
  }

  service { 'nfs':
    ensure     => running,
    name       => $nfs::params::nfs_service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [Service['portmap'],File['/etc/idmapd.conf']],
  }
  service { 'nfslock':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [Service['portmap'],File['/etc/idmapd.conf']],
  }

}