# @summary add an interface to an area
#
# adds an interface to an area.
# this define is used internaly from
# openospfd::area (but it's also possible to use it
# from youre toplevel.
# 
# @param target
#   the target file
# @param area_name
#   the name of the area to add the interface
# @param interface_name
#   the name of the interface to add
# @param config
#   the interface specific configuration
# @param passive
#   set to true for passive interface
#
define openospfd::interface (
  String  $target,
  String  $area_name,
  String  $interface_name = $title,
  Hash    $config         = {},
  Boolean $passive        = false,
) {

  concat::fragment{"ospfd: ${target} interface ${area_name}, ${interface_name}":
    target  => $target,
    content => epp('openospfd/ospfd.conf-interface.epp', {
      area_name      => $area_name,
      interface_name => $interface_name,
      passive        => $passive,
      config         => $config,
    }),
    order   => "500-${area_name}-500-${interface_name}",
  }
}
