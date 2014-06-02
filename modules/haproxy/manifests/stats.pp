# == Classification: Unclassified (provisional)
#
define haproxy::stats ($order               = 20,
												$ip                  = $::ipaddress,
												$port                = '80',
												$mode                = 'http',
												$stats               = true,
												$stats_uri           = '/stats',
												$stats_realm         = 'HAproxy\ Load\ Balancer\ Statistics',
												$stats_auth_user     = 'admin',
												$stats_auth_password = 'changeme') {



	concat::fragment { "haproxy.cfg-stats-${name}":
		target  => "${haproxy::params::configdir}/haproxy.cfg",
		order   => $order,
		content => template('haproxy/stats.cfg.erb'),
	}
}
