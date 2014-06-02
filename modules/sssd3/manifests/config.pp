# == Classification: Unclassified (provisional)
#
class sssd3::config {

  include concat::setup
    
  concat { '/etc/sssd/sssd.conf':
    owner       => 'root',
    mode        => '0600',
    # SSSD fails to start if file mode is anything other than 0600
  }
  
  concat::fragment{ 'sssd_conf_header':
    target  => '/etc/sssd/sssd.conf',
    content => template('sssd3/header_sssd.conf.erb'),
    order   => 10,
  }
}