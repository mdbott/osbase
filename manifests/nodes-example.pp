# == Classification: Unclassified (provisional)
#
###########################
# Example Node Systems
###########################

node exampledev  {
  include profile::os::base
  include profile::os::access
  include profile::os::monitoring
  include profile::os::auditing
  include profile::os::puppet
  configpuppet::system_facts {'exampleapp':
    env          => 'development',
    location     => 'R5-1',
    oncall       => false,
    supporthours => '8x5',
  }
  Configpuppet::Owner_info <| tag == 'exampleops' |> { owner_type => ['os']}
  Configpuppet::Owner_info <| tag == 'examplehardware' |> { owner_type => ['hardware']}


  sudo3::netgroup { 'role-exampleapp-support':
    ensure   => present,
    groups   => 'exampleadm',
    commands => 'ALL',
  }
  sudo3::user { 'exampleadm':
    ensure   => present,
    password => false,
    commands => ['/etc/init.d/exappd', '/etc/init.d/httpd'],}

}


node 'app.example.com'  inherits exampledev {
   
}


