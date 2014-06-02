# == Classification: Unclassified (provisional)
#
define glusterold::servervol (
                      $sharedir = '',
                      $port     = '24016',
                      $authaddr = "*"

){
  # Setup the Gluster Server
  glusterold::volume {
    "posix_${name}":
      order             => 15,
      voltype           => "storage/posix",
      options           => [
        {
            'name' => 'directory',
            'value' => "${sharedir}",
        }
        ]
  }
  glusterold::volume {
    "locks_${name}":
      order             => 20,
      voltype           => "features/locks",
      subvolumes        => ["posix_${name}"],
  }
  glusterold::volume {
    "brick_${name}":
      order             => 25,
      voltype           => "performance/io-threads",
      options           => [
        {
            'name' => 'thread-count',
            'value' => '8',
        }
        ],
      subvolumes        => ["locks_${name}"],
  }
  glusterold::volume {
    "server_${name}":
      order             => 30,
      voltype           => "protocol/server",
      options           => [
        {
            'name' => 'transport-type',
            'value' => 'tcp',
        },
        {
            'name' => 'transport.socket.listen-port',
            'value' => "${port}",
        },
        {
            'name' => "auth.addr.brick_${name}.allow",
            'value' => $authaddr,
        }
        ],
      subvolumes        => ["brick_${name}"]
  }
}
