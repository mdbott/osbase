# == Classification: Unclassified (provisional)
define sudo::taguser (
  $ensure,
  $tagpassword = true,
  $commands = 'ALL',
  $groups   = 'ALL',
  $hosts    = 'ALL'
) {

  if $tagpassword == 'false' {
    $password = false
  } else {
    $password = true
  }


  sudo::tagline { $name:
    ensure   => $ensure,
    password => $password,
    commands => $commands,
    groups   => $groups,
    hosts    => $hosts,
    group    => false,
  }
}
