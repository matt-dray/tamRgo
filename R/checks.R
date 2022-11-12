
.check_and_update <- function() {

  invisible(.check_blueprint_exists())

  bp <- .read_blueprint()

  if (bp$meta$alive) {  # don't update it if unalive
    bp <- suppressMessages(.update_blueprint())
  }

  return(bp)

}

.check_blueprint_exists <- function(return = TRUE) {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop(
      "A pet blueprint hasn't been found. Use lay_egg() for a new pet.",
      call. = FALSE
    )
  }

  list(
    data_dir = data_dir,
    data_file = data_file,
    has_data_file = has_data_file
  )

}

.check_blueprint <-  function(blueprint) {

  if (!is.list(blueprint) |
      length(blueprint) != 4 |
      all(lengths(blueprint) != c(3L, 4L, 3L, 3L))
  ) {
    stop("Argument 'blueprint' must be a list of lists", call. = FALSE)
  }

}
