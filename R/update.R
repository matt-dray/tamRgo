
#' Update Blueprint Over Time
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects statuses ('happy',
#'     'hungry', 'dirty') and experience ('XP', 'level').
#'
#' @return A list.
#'
#' @examples \dontrun{.update_blueprint()}
#'
#' @noRd
.update_blueprint <- function() {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop(
      "A pet blueprint hasn't been found. Use lay_egg() for a new pet.",
      call. = FALSE
    )
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

  bp <- .update_status(bp, time_diff)

  bp <- .update_xp(bp, time_diff)

  bp$meta$last_interaction <- current_time

  bp <- .update_alive(bp, bp$characteristics$age)

  .write_blueprint(bp, ask = FALSE)

  if (!bp$meta$alive) {
    message(
      "Uhoh, your pet ", bp$characteristics$name, " is unalive!",
      "\n- Review their stats with get_stats()",
      "\n- Get a new pet with lay_egg()"
    )
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
#' @details A sub-function of \code{\link{.update_blueprint}}.
#'
#' @return A list.available
#'
#' @examples \dontrun{.update_status()}
#'
#' @noRd
.update_xp <- function(blueprint, time_difference) {

  .check_blueprint(blueprint)

  # Increment XP
  blueprint$experience$xp <-
    blueprint$experience$xp + (time_difference %/% internal$constants$xp_increment)

  if (blueprint$characteristics$age >= internal$constants$age_freeze) {
    # TODO: if pet has reached age 21 since last interaction, will need to
    # calculate what the XP would have been on that day and then pass into:
    # blueprint$experience$xp_freeze <- frozen_xp
  }

  old_level <- blueprint$experience$xp

  # Check if XP meets threshold to level up
  #
  if (blueprint$experience$xp >= internal$constants$xp_threshold_4) {
    blueprint$experience$level <- 4L
  }

  if (blueprint$experience$xp >= internal$constants$xp_threshold_3) {
    blueprint$experience$level <- 3L
  }

  if (blueprint$experience$xp >= internal$constants$xp_threshold_2) {
    blueprint$experience$level <- 2L
  }

  if (blueprint$experience$xp >= internal$constants$xp_threshold_1) {
    blueprint$experience$level <- 1L
  }


  new_level <- blueprint$experience$xp

  if (new_level > old_level) {
    message(
      blueprint$characteristics$name,
      " increased level from ", old_level, " to ", new_level, "!"
    )
  }

  return(blueprint)

}

#' Update Time-Dependent Status Values
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects statuses ('happy',
#'     'hungry').
#'
#' @details A sub-function of \code{\link{.update_blueprint}}.
#'
#' @return A list.available
#'
#' @examples \dontrun{.update_status()}
#'
#' @noRd
.update_status <- function(blueprint, time_difference) {

  .check_blueprint(blueprint)

  blueprint$status$happy <-
    max(blueprint$status$happy - (time_difference %/% internal$constants$happy_decrement), 0L)

  blueprint$status$hungry <-
    min(blueprint$status$hungry + (time_difference %/% internal$constants$hungry_increment), 5L)

  blueprint$status$dirty <-
    min(blueprint$status$dirty + (time_difference %/% internal$constants$dirty_increment), 5L)

  return(blueprint)

}

.update_alive <- function(blueprint, age) {

  .check_blueprint(blueprint)

  if (!inherits(age, "integer")) {
    stop("Argument 'age' must be of class integer.", call. = FALSE)
  }


  if (age > 21L) {

    # TODO: need to record XP at age 21
    unalive_chance <- 100 / blueprint$experience$xp

    is_alive <- sample(
      c(FALSE, TRUE),
      size = 1,
      prob = c(unalive_chance, 1 - unalive_chance)
    )

    blueprint$characteristics$alive <- is_alive

    if (!is_alive) {
      blueprint$experience$level <- 5L
    }

  }

  return(blueprint)

}
