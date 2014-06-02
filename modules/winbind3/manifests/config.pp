# == Classification: Unclassified (provisional)
#
class winbind3::config(
  $addomain,
  $kerberosrealm
) {
  class{'samba3::config':
      workgroup                => $addomain,
      server_string            => $fqdn,
      client_signing           => 'yes',
      client_use_spnego        => 'yes',
      kerberos_method          => 'secrets and keytab',
      security                 => 'ads',
      realm                    => $kerberosrealm,
      log_file                 => '/var/log/samba/log.%m',
      max_log_size             => '50',

  }

}