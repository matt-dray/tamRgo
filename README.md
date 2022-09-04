
# {tamRgo}

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
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

Create a new pet (i.e. a YAML 'blueprint' written to a GitHub gist) and care for it (which adjusts the blueprint's status values).

Generate a new pet with `lay_egg()`, which:

* creates a 'blueprint' (i.e. a YAML file) of characteristics (user-provided 'name', randomised 'species', 'stage' of life, 'born' date, 'age' in days) and statuses ('hungry', 'happy', 'dirty', all on a scale of 1 to 5)
* writes the blueprint to a fresh GitHub gist
* sets the Renviron value `TAMRGO_PET_ID` to the pet's ID value (i.e. the GitHub gist's ID), which can be read automatically by the package's functions so that the user doesn't need to provide the pet ID each time

You can also `relase_pet()`, which deletes the GitHub gist that contains the pet's blueprint YAML file and removes the `TAMRGO_PET_ID` from your Renviron.

</details>
