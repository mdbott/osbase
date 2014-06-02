# == Classification: Unclassified (provisional)
#
class role::redhat_essentials {
  # Setup satellite on all managed systems
  $usesatellite = hiera("satellite3::usesatellite")
  case $usesatellite {
    true: { include satellite3 }
    'clear': { file { '/etc/sysconfig/rhn/systemid':
                 ensure  => absent
               }
    }
    default : { }
  }
}
