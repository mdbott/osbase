# == Classification: Unclassified (provisional)
class configpuppet::owner_facts {
  tag('bootstrap')
  @configpuppet::owner_info {'Example':
    email  => 'Example@example.com',
    tag    => 'example',
  }

}
