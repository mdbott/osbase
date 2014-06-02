# == Classification: Unclassified (provisional)
# == Class: vmwaretools
#
# This class handles installing the VMware Tools Operating System Specific
# Packages. http://packages.vmware.com/
#
# === Parameters:
#
# [*tools_version*]
#  The version of VMware Tools to install
#  Default: 5.0u1
#
# [*ensure*]
#  Ensure if present or absent.
#  Default: present
#
# [*autoupgrade*]
#  Upgrade package automatically, if there is a newer version.
#  Default: false
#
# [*package*]
#  Name of the package
#  Only set this if your platform is not supported or you know what you are
#  doing.
#  Default: auto-set, platform specific
#
# [*servce_ensure*]
#  Ensure if service is running or stopped.
#  Default: running
#
# [*service_name*]
#  Name of Vmware Tools service
#  Only set this if your platform is not supported or you know what you are
#  doing.
#  Default: auto-set, platform specific
#
# [*service_enable*]
#  Start service at boot
#  Default: true
#
# [*service_hasstatus*]
#  Service has status command
#  Default: true
#
# [*service_hasrestart*]
#  Service has restart command.
#  Default: true
#
# === Actions:
#
# Removes old VmwareTools package or runs vmware-uninstall-tools.pl if found
# Installs a vmware YUM repository.
# Installs the OSP.
# Starts the vmware-tools services.
#
# === Requires:
# Nothing.
#
# === Sample Usage:
#
# class { vmwaretools':
#   tools_version =>'4.0u3',
# }
#
# === Authors:
#
# Mick Arnold <mike@razorsedge.org>
# Modified by SS
#
# === Copyright:
#
# Copyright (c) 2011 Mike Arnold, unless otherwise noted.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


class vmwaretools (
  $tools_version                   = '5.0u1',
  $ensure                          = 'present',
  $autoupgrade                     = false,
  $package_kernel_mod              = $vmwaretools::params::package_kernelmod,
  $package                         = $vmwaretools::params::package_name,
  $service_ensure                  = 'running',
  $service_name                    = $vmwaretools::params::service_name,
  $service_enable                  = true,
  $service_hasstatus               = false,
  $service_hasrestart             = true
  )
  inherits vmwaretools::params {

  case $ensure{
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else{
        $package_ensure = 'present'
      }

      if $service_ensure in [running, stopped] {
        $service_ensure_real = $service_ensure
      } else{
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::virtual {
    'vmware': {
      $service_pattern = $tools_version ? {
        /(5.0)/ => 'vmtoolsd',
        default => 'vmware-guestd',
      }

      $majdistrelease = regsubst($::operatingsystemrelease, '^(\d+)\.(\d+)','\1')

      #We use $::operatingsystem and not $::osfamily because certain things
      #(like Fedora) need to be excluded
      # -- Mark: I only care about RHEL/CentOS, so I removed the rest
      case $::operatingsystem{
        'RedHat', 'CentOS' :{
          yumrepo { 'vmware-tools':
            descr    => "VMware Tools ${tools_version} - ${vmwaretools::params::baseurl_string}${majdistrelease} ",
            enabled  => 1,
            gpgcheck => 0,
            gpgkey   => "${vmwaretools::params::yum_path}VMWARE-PACKAGING-GPG-KEY.pub",
            baseurl  => "${vmwaretools::params::yum_path}/${majdistrelease}/",
            priority => $vmwaretools::params::yum_priority,
            protect  => $vmwaretools::params::yum_protect,
            before   => Package['vmware-tools'],
            require  => Class['pkg_management'],
          }
        }
        default: {}
      }

      package { 'VMwareTools':
        ensure => 'absent',
        before => [Package['vmware-kernel-mod'], Package['vmware-tools'], ],
      }

      exec{'vmware-uninstall-tools':
        command  => '/usr/bin/vmware-uninstall-tools.pl && rm -rf /usr/lib/vmware-tools',
        path     => '/bin:/sbin:/usr/bin:/usr/sbin',
        onlyif   => 'test -f /usr/bin/vmware-uninstall-tools.pl',
        before   => [Package['vmware-tools'], Package['VMwareTools'], ],
      }
      # I don't think the local is needed so I didn't copy it across
      package {'vmware-kernel-mod':
        ensure   => $package_ensure,
        name     => $package_kernel_mod,
        require  => Yumrepo['vmware-tools']
      }

      package { 'vmware-tools':
        ensure   => $package_ensure,
        name     => $package,
        require  => Yumrepo['vmware-tools']
      }

      package { 'kmod-vmware-tools-pvscsi':
        ensure   => $package_ensure,
        name     => $package_kernelpvscsimod,
        require  => [Yumrepo['vmware-tools'],Package['vmware-kernel-mod']]
      }

      file { '/etc/modprobe.d/vmware-tools-pvscsi.conf':
        ensure  => 'file',
        source => 'puppet:///modules/vmwaretools/vmware-tools-pvscsi.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '644',
      }


      service {'vmware-tools':
        ensure      => $service_ensure_real,
        name        => $service_name,
        enable      => $service_enable,
        hasrestart  => $service_hasrestart,
        hasstatus   => false,
        pattern     => $service_pattern,
        require     => [ Package['vmware-kernel-mod'], Package['vmware-tools'], ],
      }
    }

    #If we aren't using VMware, don't do anything.
    default: {}
  }
}
