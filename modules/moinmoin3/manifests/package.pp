# == Classification: Unclassified (provisional)
#
class moinmoin3::package{

  package {['moin','xapian-core','xapian-bindings','xapian-bindings-python']:
   ensure => latest,
  }

}
