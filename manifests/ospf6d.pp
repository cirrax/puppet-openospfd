# @summary main class to configure ospf6d
#
# This class configures ospfd.
# It takes default values from ::openospfd class
#
# @param config_file
# @param service_name
#   the name of the ospfd service
# @param service_ensure
#   what we ensure for the service
# @param service_enable
#   should the service be enabled
# @param validate_cmd
#   command to validate the configuration file
# @param areas
#   Hash of areas to set up with openospfd::area
#   resource.
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
# @param redistribute
#   Array of hashes for redistribute vals
#   one hash has the following keys available:
#   value: one of static|connected|default or a prefix or 'rtlabel label'
#   set: hash of settings (eg metric: 300)
#   depend: interface name to depend on
#   negativ: boolean, if set to true, the rule is a 'no redistribute' rule'
#   exampel in yaml notation:   
#   
#   - value: 'static'
#     set:
#       metric: '300'
#       type: '2'
#     depend: 'carp3'
#
class openospfd::ospf6d (
  String           $config_file    = '/etc/ospf6d.conf',
  String           $service_name   = 'ospf6d',
  String           $service_ensure = 'running',
  String           $service_enable = 'true',
  String           $validate_cmd   = '/usr/sbin/ospf6d -nf %',
  Optional[Hash]   $areas          = undef,
  Optional[String] $router_id      = undef,
  Optional[String] $rdomain        = undef,
  Optional[String] $rtable         = undef,
  Optional[Hash]   $macros         = undef,
  Optional[Hash]   $global_config  = undef,
  Optional[Array]  $redistribute   = [],
) {
  include openospfd

  concat { $config_file:
    owner        => $openospfd::owner,
    group        => $openospfd::group,
    mode         => '0600',
    validate_cmd => $validate_cmd,
    notify       => Service[$service_name],
  }

  concat::fragment { 'ospf6d: global config':
    target  => $config_file,
    content => epp('openospfd/ospfd.conf-header.epp', {
        router_id     => pick_default($router_id, $openospfd::router_id),
        rdomain       => pick_default($rdomain, $openospfd::rdomain),
        macros        => pick_default($macros, $openospfd::macros),
        global_config => pick_default($global_config, $openospfd::global_config),
        redistribute  => $redistribute,
    }),
    order   => '000',
  }

  $area_default = { target => $config_file }

  pick_default($areas, $openospfd::areas).map |String $key, Hash $val| {
    create_resources('openospfd::area', { "6_${key}" => $val }, { 'area_name' => $key } + $area_default )
  }

  $_rtable = pick_default($rtable, $openospfd::rtable)
  if $_rtable and $openospfd::rcconffile {
    file_line { 'openospf6d ensure rtable':
      path  => $openospfd::rcconffile,
      line  => "ospf6d_rtable=${_rtable}",
      match => '^ospf6d_rtable=',
    }
  } else {
    file_line { 'openospf6d ensure rtable':
      ensure => 'absent',
      path   => $openospfd::rcconffile,
      match  => '^ospf6d_rtable=',
    }
  }

  service { $service_name :
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
