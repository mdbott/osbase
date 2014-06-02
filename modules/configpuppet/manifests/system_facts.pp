# == Classification: Unclassified (provisional)
define configpuppet::system_facts($env, $location, $oncall = false, $supporthours = 'n/a') {
    tag('bootstrap')
    configpuppet::custom_facts{'system_facts':
    facts => {
    'system'        => $name,
    'env'           => $env,
    'location'      => $location,
    'oncall'        => $oncall,
    'supporthours'  => $supporthours,
    },
  }
}