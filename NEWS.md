# tamRgo 0.0.0.9007

# tamRgo 0.0.0.9006

* Add simple draft of unalive logic (towards #23).
* Re-instigated concept of 'dirty'.
* Add warning to `get_stats()` if status bars have reached their maximum negative score.
* Add check_blueprint to utils.

# tamRgo 0.0.0.9005

* Allowed for fourth level, a stage at which a pet can become unalive (towards #23).
* Added common images for level 4 and unalive (towards #23).
* Removed 'dirty' concept for simplificiation.

# tamRgo 0.0.0.9004

* Simplified the output of `get_stats()` and included 'bars' for status values.
* Added graphics for species X, Y and Z for levels 0 (shared), 1, 2 and 3 (#10).

# tamRgo 0.0.0.9003

* Added a list of placeholder 'graphics' as internal data, with methods to call (i.e. `.get_pet_matrix()`) and print them (i.e. `.draw_pet()`), wrapped into the exported function `see_pet()` (towards #10).
* Added simple system for levelling up through `.update_xp()` (towards #9, #24).
* `see_stats()` renamed to `get_stats()`

# tamRgo 0.0.0.9002

* Added `play()`, `feed()` and `clean()` functions for altering the pet's status values.
* Set `Depends` to `R (>= 4.0)`.

# tamRgo 0.0.0.9001

* Shifted focus to a fully local experience (#20).
* Added internal functions to `.create_`, `.write_`, `.read_` and `.update_blueprint()`s.
* Introduced time-dependent blueprint updates (toward #9).
* Added exported functions to `lay_egg()`, `see_stats()` and `release_pet()`.
* Added startup message (#6).
* Updated README and DESCRIPTION.
* Added NEWS file to track changes.

# tamRgo 0.0.0.9000

* Set up package, README, license, sample data, {pkgdown} website, low-level and user-facing functions.
* Developed first attempt at function architecture, which leant heavily on GitHub gists for storing pet blueprints remotely.
