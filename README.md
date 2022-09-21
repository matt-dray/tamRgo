
# {tamRgo}

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/tamRgo/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/tamRgo/actions)
[![Codecov test coverage](https://codecov.io/gh/matt-dray/tamRgo/branch/main/graph/badge.svg)](https://app.codecov.io/gh/matt-dray/tamRgo?branch=main)
<!-- badges: end -->

_Tamago_ (egg) + _uotchi_ ('watch') = [Tamagotchi](https://en.wikipedia.org/wiki/Tamagotchi). _Tamago_ + R = [{tamRgo}](https://github.com/matt-dray/tamRgo).

A work-in-progress R package that lets you interact in the R console with a little digital pet that lives on your computer.

## Install

Install {tamRgo} [from GitHub](https://www.github.com/matt-dray/tamRgo).

``` r
install.packages("remotes")  # if not yet installed
remotes::install_github("matt-dray/tamRgo")
```

The package is currently dependency free, but you need R version 4 or higher.

Instructions will appear when you load the package.

``` r
library(tamRgo)
# Welcome to {tamRgo}, a digital pet in the R console!
#   - Docs at <https://matt-dray.github.io/tamRgo>
#   - Create a new pet: lay_egg()
#   - Get pet stats: see_stats()
#   - Interact: play(), feed(), clean()
#   - Say goodbye: release_pet()
#   - Your pet continues to exist after your session ends
```

## Play

Much of the package's functionality is yet to be developed. You can expect the code below to change a great deal. See [the GitHub issues](https://github.com/matt-dray/tamRgo/issues) for upcoming functionality. 

You must first request for an egg to be laid. This stores a persistent blueprint of your pet to your computer for safekeeping.

``` r
lay_egg("KEVIN")
# Save pet blueprint? y/n: y
# Saved pet blueprint.
# You have a new egg... it hatched!
# See its stats with see_stats()
```

At any time you can see the latest statistics about your pet. These values will update over time. For example, the longer you wait to interact with your pet, the higher the 'hunger' status value will get.

``` r
see_stats()
# Characteristics
#   - Name:    KEVIN
#   - Species: Z
#   - Born:    2022-09-20
#   - Age:     0
# Experience
#   - Level:   1
#   - XP:      0
# Status
#   - Happy:   0/5
#   - Hungry:  0/5
#   - Dirty:   0/5
```

You can view in the console an image (currently a placeholder) of your pet at any time. Their appearance will depend on their species.

```
see_pet()
# ░░░░
# ░░░░
# ░░██
# ░░██
```

You can `play()`, `feed()` or `clean()` to change your pet's status values.

``` r
play()
# 'Happy' status value is now 1/5
```

You can release your pet if you feel the time is right. This will delete its blueprint from your computer.

``` r
release_pet()
# Really release KEVIN? y/n: y
# Are you sure? y/n: y
# KEVIN was set free!
```

## Advanced

The package's main mechanism is the persistent storage of a 'blueprint'&mdash;an RDS file containing a list of pet-related values&mdash;which is saved to the path resolved by `tools::R_user_dir("tamRgo", which = "data")`. The values in the blueprint are updated when a player interacts with the pet, given the time that's elapsed since the last interaction. This gives the appearance that the pet lives 'in real time'.
