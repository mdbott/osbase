# == Classification: Unclassified (provisional)

# == Class: policy
#
# Installs the standard policy settings for the environment. This includes a
# number of subclasses covering security, packages etc
#
# Currently there are the following subclasses
# - policy::security : This configures solaris systems to default to linux md5 hashes for passwords
# - policy::packages : This removes the firefox package from a node (as required by security) and installs the
#   redhat-lsb on redhat systems to give access to the facter lsb* facts.
# - policy::services : This disables the NetworkManager service on redhat systems
#
# == Future Directions
#
#
# == Parameters
#
# [*var1*]
#   TODO parameters the class takes
#
# == Variables
#
# [*common*::*data*::*stuff*]
#   TODO External variables this class uses
#
# == Extlookup
#
# [*extvar1*]
#   TODO Variables this class resolves via extlookup()
#
# == Examples
#
#   include policy
#
# == Maintainers
#
# SSU
#
class policy {
  tag('bootstrap')

  include "policy::security"
  include "policy::packages"
  include "policy::services"
  include "policy::environment"
  include "policy::motd"
}
