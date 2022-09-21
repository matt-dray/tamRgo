# tamRgo 0.0.0.9003

* Added placeholder 'graphics' and methods to call (i.e. `.get_pet_matrix()`) and print them (i.e. `.draw_pet()`), wrapped into the exported function `see_pet()` (towards #10).

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