# == Classification: Unclassified (provisional)
#
# == Class: pam3
#
# Manages the plugable authentication module (pam) system on on Solaris 10 & RHEL-based systems.
#
# === Parameters
#
# [*pam_entries*]
# Optional. Hash. Specifices any additional pam entries required on the system. This 
# would usually be specified via hiera
#
#
#
# === Examples
#
#  class { pam3:}
#
# === Authors
#
# David Roberts <dxrober@dsd.defence.gov.au>
# Max Bott <mdbott@dsd.defence.gov.au>
#
# === Copyright
#
# Copyright 2014 David Roberts & Max Bott
#
class pam3 (
  $pam_entries ={}
  ) inherits pam3::params {
  anchor {'pam3::start':} -> class{'pam3::config':} -> anchor{'pam3::end':}
}
