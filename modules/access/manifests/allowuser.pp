# == Classification: Unclassified (provisional)

define access::allowuser (
  $ensure,
  $hosts = "ALL"
)
{
  case $::operatingsystem {
      Solaris: {
        access::usersallowuser { $name:
          ensure   => $ensure,
        }
      }
      /CentOS|RedHat/: {
        access::accessconfuser { $name:
          ensure   => $ensure,
          hosts    => $hosts,
        }
      }
      default: {
        fail("Unsupported Operating System: ${::operatingsystem}")
      }
  }
}
