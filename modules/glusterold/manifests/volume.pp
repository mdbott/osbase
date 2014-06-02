# == Classification: Unclassified (provisional)
#
define glusterold::volume ($order           = 30,
                          $voltype              = '',
                          $options              = [],
                          $subvolumes           = [],
                          $target               = 'glusterfsd'
                          ) {
  if ( $type == '' ) {
        fail('volume type can\'t be empty')
      }



  concat::fragment { "${target}-volume-${name}":
    target  => "${glusterold::params::configdir}/${target}.vol",
    order   => $order,
    content => template('glusterold/volume.cfg.erb'),
  }
}