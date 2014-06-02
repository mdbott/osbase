# == Classification: Unclassified (provisional)

define access::accessconfgroup (
  $ensure,
  $hosts = "ALL"
) {
  access::accessconfline { $name:
    ensure   => $ensure,
    group    => true,
    hosts    => $hosts,
  }
}
