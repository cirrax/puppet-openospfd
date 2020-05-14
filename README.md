# Puppet module for openospfd and openospf6d

[![Build Status](https://travis-ci.org/cirrax/puppet-openospfd.svg?branch=master)](https://travis-ci.org/cirrax/puppet-openospfd)
[![Puppet Forge](https://img.shields.io/puppetforge/v/cirrax/openospfd.svg?style=flat-square)](https://forge.puppetlabs.com/cirrax/openospfd)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/cirrax/openospfd.svg?style=flat-square)](https://forge.puppet.com/cirrax/openospfd)
[![Puppet Forge](https://img.shields.io/puppetforge/e/cirrax/openospfd.svg?style=flat-square)](https://forge.puppet.com/cirrax/openospfd)
[![Puppet Forge](https://img.shields.io/puppetforge/f/cirrax/openospfd.svg?style=flat-square)](https://forge.puppet.com/cirrax/openospfd)




#### Table of Contents
1. [Overview](#overview)
1. [Usage](#usage)
1. [Reference](#reference)
1. [Contribuiting](#contributing)


## Description

This module will configure openspfd and openospf6d. 

## Usage

Include the main class and configure the parameters according to reference in your're hiera database.

In the default setup, ospfd and ospf6d is configured, if you like to configure only one or the other, you should set 
openospfd::include\_ospfd and/or openospfd::include\_ospfd6 to false.

An Example hiera configuration could be:

~~~
openospfd::ospfd::redistribute:
  - value: '10.0.0.0/8'

openospfd::ospf6d::redistribute:
  - value: '2a03:580:ffff::/48'

# area to use for ospfd and ospf6d
# for different areas, you coud use opensospfd::ospfd::areass and
# openospfd::ospf6d::areas. 
openospfd::areas:
  0.0.0.0:
    config:
      demote: 'carp'
    interfaces:
      vio4: {}
      vlan42:
        config:
          metric: '5'
      carp5:
        passive: true
~~~

## Reference

see REFERENCE.md file or the documented parameters in the classes/defines.

## TODO
Unfortunatly no spec tests yet!

## Contributing

Please report bugs and feature request using GitHub issue tracker.

For pull requests, it is very much appreciated to check your Puppet manifest with puppet-lint
and the available spec tests  in order to follow the recommended Puppet style guidelines
from the Puppet Labs style guide.

### Authors

This module is mainly written by [Cirrax GmbH](https://cirrax.com).

See the [list of contributors](https://github.com/cirrax/puppet-openospfd/graphs/contributors)
for a list of all contributors.
