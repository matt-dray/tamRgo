#' Check-and-Update Routine
#'
#' @description Check that a pet blueprint (RDS) exists in the package's
#'     user-data directory , read it and update it given the time elapsed since
#'     the last interaction .This function is responsible for the illusion of
#'     the pet existing in 'real-time'.
#'
#' @return A list.
#'
#' @export
#'
#' @examples \dontrun{.check_and_update()}
#'
#' @noRd
.check_and_update <- function() {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("A pet blueprint hasn't been found.", call. = FALSE)
  }

  bp <- .read_blueprint()

  if (bp$meta$alive) {  # don't update it if unalive
    bp <- suppressMessages(.update_blueprint())
  }

  return(bp)

}

.check_blueprint <-  function(blueprint) {

  if (!is.list(blueprint) |
      length(blueprint) != 4 |
      all(lengths(blueprint) != c(3L, 4L, 2L, 3L))
  ) {
    stop("Argument 'blueprint' must be a list of lists", call. = FALSE)
  }

}
