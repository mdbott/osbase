# == Classification: Unclassified (provisional)
#
# == Class: satellite3
#
# Ensures that a host is registered to the Satellite Server and configured into the appropriate Satellite Environment.
#
# === Hiera Parameters
#
#
# [*satelliteurl*]
# The URL of the Appropriate Satellite Server. This should reflect on which network the client
# is located on.
#
# [*environment*]
# Reflects the client systems organisational status, i.e dev,quality or prod
#
# [*httpproxy*]
# hostname and port in the form hostname:port of http proxy
#
#
# === Examples
#
#  class { satellite3:
#    satelliteurl => 'http://cupid.itsupt.defence.ic.gov.au',
#    environment => 'quality',
#    httpproxy => 'someproxy.dsd:3128'
#  }
#
# === Authors
#
# Author Name Mick Wahren & Tom Baguley <mkwahre@dsd, tcbagul@dsd>
#
# === Copyright
#
#
# Subscribes systems to the Red Hat Network Satellite Server
#
#
class satellite3(
  $satelliteurl,
  $environment,
  $httpproxy=""
) inherits satellite3::params {
  anchor {'satellite3::start':} ->class{'satellite3::package':} -> class{'satellite3::config':}
    ~> class{'satellite3::service':} -> anchor{'satellite3::end':}
}
