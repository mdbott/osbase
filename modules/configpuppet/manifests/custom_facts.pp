# == Classification: Unclassified (provisional)
# Ensure custom facts are present on hosts. This gives puppet the ability to update facts
# placed on a system by bootstrap, or add things like ownership information to the hosts.
# == Parameters
# $facts => is a Hash that contains all the facts you want deployed in a particular fact file. These facts should
#           be related to each other
# $dest  => The directory facter will search for custom fact files.
#
# == Variables
#
#
# == Examples
# configpuppet::custom_facts{ 'systemOwners':
#  facts => {
#    'team'  => 'test',
#    'email' => 'test@example.com',
#  }
#}
define configpuppet::custom_facts($facts, $dest = '/etc/facts.d') {
  tag('bootstrap')

  file { "${dest}/${name}.txt":
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => template('configpuppet/custom_facts.txt.erb'),
    require => File["$dest"],
  }
}
