
v1.0.0b (2014-07-07)
====================

  - `Cluster.remove_zone` now raises `ArgumentError` on attempt to remove a
     non-existent zone.
  - `Cluster.remove_node` and `RendezvousHash.remove_node` now raise
    `ArgumentError` on attempt to remove  a non-existent node.
  - Support for custom hash functions retracted for 1.0.0 milestone.
  - `murmur_seed` keyword argument renamed to `seed` for `Cluster` and
    `RendezvousHash` `initialize` methods.

v1.0.0a (2014-07-06)
====================

  - Initial Release.