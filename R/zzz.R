.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    paste0(
      "Welcome to {tamRgo}, a digital pet in the R console!",
      "\n - Docs at <https://matt-dray.github.io/tamRgo>",
      "\n - Create a new pet: lay_egg()",
      "\n - Get pet stats: see_stats()",
      "\n - Interact: play(), feed(), clean()",
      "\n - Say goodbye: release_pet()",
      "\n - Your pet continues to exist after your session ends"
    )
  )
}
