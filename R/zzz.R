.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    paste0(
      "Welcome to {tamRgo}!",
      "\n  - Docs at <https://matt-dray.github.io/tamRgo>",
      "\n  - To create a new pet: lay_egg()",
      "\n  - To get pet stats: see_stats()",
      "\n  - To say goodbye: release_pet()"
    )
  )
}
