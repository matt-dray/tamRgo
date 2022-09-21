.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    paste0(
      "{tamRgo}: interact with a digital pet in the R console.",
      "\n  - Docs: <https://matt-dray.github.io/tamRgo>",
      "\n  - New pet: lay_egg()",
      "\n  - Pet info: see_stats(), see_pet()",
      "\n  - Interact: play(), feed(), clean()",
      "\n  - Your pet continues to exist after your session ends"
    )
  )
}
