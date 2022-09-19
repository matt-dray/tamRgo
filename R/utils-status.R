
#' Change A Blueprint Status Value
#'
#' @description
#' Change the status value of a pet. This may happen over time (i.e. hunger
#' should increase) or as a result of player interaction (e.g. feeding will
#' reduce hunger).
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     that's in the current environment.
#' @param status_type Character. The status that will be updated. One of
#'     'hungry', 'happy' or 'dirty'.
#' @param change Integer. The amount that the status value should change by (can
#'     be positive or negative, but must be between the values of min_value and
#'     max_value)
#' @param min_value Integer. The minimum value that the status value can take.
#' @param max_value Integer. The maximum value that the status value can take.
#'
#' @return Nothing. Messages may be printed to the console and a GitHub gist may
#'     be updated.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .change_status(pet_id = gist_id, status_type = "happy", change = -1L)
#' }
.change_status <- function(
    pet_id = Sys.getenv("TAMRGO_PET_ID"),
    status_type = c("happy", "hungry", "dirty"),
    change = 1L,
    min_value = 0L,
    max_value = 5L
) {

  .check_pet_id(pet_id)
  status_type <- match.arg(status_type)

  if (!is.integer(change)) {
    stop("'change' must be an integer.", call. = FALSE)
  }

  if (min_value < 0 | max_value < 0) {
    stop(
      "'min_value' and 'max_value' must be zero or more.",
      call. = FALSE
    )
  }

  if (min_value > max_value) {
    stop("'min_value' should not be larger than 'max_value'", call. = FALSE)
  }

  bp <- .get_blueprint(pet_id)
  old_value <- bp[["status"]][[status_type]]
  new_value <- old_value + change

  reached_cap <- FALSE

  if (new_value < min_value) {
    new_value <- min_value
    reached_cap <- TRUE
  }

  if (new_value > max_value) {
    new_value <- max_value
    reached_cap <- TRUE
  }

  .patch_blueprint(pet_id, status_type, new_value)

  message(
    "The '", status_type, "' status changed from ",
    old_value, " to ", new_value, "."
  )

  if (reached_cap) {
    message("The new value was capped at 'min_value' or 'max_value'.")
  }

}
