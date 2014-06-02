# == Classification: Unclassified (provisional)
#
# Persists the entire contents of a specified local path to a vcs repository.
#
# Currently persists contents to subversion: https://ozforge.dsd/svn/puppet-persist/trunk.
# If the folders on subversion do not exist, then they will be created in the repository with the contents inside local path.
# If the vcsrepo exists, but the local path does not, then it will be checked out from the repository.
# Also includes a cronjob to periodically checkin changes.
#
# Parameters:
#   $name		 							- An absolute path to the directory to persist.
#   $vcs_persistence_repo	- The repo to persist the data to.
#   $vcs_user 						- The user which has access to the underlying repo.
#   $vcs_password 				- The password used to access the repo.
#   $vcs_id								- The id to persist the data under, by default this is the fqdn of the host.
#   $vcs_committer				- The host which is allowed to commit into this repository.
#   $owner								- The owner of the persisted files
#   $group								- The group which owns the persisted files
#
define util::vcs_persist(
  $vcs_persistence_repo = "https://ozforge.dsd/svn/puppet-persist/trunk",
  $vcs_user = "cps2al-dsd",
  $vcs_password = "CPS2-alpha-007",
  $vcs_id = "${::fqdn}",
  $vcs_committer = "${::fqdn}",
  $owner = "root",
  $group = "root",
  $ignore = undef
) {
  $vcs_opts = "--username ${vcs_user} --password ${vcs_password} --no-auth-cache --non-interactive --trust-server-cert"
  $vcs_path = "${vcs_persistence_repo}/${vcs_id}${name}"
  $committer = $::fqdn == $vcs_committer

  # If vcsrepo doesn't exist and local_path does, create dirs on vcsrepo and checkin
  exec { "vcsrepo_checkin_for_${name}":
    unless  => "svn ls ${vcs_path} ${vcs_opts}",
    onlyif  => "ls ${name}",
    command => "svn mkdir --parents ${vcs_path} ${vcs_opts} -m \"Create path for ${name}\" && svn co ${vcs_path} ${name} ${vcs_opts} && svn add ${name}/* && svn ci ${name} ${vcs_opts} -m \"Initial commit for ${name}\"",
    path    => ['/usr/bin', '/bin'],
    user    => $owner,
    group   => $group,
  }

  # If this box is not meant to be committing changes into the repo, then revert all changes before the update to prevent conflicts
  if !$committer {
    exec { "revert_${name}":
      command => "svn revert -R && svn st |  grep '?' | sed 's/[ ]*?[ ]*//' | xargs -i rm '{}'",
      path    => ['/usr/bin', '/bin'],
      onlyif  => 'svn info',
      unless  => 'svn st | wc -l | egrep "^0$"',
      user    => $owner,
      group   => $group,
      cwd     => $name,
      before  => Vcsrepo["${name}"],
    }
  }

  # If vcsrepo exists and local_path doesn't exist, then checkout from repo
  # Only update to the latest version in the repository if we aren't the committer.
  vcsrepo { "${name}":
    ensure               => $committer ? {
      true    => present,
      default => latest
    },
    excludes             => $committer ? {
      true    => $ignore,
      default => undef,
    },
    force                => true,
    provider             => "svn",
    source               => "${vcs_path}",
    basic_auth_username  => "${vcs_user}",
    basic_auth_password  => "${vcs_password}",
    owner                => $owner,
    group                => $group,
    require              => Exec["vcsrepo_checkin_for_${name}"],
  }

  # Cron to persist to vcsrepo, but only commit if this host's fqdn matches vcs_committer.
  cron { "vcs_persist_${name}":
    command   => "/usr/bin/svn add --force ${name}/* && /usr/bin/svn commit -m \"Auto-commit by vcs_persist for ${::fqdn}: ${name}\" ${name} ${vcs_opts}",
    user      => $owner,
    hour      => "*/1",
    minute    => "*",
    monthday  => "*",
    month     => "*",
    weekday   => "*",
    ensure    => $committer ? {
      true    => present,
      default => absent
    },
    require   => Vcsrepo["${name}"],
  }
}
