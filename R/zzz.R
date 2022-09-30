.onAttach <- function(libname, pkgname) {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {

    packageStartupMessage(
      paste0(
        "Welcome to {tamRgo}, a digital pet in the R console!",
        "\n - Docs: <https://matt-dray.github.io/tamRgo>",
        "\n - New pet: lay_egg()",
        "\n - Then: see_stats(), play(), feed(), clean()"
      )
    )

  }

  if (has_data_file) {

    bp <- readRDS(data_file)

    packageStartupMessage(
      paste0(
        "Your pet, ", bp$characteristics$name, ", is pleased to see you!",
        "\n - Docs: <https://matt-dray.github.io/tamRgo>",
        "\n - You can see_stats(), play(), feed(), clean()"
      )
    )

  }

}
