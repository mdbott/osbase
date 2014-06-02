# == Classification: Unclassified (provisional)
#
# This file should be capable of being run directly with puppet apply,
# so this manifest must be complete with respect to module dependencies.
import "/etc/puppet/manifests/init.pp"
# include stages
include etckeeper
