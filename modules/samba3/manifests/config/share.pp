# == Classification: Unclassified (provisional)
#
define samba3::config::share (
  $options                   = []
) {
  include samba3::params
  concat::fragment { $name:
    target  => $samba3::params::configfile,
    content => template('samba3/smb.conf.share.erb'),
    order   => 20,
  }
}