# @summary add an area to the config
#
# @param target
#   the target to write the area into
# @param area_name
#   the name of the area
# @param config
#   area specific configuration
# @param interfaces
#   interfaces to add to the area (using openospfd::interface)
#   for detailed interface options see openospfd::interface
#
define openospfd::area (
  String $target,
  String $area_name  = $title,
  Hash   $config     = {},
  Hash   $interfaces = {},
) {

  concat::fragment{"ospfd: ${target} area ${area_name}":
    target  => $target,
    content => epp('openospfd/ospfd.conf-area.epp', {
      area_name => $area_name,
      config    => $config,
    }),
    order   => "500-${area_name}-000-head",
  }

  $interface_defaults = {
    target    => $target,
    area_name => $area_name,
  }

  pick_default($interfaces, $openospfd::interfaces).map |String $key, Hash $val| {
    create_resources('openospfd::interface', { "${key}_${target}" => $val }, {'interface_name' => $key } + $interface_defaults)
  }


  concat::fragment{"ospfd: ${target} area ${area_name} foot":
    target  => $target,
    content => '}',
    order   => "500-${area_name}-999-foot",
  }
}
