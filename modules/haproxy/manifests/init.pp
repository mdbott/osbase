# == Classification: Unclassified (provisional)
#
class haproxy {
	include haproxy::params
	
	include "haproxy::install::${haproxy::params::install_mode}"
	include haproxy::config
	include haproxy::service
}
