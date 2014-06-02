# == Classification: Unclassified (provisional)
#
class sshd3::config {
  file { '/etc/ssh/sshd_config':
    ensure  => file,
    content => template($sshd3::params::configtemplate),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }
}