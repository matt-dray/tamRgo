
.change_status <- function(
    pet_id = Sys.getenv("TAMRGO_PET_ID"),
    status_type = c("happy", "hungry", "dirty"),
    change = 1L,
    min_value = 0L,
    max_value = 5L
) {

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
