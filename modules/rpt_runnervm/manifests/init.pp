# == Classification: Unclassified (provisional)
#
# == Class: rpt_runnervm
#
# If the external fact set on the clinet is 'true' the module calls
# the function rpt_new_runner.rb to update the local web page and SSU wiki
#
# == External fact ==
#
# [*is_runnervm*]
#    Returns 'true' if set in the file /etc/facter/fact.d/runnervm.txt on the client.
#    i.e. root@acorn[/] # cat /etc/facter/facts.d/runnervm.txt
#                         is_runnervm=true
#
# == Custom function ==
#
# [*rpt_new_runner*]
#    Reports on a new clinet by running a python script 'xmlrpc_runnervm_server_list.py' 
#    to update the local web page and the 'SSU' wiki with the FQDN and IP address of the client.
#
# === Maintainers
#
# UPS
#
class rpt_runnervm {
  
  if $::is_runnervm == 'true' {
    $host_fqdn=$::fqdn
    $ipaddress=$::ipaddress
    $pathtomod=get_module_path('rpt_runnervm')
    rpt_new_runner($host_fqdn,$ipaddress,$pathtomod)
  } 
}
