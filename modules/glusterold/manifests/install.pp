# == Classification: Unclassified (provisional)
#
class glusterold::install {
  package { $glusterold::params::gluster_pkg:
    ensure => present,
  }

  package { $glusterold::params::gluster_fuse_pkg:
    ensure => present,
  }
  
  file { '/etc/sysconfig/glusterfsd':
    ensure  => file,
    source  => 'puppet:///modules/glusterold/glusterfsd',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    require => Package[$glusterold::params::gluster_pkg]
  }

}
