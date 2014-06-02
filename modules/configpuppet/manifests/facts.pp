# == Classification: Unclassified (provisional)
class configpuppet::facts  {
  tag('bootstrap')
  file {'/etc/facts.d':
    ensure  => 'directory',
    recurse => true,
    purge   => true,
  }
}
