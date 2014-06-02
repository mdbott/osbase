# == Classification: Unclassified (provisional)
#
# Class: gluster-old
#
# TODO Description of class here
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
#   include TODO
#   class { 'module_template': var1 => "foo", }
#
# == Maintainers
#
# SSU
#
class glusterold {
  require glusterold::params
  include glusterold::install
  include glusterold::config
  include glusterold::service
}
