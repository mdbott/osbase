# == Classification: Unclassified (provisional)
# Drop a script into the custom facts directory. This allows for the extension of facter via scripts that output
# key=value pairs.
# == Parameters
# $content => The script content to place into ${dest}/${name}
# $dest  => The directory facter will search for custom fact files.
#
# == Variables
#
# == Examples
# configpuppet::scriptable_facts{ 'yourscript'
#    content => template('yourmodule/yourscript.erb'),
#}
define configpuppet::scriptable_facts($content, $dest = '/etc/facts.d') {
  tag('bootstrap')

  file { "${dest}/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => 755,
    content => $content,
    require => File["$dest"],
  }
}
