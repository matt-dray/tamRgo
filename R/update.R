
#' Update Blueprint Over Time
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects statuses ('happy',
#'     'hungry', 'dirty') and experience ('XP', 'level').
#'
#' @param happy_increment Integer. How many minutes must elapse before the
#'     'happy' status value decreases by 1?
#' @param hungry_increment Integer. How many minutes must elapse before the
#'     'hungry' status value decreases by 1?
#' @param dirty_increment Integer. How many minutes must elapse before the
#'     'dirty' status value decreases by 1?
#' @param xp_increment Integer. How many minutes must elapse before the pet
#'     gains 1 XP (experience point)?
#' @param xp_threshold_1 Integer. Minimum experience points (XP) required to
#'     reach level 1.
#' @param xp_threshold_2 Integer. Minimum experience points (XP) required to
#'     reach level 2.
#' @param xp_threshold_3 Integer. Minimum experience points (XP) required to
#'     reach level 3.
#'
#' @return A list.available
#'
#' @examples \dontrun{.update_blueprint()}
#'
#' @noRd
.update_blueprint <- function(
    happy_increment  = 10L,
    hungry_increment = 15L,
    dirty_increment  = 30L,
    xp_increment     = 5L,
    xp_threshold_1   = 100L,
    xp_threshold_2   = 250L,
    xp_threshold_3   = 500L
) {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("A pet blueprint hasn't been found.")
  }

  bp <- .read_blueprint()

  current_interaction <- Sys.time()
  bp$meta$last_interaction <- current_interaction

  time_diff <-
    as.numeric(current_interaction - bp$meta$last_interaction, units = "mins")

  bp$characteristics$age <-
    as.numeric(Sys.Date() - as.Date(bp$characteristics$born), units = "days")

  bp <- .update_status(
    bp, time_diff,
    happy_increment, hungry_increment, dirty_increment
  )

  bp <- .update_xp(
    bp, time_diff,
    xp_increment, xp_threshold_1, xp_threshold_2, xp_threshold_3
  )

  .write_blueprint(bp, ask = FALSE)

  return(bp)

}

.update_status <- function(
    blueprint,
    time_difference,
    happy_increment,
    hungry_increment,
    dirty_increment
) {

  if(
    !is.integer(happy_increment) |
    !is.integer(hungry_increment) |
    !is.integer(dirty_increment)
  ) {
    stop("'*_increment' values must integers.")
  }

  blueprint$status$happy <-
    max(blueprint$status$happy - (time_difference %/% happy_increment), 0L)

  blueprint$status$hungry <-
    min(blueprint$status$hungry + (time_difference %/% hungry_increment), 5L)

  blueprint$status$dirty <-
    min(blueprint$status$dirty + (time_difference %/% dirty_increment), 5L)

  return(blueprint)

}

.update_xp <- function(
    blueprint,
    time_difference,
    xp_increment,
    xp_threshold_1,
    xp_threshold_2,
    xp_threshold_3
) {

  if (!is.list(blueprint) |
      length(blueprint) != 4 |
      all(lengths(blueprint) != c(2L, 4L, 2L, 3L))
  ) {
    stop("'blueprint' must be a list of lists")
  }

  if(
    !is.integer(xp_threshold_1) |
    !is.integer(xp_threshold_2) |
    !is.integer(xp_threshold_3)
  ) {
    stop("'xp_threshold_*' values must be integers.")
  }

  blueprint$experience$xp <-
    blueprint$experience$xp + (time_difference %/% xp_increment)

  if (blueprint$experience$xp >= xp_threshold_1) {
    blueprint$experience$level <- 1L
  } else if (blueprint$experience$xp >= xp_threshold_2) {
    blueprint$experience$level <- 2L
  } else if (blueprint$experience$xp >= xp_threshold_3) {
    blueprint$experience$level <- 3L
  }

  return(blueprint)

}
