# == Classification: Unclassified (provisional)
define sudo::netgroup (
  $ensure,
  $password = true,
  $commands = 'ALL',
  $groups   = 'ALL',
  $hosts    = 'ALL'
) {
  sudo::line { $name:
    ensure   => $ensure,
    password => $password,
    commands => $commands,
    groups   => $groups,
    hosts    => $hosts,
    linetype     => "netgroup",
  }
}
