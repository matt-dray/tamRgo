.check_and_update <- function() {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("A pet blueprint hasn't been found.")
  }

  bp <- .read_blueprint()
  bp <- suppressMessages(.update_blueprint())

  return(bp)

}
