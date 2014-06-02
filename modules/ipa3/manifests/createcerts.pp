# == Classification: Unclassified (provisional)
#
class ipa3::createcerts {
  exec { 'createcerts':
    command => "/usr/bin/certutil -A -d /etc/pki/nssdb -n IPA CA -t CT,C,C -a -i /etc/ipa/ca.crt",
    creates => $ipa3::params::certfile,
  }
}