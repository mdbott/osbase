# == Classification: Unclassified (provisional)
#
define haproxy::backend ($order          = '30',
												 $port           = '80',
												 $mode           = 'http',
												 $balance        = 'roundrobin', 
												 $servers        = '',
												 $options        = [],
												 $hash_type      = 'manual',
												 $query          = '',
												 $server_maxconn = '',
												 $cookie         = false,
												 $cookie_name    = '',
												 $cookie_options = '',
												 $server_check   = false,
												 $check_inter    = '',
												 $check_fall     = '',
												 $appsession     = false) {
													
	# Some validations
	case $hash_type {
		'manual': {
			# A servers array has to specified
			if ( $servers == '' ) {
				fail('servers can\'t be empty if hash_type is manual')
			}
		}
		'mcollective': {
			# A mongo query has to be specified
			if ( $query == '' ) {
				fail('query can\'t be empty if hash_type is mcollective')
			}
		}
		default: {
			fail("Invalid hash_type ${hash_type}. Accepted values are manual|mcollective")
		}
	}
	
	concat::fragment { "haproxy.cfg-backend-${name}":
		target  => "${haproxy::params::configdir}/haproxy.cfg",
		order   => $order,
		content => template('haproxy/backend.cfg.erb'),
	}
}
