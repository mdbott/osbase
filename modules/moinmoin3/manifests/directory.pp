# == Classification: Unclassified (provisional)
#
class dns3::directory{

  file { '/usr/share/moin/data':
   ensure => directory,
   owner => apache,
   group => apache,
   recurse => true,
  }

  file { '/usr/share/moin/underlay':
   ensure => directory,
   owner => apache,
   group => apache,
   recurse => true,
  }

}
