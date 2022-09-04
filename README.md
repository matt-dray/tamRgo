
# {tamRgo}

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/matt-dray/tamRgo/workflows/R-CMD-check/badge.svg)](https://github.com/matt-dray/tamRgo/actions)
[![Codecov test coverage](https://codecov.io/gh/matt-dray/tamRgo/branch/main/graph/badge.svg)](https://app.codecov.io/gh/matt-dray/tamRgo?branch=main)
<!-- badges: end -->

_Tamago_ (egg) + _uotchi_ ('watch') = [Tamagotchi](https://en.wikipedia.org/wiki/Tamagotchi). _Tamago_ + R = {tamRgo}.

A work-in-progress R package to create and care for a digital pet, using GitHub gists to store pet 'blueprints'.

<details><summary>Secret dev notes (don't click)</summary>

## Install

Install from GitHub with:

``` r
remotes::install_github("matt-dray/tamRgo")
```

The package depends on [{gh}](https://gh.r-lib.org/) to interact with the GitHub API (i.e. to GET, POST and DELETE GitHub gists) and [{yaml}](https://github.com/vubiostat/r-yaml/) to read and write YAML files (i.e. the format used for pet blueprints).

## Game loop

You generate a new pet (i.e. a YAML 'blueprint' written to a GitHub gist) and care for it via R functions (which adjusts the blueprint's status values).

You generate a new pet with `lay_egg()`, which:

* creates a 'blueprint' (i.e. a YAML file) of characteristics (user-provided 'name', randomised 'species', 'stage' of life, 'born' date, 'age' in days) and statuses ('hungry', 'happy', 'dirty', all on a scale of 1 to 5)
* writes the blueprint to a fresh GitHub gist
* sets the Renviron value `TAMRGO_PET_ID` to the pet's ID value (i.e. the GitHub gist's ID), which can be read automatically by the package's functions so that the user doesn't need to provide the pet ID each time

You can:

* `see_stats()` to print to the console a summary of the loaded pet's characteristics and status values
* `load_pet()` to set a pet_id (i.e. GitHub gist ID) to an Renviron variable (`TAMRGO_PET_ID`), which makes it simpler to provide this variable to the functions that use it (they read it from the Renviron, rather than the user having to supply it every time)
* `release_pet()` to delete the GitHub gist that contains the pet's blueprint YAML file and removes the `TAMRGO_PET_ID` from your Renviron

There's a bunch of internal `R/utils-*.R` functions (prefixed with a period) that handle blueprint creation, gist handling and setting the Renviron variable.

</details>
