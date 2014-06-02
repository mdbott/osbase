# == Classification: Unclassified (provisional)
#
# Class: haproxy::config::concat
#
#
class haproxy::config::concat {
	# Setup concat module
	include concat::setup
	
	# Setup node config file for concat module and include first fragment
	concat { "${haproxy::params::configdir}/haproxy.cfg":
		owner   => 'root',
		group   => 'root',
		require => Class['haproxy::config'], 
		notify  => Class['haproxy::service'],
	}
	
	concat::fragment { 'haproxy.cfg-global':
		target  => "${haproxy::params::configdir}/haproxy.cfg",
		order   => 10,
		content => template('haproxy/global.cfg.erb')
	}
	
	concat::fragment { 'haproxy.cfg-defaults':
		target  => "${haproxy::params::configdir}/haproxy.cfg",
		order   => 15,
		content => template('haproxy/defaults.cfg.erb'),
	}
}
