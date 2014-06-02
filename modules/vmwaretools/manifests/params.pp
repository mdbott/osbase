# == Classification: Unclassified (provisional)
# == Class: vmwaretools::params
#
# This class handles OS-specific configuration of the vmwaretools module.
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


class vmwaretools::params{
  $repo_server = extlookup("reposerver")
  $yum_path     = "http://${repo_server}/unix/redhat/repositories/vmware/"
  $yum_priority = '50'
  $yum_protect  = '0'

  case $::operatingsystem {
    'RedHat': {
      $package_kernelmod        = 'vmware-tools-esx-kmods'
      $package_kernelpvscsimod  = 'kmod-vmware-tools-pvscsi'
      $package_name             = 'vmware-tools-esx-nox'
      $service_name             = 'vmware-tools-services'
      $baseurl_string           = 'rhel' #must be lower case
      }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }
}
