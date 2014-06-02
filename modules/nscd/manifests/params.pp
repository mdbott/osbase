# == Classification: Unclassified (provisional)
#
class nscd::params{
    $nscd_conf_ver = "${::operatingsystem}${::operatingsystemrelease}" ? {
    'Solaris5.10'    => 'Solaris10',
    /Solaris10_u*/   => 'Solaris10',
    'Solaris5.11'    => 'Solaris11',
    /RedHat5\.[5-9]/ => 'RedHat',
    /RedHat6.*/      => 'RedHat',
    /CentOS6.*/      => 'RedHat',
    default          => fail("${::operatingsystem}${::operatingsystemrelease} is not supported"),
  }

  case $nscd_conf_ver {
    'Solaris11': {
      $packagename = 'SUNWcsr'
      $servicename = 'name-service-cache'

    }
    'Solaris10': {
      $packagename = 'SUNWcsr'
      $servicename = 'name-service-cache'
      $cachedefs   =
      {
  ##########################################
  # Solaris10 nscd default cache Definitions
  ##########################################

  
    'audit_user'                    => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'auth_attr'                     => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'bootparams'                    => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => 'no',
    },
    'ethers'                        => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'exec_attr'                     => {  'posttl'    => '3600',
                                          'negttl'    => '300',
                                          'hotcount'  => '20',
    },
    'group'                         => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => 'no',
    },
    'hosts'                         => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'ipnodes'                       => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'netmasks'                      => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => 'no',
    },
    'networks'                      => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'passwd'                        => {  'posttl'    => '600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'prof_attr'                     => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => 'no',
    },
    'project'                       => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'protocols'                     => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'rpc'                           => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => 'no',
    },
    'services'                      => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'tnrhdb'                        => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    },
    'tnrhtp'                        => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => 'no',
    },
    'user_attr'                     => {  'posttl'    => '3600',
                                          'negttl'    => '5',
                                          'hotcount'  => '20',
    }
  }

    }
    'RedHat': {
      $packagename = 'nscd'
      $servicename = 'nscd'
      $cachedefs   =
      {
  ##########################################
  # RedHat nscd default cache Definitions
  ##########################################
    'passwd'                    => { 'posttl'    => '600',
                                      'negttl'    => '20',
                                      'autoprop'  => 'yes',
    },
    'group'                    => { 'posttl'    => '3600',
                                      'negttl'    => '60',
                                      'autoprop'  => 'yes',
    },
    'hosts'                    => { 'posttl'    => '3600',
                                      'negttl'    => '20',
                                      'autoprop'  => 'no',
    },
    'services'                    => { 'posttl'    => '28800',
                                      'negttl'    => '20',
                                      'autoprop'  => 'no',
    }
  }

    }
  }
}