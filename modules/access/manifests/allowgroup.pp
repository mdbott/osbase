# == Classification: Unclassified (provisional)

define access::allowgroup (
  $ensure,
  $hosts = "ALL"
) {
  case $::operatingsystem {
    Solaris: {
      access::usersallowgroup { $name:
        ensure  => $ensure,
      }
    }
    /CentOS|RedHat/: {
      access::accessconfgroup { $name:
        ensure  => $ensure,
        hosts   => $hosts,
      }
    }
    default: {
      fail("Unsupported Operating System: ${::operatingsystem}")
    }
  }
}
