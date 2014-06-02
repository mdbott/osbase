# == Classification: Unclassified (provisional)
#
class profile::haproxyconfig($virtualaddress = '170.157.142.216/26',
                          $clustersystems) {
  # HAProxy configuration
  $haproxy_defaults_maxconn = '64000'
  $haproxy_defaults_clitimeout = '120000'
  $haproxy_defaults_srvtimeout = '120000'
  # Network Configuration
  $names    = inline_template("<%= @clustersystems.sort.map{|serverrole,value|value['name']}.flatten.join(',')%>")
  $name_array = split($names,',')
  $ipaddrs  = inline_template("<%= @clustersystems.sort.map{|serverrole,value|value['ipaddr']}.flatten.join(',')%>")
  $ipaddr_array = split($ipaddrs,',')
  $virtualaddr_array = split($virtualaddress,'/')
  $virtualip = $virtualaddr_array[0]
  include haproxy



  haproxy::listen {"puppet":
        ip            => $virtualip,
        port          => '8140',
        mode          => 'tcp',
        balance       => 'roundrobin',
        options       => ['ssl-hello-chk','tcplog'],
        server_check  => 'enable',
        check_inter   => 5000,
        check_fall    => 3,
        check_rise    => 2,
        servers       => [
        {
            'name' => $name_array[0],
            'ip' => $ipaddr_array[0],
            'port' => 8140,
        },
        {
            'name' => $name_array[1],
            'ip' => $ipaddr_array[1],
            'port' => 8140,
        }
        ],

    }
#    haproxy::listen {"mco-stomp":
#        ip            => $virtualip,
#        port          => '61613',
#        mode          => 'tcp',
#        balance       => 'roundrobin',
#        maxconn       => '1',
#        options       => ['ssl-hello-chk','tcplog','abortonclose'],
#        server_check  => 'enable',
#        check_inter   => 5000,
#        check_fall    => 3,
#        check_rise    => 2,
#        servers       => [
#        {
#            'name' => "${name_array[0]}-mco-stomp",
#            'ip' => $ipaddr_array[0],
#            'port' => 8140,
#        },
#        {
#            'name'  => "${name_array[1]}-mco-stomp",
#            'ip'    => $ipaddr_array[1],
#            'port'  => 8140,
#            'backup'=> true,
#        }
#        ],
#
#    }
#    haproxy::listen {"puppet-dashboard":
#        ip              => $virtualip,
#        port            => '3000',
#        mode            => 'http',
#        balance         => 'roundrobin',
#        options         => ['httpchk','httplog'],
#        server_check    => 'enable',
#        check_inter     => 5000,
#        check_fall      => 3,
#        check_rise      => 2,
#        servers         => [
#        {
#            'name' => "${name_array[0]}-dashboard",
#            'ip' => $ipaddr_array[0],
#            'port' => 3000,
#        },
#        {
#            'name' => "${name_array[1]}-dashboard",
#            'ip' => $ipaddr_array[1],
#            'port' => 3000,
#        }
#        ],
#
#
#
#    }
    haproxy::stats {"stats":
        ip              => $virtualip,
        port            => '4000',
        mode            => 'http',
        stats_uri      => '/stats',
    }
}
