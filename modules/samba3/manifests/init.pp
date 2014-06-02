# == Classification: Unclassified (provisional)
#
# == Class: samba3
#
# Sets up SSH servers in /etc/ssh/sshd.conf depending on environment
#
# === Parameters
#
# === Hiera
#
#
# === Examples
#
#  Invoking in a single class definition
#  class{'samba3': shares => {
#                      'homes'     =>    {options => [ 'comment = Home Directories',
#                                                      'browsable = no',
#                                                      'writeable = yes']},
#                      'pictures'  =>    {options => [ 'comment = Pictures',
#                                                      'path = /opt/pictures',
#                                                      'browsable = yes',
#                                                      'writeable = no']}      }
#    
#  }
#
# or as seperate share definitions
#  include samba3
#  samba3::config::share{'homes': options => ['comment = Home Directories',
#                                             'browsable = no',
#                                             'writeable = yes']}
#
# === Maintainers
#
# UPS
#
class samba3(
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
  $extra_global_options     = [],
  $shares                   = {}
) inherits samba3::params {

  anchor {'samba3::start':} ->class{'samba3::package':} -> 
  class{'samba3::config':
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
    extra_global_options     => $extra_global_options,
    shares => $shares
  }
  ~> class{'samba3::service':} -> anchor{'samba3::end':}
}
