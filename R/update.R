
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
#' @param xp_threshold_4 Integer. Minimum experience points (XP) required to
#'     reach level 4.
#'
#' @return A list.available
#'
#' @examples \dontrun{.update_blueprint()}
#'
#' @noRd
.update_blueprint <- function(
    happy_increment  = 5L,
    hungry_increment = 10L,
    dirty_increment  = 15L,
    xp_increment     = 5L,
    xp_threshold_1   = 100L,
    xp_threshold_2   = 200L,
    xp_threshold_3   = 500L,
    xp_threshold_4   = 1000L
) {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("A pet blueprint hasn't been found.", call. = FALSE)
  }

  bp <- .read_blueprint()

  current_time <- Sys.time()
  current_date <- Sys.Date()

  time_diff <- as.integer(
    as.numeric(
      current_time - bp$meta$last_interaction,
      units = "mins"
    )
  )

  bp <- .update_age(bp, current_date)

  bp <- .update_status(
    bp,
    time_diff,
    happy_increment,
    hungry_increment,
    dirty_increment
  )

  bp <- .update_xp(
    bp,
    time_diff,
    xp_increment,
    xp_threshold_1,
    xp_threshold_2,
    xp_threshold_3,
    xp_threshold_4
  )

  bp$meta$last_interaction <- current_time

  bp <- .update_alive(bp, bp$characteristics$age)

  .write_blueprint(bp, ask = FALSE)

  if (!bp$characteristics$age) {
    message("Uhoh", bp$characteristics$name, "is unalive.")

  }


  return(bp)

}

.update_age <- function(blueprint, date) {

  .check_blueprint(blueprint)

  if (!inherits(date, "Date")) {
    stop("Argument 'date' must be of class Date.", call. = FALSE)
  }

  blueprint$characteristics$age <- as.integer(
    as.numeric(
      date - as.Date(blueprint$characteristics$born),
      units = "days"
    )
  )

  return(blueprint)

}

#' Update Time-Dependent Experience Values
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects  experience values
#'     ('XP', 'level').
#'
#' @param xp_increment Integer. How many minutes must elapse before the pet
#'     gains 1 XP (experience point)?
#' @param xp_threshold_1 Integer. Minimum experience points (XP) required to
#'     reach level 1.
#' @param xp_threshold_2 Integer. Minimum experience points (XP) required to
#'     reach level 2.
#' @param xp_threshold_3 Integer. Minimum experience points (XP) required to
#'     reach level 3.
#' @param xp_threshold_4 Integer. Minimum experience points (XP) required to
#'     reach level 4.
#'
#' @details A sub-function of \code{\link{.update_blueprint}}.
#'
#' @return A list.available
#'
#' @examples \dontrun{.update_status()}
#'
#' @noRd
.update_xp <- function(
    blueprint,
    time_difference,
    xp_increment,
    xp_threshold_1,
    xp_threshold_2,
    xp_threshold_3,
    xp_threshold_4
) {

  .check_blueprint(blueprint)

  if(!is.integer(
    c(xp_threshold_1, xp_threshold_2, xp_threshold_3, xp_threshold_4))
  ) {
    stop("Arguments 'xp_threshold_*' must be integers.", call. = FALSE)
  }

  # Increment XP
  blueprint$experience$xp <-
    blueprint$experience$xp + (time_difference %/% xp_increment)

  # Check if XP meets threshold to level up
  if (blueprint$experience$xp >= xp_threshold_4) {
    blueprint$experience$level <- 4L
  } else if (blueprint$experience$xp >= xp_threshold_3) {
    blueprint$experience$level <- 3L
  } else if (blueprint$experience$xp >= xp_threshold_2) {
    blueprint$experience$level <- 2L
  } else if (blueprint$experience$xp >= xp_threshold_1) {
    blueprint$experience$level <- 1L
  }

  return(blueprint)

}

#' Update Time-Dependent Status Values
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects statuses ('happy',
#'     'hungry').
#'
#' @param happy_increment Integer. How many minutes must elapse before the
#'     'happy' status value decreases by 1?
#' @param hungry_increment Integer. How many minutes must elapse before the
#'     'hungry' status value decreases by 1?
#' @param dirty_increment Integer. How many minutes must elapse before the
#'     'dirty' status value decreases by 1?
#'
#' @details A sub-function of \code{\link{.update_blueprint}}.
#'
#' @return A list.available
#'
#' @examples \dontrun{.update_status()}
#'
#' @noRd
.update_status <- function(
    blueprint,
    time_difference,
    happy_increment,
    hungry_increment,
    dirty_increment
) {

  .check_blueprint(blueprint)

  if(!is.integer(c(happy_increment, hungry_increment, dirty_increment))) {
    stop("Arguments '*_increment' must be integers.", call. = FALSE)
  }

  blueprint$status$happy <-
    max(blueprint$status$happy - (time_difference %/% happy_increment), 0L)

  blueprint$status$hungry <-
    min(blueprint$status$hungry + (time_difference %/% hungry_increment), 5L)

  blueprint$status$dirty <-
    min(blueprint$status$dirty + (time_difference %/% dirty_increment), 5L)

  return(blueprint)

}

.update_alive <- function(blueprint, age) {

  .check_blueprint(blueprint)

  if (!inherits(age, "integer")) {
    stop("Argument 'age' must be of class integer.", call. = FALSE)
  }

  if (age > 21L) {

    blueprint$characteristics$alive <- FALSE
    blueprint$experience$level <- 5L

  }

  return(blueprint)

}
