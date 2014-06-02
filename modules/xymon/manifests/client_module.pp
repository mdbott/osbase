# == Classification: Unclassified (provisional)
#
define xymon::client_module(
  $cmd,
  $cmd_base,
  $log_file,
  $source = undef,
  $content = undef,
  $enabled = true,
  $interval = '5m'
  ) {

  $log_file_base = "${xymon::params::xymon_log_file_base}"
  $absolute_cmd = "${cmd_base}/${cmd}"
  $env_file = "${xymon::params::xymon_cfg_location}"

  File {
      owner   => "${xymon::params::xymon_owner}",
      group   => "${xymon::params::xymon_group}",
      require => Package['xymon'],
  }

  if ($source == undef and $content == undef) or ($source != undef and $content != undef) {
    fail("source or content should be set, but received source[${source}], content[${content}]")
  } elsif $source != undef {
    file { "${absolute_cmd}":
      ensure  => file,
      source  => $source,
      mode    => 754,
    }
  } else {
    file { "${absolute_cmd}":
      ensure  => file,
      content => $content,
      mode    => 754,
    }
  }

  file {"xymon_client_module_${name}.cfg":
    path    => "${xymon::params::xymon_clientlaunchd_location}/xymon_client_module_${name}.cfg",
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    notify  => Service['xymon'],
    require => File['xymon_launchd'],
    content => inline_template(
'[<%= @name %>]
        <% if !@enabled -%>
        DISABLED
        <% end -%>
        ENVFILE <%= @env_file %>
        CMD <%= @absolute_cmd %>
        <% if @log_file =~ %r!^/! -%>
        LOGFILE <%= @log_file %>
        <% else -%>
        LOGFILE <%= @log_file_base %>/<%= @log_file %>
        <% end -%>
        INTERVAL <%= @interval %>
'),
  }

}
