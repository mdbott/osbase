# == Classification: Unclassified (provisional)
#
# == Class: nscd
#
# Manage the name service cache daemon on Solaris 10 & RHEL-based systems.
#
# === Parameters
#
# [*enabledcaches*]
# Required. Array. Specifices the list of caches that are enabled for 
# the nscd process
#
# [*cachedefs*]
# Optional. Array. A hash containing the cache parameters for nscd.  
# this is currently specified in params.pp
# === Examples
#
#  class { nscd: enabledcaches => [ 'passwd', 'group', 'hosts' ]}
#
# === Authors
#
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 Max Bott
#
class nscd (
  $enabledcaches,
  $cachedefs = $nscd::params::cachedefs
) inherits nscd::params {

  anchor {'nscd::start':} ->class{'nscd::package':} -> class{'nscd::config':}
    ~> class{'nscd::service':} -> anchor{'nscd::end':}


}
