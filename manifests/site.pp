# == Classification: Unclassified (provisional)
#
import "init.pp"
import "nodes*.pp"

node default {
  #notice("node not defined")
  if $::is_runnervm == 'true' {
    include rpt_runnervm
    class {'satellite3': environment => 'rpvm'}
  }
  case $::operatingsystem {
      RedHat: { include role::redhat_essentials }
      default: { }
    }
}
