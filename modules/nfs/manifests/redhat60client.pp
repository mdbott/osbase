# == Classification: Unclassified (provisional)
#
class nfs::redhat60client(
  $enabled = true
) {
  
  if $enabled==true {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }
  # Install the package
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
      content => template("nfs/idmapd.conf.RedHat6.0.erb"),
      require => Package['nfs'],
      notify  => Service['rpcidmapd']
    }

  # the fact we had to ensure rpcbind was running manually after nfs package
  # was installed seems like a RHEL bug. Required on 6.0 at least.
  service {'rpcbind':
    ensure     => $ensure,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nfs'],
  }

  service { 'rpcidmapd':
    ensure      => $ensure,
    enable      => $enabled,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['nfs']
  }
  service { 'nfslock':
    ensure => $ensure,
    enable => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require     => Package['nfs']
  }




}