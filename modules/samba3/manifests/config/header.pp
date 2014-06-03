# == Classification: Unclassified (provisional)
#
define samba3::config::header (
  # Main smb.conf options
  $workgroup                = 'MYGROUP',
  $server_string            = 'Samba Server Version %v',
  $netbios_name             = '',
  $interfaces               = [],
  $hosts_allow              = [],
  $log_file                 = '/var/log/samba/log.%m',
  $max_log_size             = '10000',
  $passdb_backend           = undef,
  $domain_master            = false,
  $domain_logons            = false,
  $local_master             = undef,
  $client_signing           = undef,
  $client_use_spnego        = undef,
  $kerberos_method          = undef,
  $realm                    = undef,
  $security                 = undef,
  $map_to_guest             = undef,
  $os_level                 = undef,
  $preferred_master         = undef,
  $extra_global_options     = []
) {

  include samba3::params

  concat::fragment { "smb.conf_header":
    target  => $samba3::params::configfile,
    content => template('samba3/smb.conf.header.erb'),
    order   => 10,
  }
}