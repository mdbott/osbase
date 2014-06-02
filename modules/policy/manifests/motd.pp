# == Classification: Unclassified (provisional)

class policy::motd ($org = 'dsd') {

  $file_location = 'puppet:///modules/policy'

  $lowercase_org = inline_template("<%= @org.downcase %>")

  file { '/etc/issue':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "$file_location/motd.$lowercase_org",
  }
}
