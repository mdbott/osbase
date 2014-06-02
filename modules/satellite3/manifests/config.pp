# == Classification: Unclassified (provisional)
#
class satellite3::config {

  include wget

  wget::get_file { "${satellite3::params::cert}":
    site   => "${satellite3::satelliteurl}/pub",
    cwd    => '/usr/share/rhn',
    user   => 'root',
    before => Exec['rhn_reg']
  }

  file { '/etc/sysconfig/rhn/rhnsd':
    ensure   => 'file',
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    seluser  => 'system_u',
    selrole  => 'object_r',
    seltype  => 'etc_t',
    selrange => 's0',
    content  => "INTERVAL=240\n",
  }

  file { '/etc/sysconfig/rhn/up2date':
    ensure   => 'file',
    owner    => 'root',
    group    => 'root',
    mode     => '0600',
    seluser  => 'system_u',
    selrole  => 'object_r',
    seltype  => 'etc_t',
    selrange => 's0',
    before   => Exec['rhn_reg']
  }
  if $satellite3::httpproxy == '' {
    exec { 'rhn_reg':
      command => "rhnreg_ks --activationkey=1-rhel${::lsbmajdistrelease}-${satellite3::environment}  --serverUrl=${satellite3::satelliteurl}/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT",
      path    => ['/usr/bin','/bin', '/usr/sbin'],
      user    => 'root',
      creates => '/etc/sysconfig/rhn/systemid',
    }
  } else {
    exec { 'rhn_reg':
      command => "rhnreg_ks --activationkey=1-rhel${::lsbmajdistrelease}-${satellite3::environment} --proxy=${satellite3::httpproxy} --serverUrl=${satellite3::satelliteurl}/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT",
      path    => ['/usr/bin','/bin', '/usr/sbin'],
      user    => 'root',
      creates => '/etc/sysconfig/rhn/systemid',
    }
  }
    


}
