# == Classification: Unclassified (provisional)
#
define glusterold::clientvol (
                      $remotehost1 = 'puppet2.test.dsd',
                      $remotehost2 = 'puppet3.test.dsd',
                      $port        = '24016'
                      ) {
  # Setup the Gluster Client
  glusterold::volume {
    "remote1_${name}":
      order             => 15,
      voltype           => "protocol/client",
      options           => [
        {
            'name' => 'transport-type',
            'value' => 'tcp',
        },
        {
            'name' => 'transport.socket.remote-port',
            'value' => "${port}",
        },
        {
            'name' => 'remote-host',
            'value' => "${remotehost1}",
        },
        {
            'name' => 'remote-subvolume',
            'value' => "brick_${name}",
        },
        ],
      target            => "glusterfs"
  }
  glusterold::volume {
    "remote2_${name}":
      order             => 20,
      voltype           => "protocol/client",
      options           => [
        {
            'name' => 'transport-type',
            'value' => 'tcp',
        },
        {
            'name' => 'transport.socket.remote-port',
            'value' => "${port}",
        },
        {
            'name' => 'remote-host',
            'value' => "${remotehost2}",
        },
        {
            'name' => 'remote-subvolume',
            'value' => "brick_${name}",
        },
        ],
      target            => "glusterfs"
  }

  glusterold::volume {
    "replicate_${name}":
      order             => 25,
      voltype           => "cluster/replicate",
      subvolumes        => ["remote1_${name}","remote2_${name}"],
      target            => "glusterfs"
  }
  glusterold::volume {
    "writebehind_${name}":
      order             => 30,
      voltype           => "performance/write-behind",
      options           => [
        {
            'name' => 'window-size',
            'value' => '1MB',
        }
        ],
      subvolumes        => ["replicate_${name}"],
      target            => "glusterfs"
  }
  glusterold::volume {
    "cache_${name}":
      order             => 35,
      voltype           => "performance/io-cache",
      options           => [
        {
            'name' => 'cache-size',
            'value' => '512MB',
        }
        ],
      subvolumes        => ["writebehind_${name}"],
      target            => "glusterfs"
  }
}
