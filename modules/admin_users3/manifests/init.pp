# == Classification: Unclassified (provisional)
#
# == Class: admin_users3
#
# This class consumes a hash of Hiera data to create appropriate sets of
# administrative users and groups for system management
#
# === Parameters
#
# === Variables
#
# [*users*]
# Consumes a hash of hiera data to generate appropriate data for the
# create_resources function to create the user resources.
#
# [*groups*]
# Consumes a hash of hiera data to generate appropriate data for the
# create_resources function to create the group resources.
#
# The hiera data should follow a YAML hash format (although you can change
# to a different backend, but it still needs to produce a hash of data
# for the create_resources function to consume). The basic data format should
# look as follows to create resources:
#
#  adminusers:
#    eicadwa:
#      ensure: present
#      uid: 1001
#      gid: itsupt
#      gid: itsupt
#      comment: "Eva Cadwallader"
#      sudocommand: ALL
#      managehome: true
#      groups: unixadm
#      type: ssh-dss
#      key:  "AAAAB3NzaC1...."
#  admingroups:
#    itsupt:
#      gid: 1000
#
# Note - you can use appropriately formatted YAML to delete user/group
# resources also - e.g. :
#
#  adminusers:
#    eicadwa:
#      ensure: absent
#
#
# Note - the hiera variables have no defaults values set, hence if
# the variable lookup fails, or the data is crap then the hiera function will
# fail and catalog compilation will fail.
#
# === Examples
#
# include adminusers
#
# === Maintainers
#
# UPS
#
class admin_users3 {

  $adminusers = hiera_hash(admin_users3::adminusers,false)
  if $adminusers{
    create_resources(admin_users3::extendeduser,$adminusers)
  }

  $admingroups = hiera_hash(admin_users3::admingroups,false)
  if $admingroups{
    create_resources(group,$admingroups)
  }

}
