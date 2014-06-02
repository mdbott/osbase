# == Classification: Unclassified (provisional)
#
class nfs::resource {
  require nfs::params

  exec { 'export shares':
    command     => $nfs::params::nfs_export_cmd,
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    refreshonly => true
  }

  include concat::setup

  concat { $nfs::params::nfs_cfg_location:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['export shares'],
  }

  concat::fragment { 'header':
    target  => $nfs::params::nfs_cfg_location,
    order   => 01,
    content => $nfs::params::nfs_cfg_header,
  }

  define share($shares, $share_access=['*'], $share_options = 'rw') {
    concat::fragment { $name:
      target  => $nfs::params::nfs_cfg_location,
      content => template("nfs/${nfs::params::nfs_cfg_template}"),
    }
  }

}
