# == Classification: Unclassified (provisional)
#
# Append to an environment variable, only if it isn't already defined
define util::append($variable, $value) {
  exec { "export $variable=$value:$$variable" :
    command => "$name",
    unless => "/bin/echo $$variable | /bin/grep $value"
  }
}