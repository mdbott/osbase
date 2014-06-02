# == Classification: Unclassified (provisional)
#
class dns3::config{

  file { '/etc/resolv.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($dns3::configtemplate),
  }

}
