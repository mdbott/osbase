# == Classification: Unclassified (provisional)
#
# == Class: winbind3
#
# Sets up SSH servers in /etc/ssh/sshd.conf depending on environment
#
# === Parameters
#
# === Hiera
#
#
# === Examples
#
# include winbind3
#
# === Maintainers
#
# UPS
#
class winbind3(
  $adservers,
  $addomain,
  $kerberosrealm,
  $kerberosdomains,
  $defaultkerberosdomain,
  $adusername,
  $adpassword,
  $hostsallow)
   inherits winbind3::params {

  anchor {'winbind3::start':} 
    ->class{'winbind3::package':} -> 
    class{'winbind3::config':
      addomain      => $addomain,
      kerberosrealm => $kerberosrealm
    }
    ~> class{'winbind3::netjoin':} ~> class{'winbind3::service':}  
    -> anchor{'winbind3::end':}
}
