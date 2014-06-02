# == Classification: Unclassified (provisional)
#
# == Class: buildmaster
#
#
# === Parameters
#
#
# === Hiera
#
# === Examples
#
# include buildmaster
#
# === Maintainers
#
# UPS
#
class buildmaster {

  package {'buildbot-master':
   ensure => latest,
  }

}
