# == Classification: Unclassified (provisional)
#
class ldapclient::package {
  
  package { 'SUNWtlsu':
    ensure   => present,
    provider => sun
  }

  package { 'SUNWnisu':
    ensure   => present,
    provider => sun
  }
}
