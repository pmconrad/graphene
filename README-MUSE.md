(This file serves as a reminder when doing maintenance.)

Differences between MUSE and Graphene
=====================================

* Genesis
* License
* Hardfork times
* config:
  - CORE-symbol CORE => MUSE
  - address prefix GPH => MUSE
  - precision 5 => 4 digits
  - CORE cycle rate 17 => 48
  - DB version
  - irreversible_threshold 70 => 60
  - no STEALTH asset


Differences between MUSE and BitShares (code-wise)
==================================================

* Genesis
* License
* Seed-nodes
* --seed-nodes option ?!
* no hardfork_385 - n/a because MUSE has minimum name length 3
* some logging + exceptions
* db_init: issuer_permissions - n/a because MUSE has no initial assets
* Hardfork times
* config:
  - core symbol / addr prefix
  - min_account_name_len 3
  - blockchain_precision 4 digits instead of 5
  - higher dilution rate
  - db_version
  - irreversible_threshold 60% instead of 70%
  - FBA_STEALTH_ASSET
* asset_ops substr(0,3) == "BIT" - n/a because MUSE has no BitAssets
* confidential: no superfluous assert
* no Docker support
