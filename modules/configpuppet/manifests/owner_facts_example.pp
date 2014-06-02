# == Classification: Unclassified (provisional)
class configpuppet::owner_facts_example {
  tag('bootstrap')
  @configpuppet::owner_info {'Example':
    email  => 'Example@example.com',
    tag    => 'example',
  }

}
