# == Classification: Unclassified (provisional)
#
# Class: haproxy::install::package
#
#
class haproxy::install::package {
	package { 'haproxy':
		ensure => $haproxy::params::version,
	}
}
