# == Classification: Unclassified (provisional)

define access::usersallowgroup (
  $ensure
) {
  access::usersallowline { $name:
    ensure   => $ensure,
    group    => true,
  }
}
