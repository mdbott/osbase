# == Classification: Unclassified (provisional)
# == Class: configpuppet
#
# Configures the puppet agent. The configpuppet class configures a node as a
# puppet client. This includes setting the contents of the puppet.conf config
# file as well as ensuring the puppet processes are running.
#
# The configpuppet::master subclass configures a  node as as puppet master.
#
# == Future Directions
#
#
# == Parameters
#
# [*var1*]
#   TODO parameters the class takes
#
# == Variables
#
# [*common*::*data*::*stuff*]
#   TODO External variables this class uses
#
# == Extlookup
#
# [*extvar1*]
#   TODO Variables this class resolves via extlookup()
#
# == Examples
#
#   include configpuppet
#
# == Maintainers
#
# SSU
#
class configpuppet  {
  tag('bootstrap')
  tag('puppet')
  include configpuppet::client
}
