# @summary main class to configure openospfd
#
# This is the main class to configure openospfd.
# Parameters set here are used as defaults for
# ospfd and ospf6d configuration. They can all be 
# overwritten in opfd respective ospf6d class.
#
# @param include_ospfd
#   whether to include/configure ospfd
# @param include_ospf6d
#   whether to include/configure ospf6d
# @param owner
#   owner of the configuration files
# @param group
#   group of the configuration files
# @param areas
#   areas to set up
#   this Hash is used to run openospfd::area resource
# @param router_id
#   the router-id
# @param rdomain
#   the rdomain to set
# @param rtable
#   the rdomain to start in (set ospfd_rtable in rc.conf.local)
# @param macros
#   Hash of macros to define
# @param global_config
#   Hash of global configurations
# @param rcconffile
#   the rc.conf file to write startup parameters into
# @param interfaces
#   default interfaces to add to the area (using openospfd::interface)
#   for detailed interface options see openospfd::interface
#   
# @example
#   include openospfd
class openospfd (
  Boolean          $include_ospfd  = true,
  Boolean          $include_ospf6d = true,
  String           $owner          = 'root',
  String           $group          = 'wheel',
  Hash             $areas          = {},
  Optional[String] $router_id      = undef,
  Optional[String] $rdomain        = undef,
  Optional[String] $rtable         = undef,
  Hash             $macros         = {},
  Hash             $global_config  = {},
  String           $rcconffile     = '/etc/rc.conf.local',
  Hash             $interfaces     = {},
) {
  if $include_ospfd {
    include openospfd::ospfd
  }

  if $include_ospf6d {
    include openospfd::ospf6d
  }
}
