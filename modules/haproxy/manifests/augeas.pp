# == Classification: Unclassified (provisional)
#
define haproxy::augeas ($changes,
												$section = '',
												$onlyif  = undef) {

	augeas { "haproxy-${name}":
		context   => "/files/etc/haproxy/haproxy.cfg/${section}",
		changes   => $changes,
		onlyif    => $onlyif,
		load_path => '/usr/share/augeas/lenses/contrib/',
		notify    => Class['haproxy::service'],
		require   => Class['haproxy::config'],
	}
}
