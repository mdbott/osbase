# == Classification: Unclassified (provisional)
#
# Manipulate a line in a file.
define util::line($file, $line, $ensure = 'present', $comment = "undef") {
#  if $::operatingsystem == 'Solaris'{
#    package { 'CSWggrep':
#      ensure   => present,
#      provider => pkgutil,
#      #require  => Class['pkg_management']
#    }
#  }
  case $ensure {
    
    present: {
      # If there is a comment put it before the line
      if  ($comment != "undef") {	
        exec { "/bin/echo -e '\n${comment}\n${line}' >> '${file}'":
          command => "/bin/echo -e '\n${comment}\n${line}' >> '${file}'",
          unless => $::operatingsystem ?{
                      solaris => "/opt/csw/bin/ggrep -qFx '${line}' '${file}'",
                      default => "/bin/grep -qFx '${line}' '${file}'",
                    },
        }
      } else {
      	# If no comment just add the line
        exec { "/bin/echo '${line}' >> '${file}'":
          command => "/bin/echo '${line}' >> '${file}'",
          unless => $::operatingsystem ?{
                      solaris => "/opt/csw/bin/ggrep -qFx '${line}' '${file}'",
                      default => "/bin/grep -qFx '${line}' '${file}'",
                    },
        } 	
      }
    }
    absent: {
      # If there is a comment try to remove it
      if  ($comment != "undef") {
        exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${comment}\\E\$/' '${file}'":
          command => "/usr/bin/perl -ni -e 'print unless /^\\Q${comment}\\E\$/' '${file}'",
          onlyif => $::operatingsystem ?{
                        solaris => "/opt/csw/bin/ggrep -qFx '${comment}' '${file}'",
                        default => "/bin/grep -qFx '${comment}' '${file}'",
                      },
        }
      }
      # Remove the line    
      exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
        command => "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'",
        onlyif => $::operatingsystem ?{
                      solaris => "/opt/csw/bin/ggrep -qFx '${line}' '${file}'",
                      default => "/bin/grep -qFx '${line}' '${file}'",
                    },
      }
    }
    default : { err ( "unknown ensure value ${ensure}" ) }
  }
}
