# == Classification: Unclassified (provisional)
#
# Pull a file from elsewhere not using puppet://...
define util::download_file(
   $site="",
   $cwd="",
   $user="root",
   $group="root",
   $timeout = 300
) {
  exec { $name:
    command => $::operatingsystem ?{
                      solaris => "/opt/csw/bin/wget ${site} -O ${name}",
                      default => "/usr/bin/wget ${site} -O ${name}",
                    },
    cwd => $cwd,
    creates => "${cwd}/${name}",
    timeout => $timeout,
    user => $user,
    group => $group,
  }
}
