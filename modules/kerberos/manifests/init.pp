# == Classification: Unclassified (provisional)
#
# == Class: kerberos
#
# Manages the kerberos authenication system on on Solaris 10 & RHEL-based systems.
#
# === Parameters
#
# [*libdefaults*]
# Required. Hash. Contains various default values used by the Kerberos V5 library. This 
# would usually be specified via hiera
#
# [*appdefaults*]
# Required. Hash. Contains default values that can be used by Kerberos V5 applications. This 
# would usually be specified via hiera
#
# [*defaultkerberosrealm*]
# Required. Hash. This relation identifies the default realm to be used in a client
# host's Kerberos activity. This would usually be specified via hiera
#
# [*kerberosrealms*]
# Required. Hash. Contains subsections keyed by Kerberos realm names which describe 
# where to find the Kerberos servers for a particular realm, and other realm-specific
# information.. This would usually be specified via hiera
#
# [*kerberosdomains*]
# Required. Hash. Contains relations which map subdomains and domain names to 
# Kerberos realm names.  This is used by programs to determine what realm a host 
# should be in, given its fully qualified domain name. This would usually be specified 
# via hiera
#
# === Examples
#
#  class { kerberos: }
#
# === Authors
#
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 Max Bott
#
class kerberos(
  $libdefaults,
  $appdefaults=undef,
  $defaultkerberosrealm,
  $kerberosrealms,
  $kerberosdomains,
  $krbuser = '',
  $krbpassword = ''
) inherits kerberos::params {

  anchor {'kerberos::start':} ->class{'kerberos::package':} -> class{'kerberos::config':}
    ~> class{'kerberos::service': krbuser =>$krbuser, krbpassword => $krbpassword} -> 
    anchor{'kerberos::end':}
}
