# == Classification: Unclassified (provisional)
#
# == Class: nfs
#
# Sets up a host as an NFS client or server
#
# == Future Directions
#
#
# == Parameters
#
#
# == Variables
#
#
# == Extlookup
#
# [*nfs4domain*]
#   NFSv4 domain
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
class nfs {
  include nfs::client
}
