# == Classification: Unclassified (provisional)
#
# == Class: hg_revision
#
# Records the history puppet codebase revisions applied to a client in $revdir
#
# Provides the fact hg_last, containing the last revision applied
#
# === Parameters
#
# [*fail_if_not_child_revision*]
#   Aborts if the revision attempting to be applied is older than the last applied revision. If
#   there is no previously recorded revision (hg_last fact empty) it will not abort.
#
# === Hiera
#
#
# === Examples
#
# include hg_revisions
#
# === Maintainers
#
# UPS
#
class hg_revisions ($fail_if_not_child_revision = false) {

  # If you change this update modules/hg_revisions/lib/facter/hg_last.rb (can i remove that
  # duplication somehow?)
  $revdir = '/var/lib/puppet/hg_revisions'

  $hg_directory = regsubst($settings::manifestdir, '/manifests$', '')
  $revid = generate('/usr/bin/hg', '-R', $hg_directory, 'id', '-i')

  if $fail_if_not_child_revision == true and $::hg_last != '' {
    $t = generate('/usr/bin/hg', '-R', $hg_directory, 'log', '-r', "(${revid} + ancestors(${revid})) and ${::hg_last}")
    if $t == '' {
      fail("aborting, ${::hg_last} is not an ancestor of ${revid}")
    }
  }

  file { $revdir:
    ensure => directory,
  }

  file { "${revdir}/${revid}":
    ensure => present,
    before => File["${revdir}/last"],
  }

  file { "$revdir/last":
    ensure  => present,
    content => $revid,
  }

}
