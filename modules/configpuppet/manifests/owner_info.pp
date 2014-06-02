# == Classification: Unclassified (provisional)
#
# Appends owner information to a system. This is useful for specifying
# contact information for particular classes of owners
# == Parameters
# $email        => The email address used to contact the owner
# $owner_type         => An owner category e.g: system, hardware, os
define configpuppet::owner_info($email, $owner_type) {
  tag('bootstrap')
  file{ "/etc/facts.d/${name}_owner.txt":
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => template('configpuppet/owner_facts.txt.erb'),
    require => File["/etc/facts.d"],
  }
}
