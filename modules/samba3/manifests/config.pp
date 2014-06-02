# == Classification: Unclassified (provisional)
#
class samba3::config(
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
  $extra_global_options     = [],
  $shares                   = {}
) {
  
  include concat::setup
  include samba3::params
  concat { $samba3::params::configfile:
    owner       => 'root',
    group       => 'sys',
    mode        => '0644',
  }
  
  samba3::config::header { 'header':
      workgroup                => $workgroup,
      server_string            => $server_string,
      netbios_name             => $netbios_name,
      interfaces               => $interfaces,
      hosts_allow              => $hosts_allow,
      log_file                 => $log_file,
      max_log_size             => $max_log_size,
      passdb_backend           => $passdb_backend,
      domain_master            => $domain_master,
      domain_logons            => $domain_logons,
      local_master             => $local_master,
      client_signing           => $client_signing,
      client_use_spnego        => $client_use_spnego, 
      kerberos_method          => $kerberos_method,
      realm                    => $realm,
      security                 => $security,
      map_to_guest             => $map_to_guest,
      os_level                 => $os_level,
      preferred_master         => $preferred_master,
      extra_global_options     => $extra_global_options    
  }
  
  if $shares{
    create_resources(samba3::config::share,$shares)
  }


  
}