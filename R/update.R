
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

  last_age <- bp$characteristics$age

  current_time <- Sys.time()
  current_date <- Sys.Date()

  time_diff <- as.integer(
    as.numeric(
      current_time - bp$meta$last_interaction,
      units = "mins"
    )
  )

  bp <- .update_age(bp, current_date)
  bp <- .update_xp_freeze(bp, last_age, age_updated = bp$characteristics$age)

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

.update_xp <- function(blueprint, time_difference) {

  .check_blueprint(blueprint)

  # Increment passive XP
  passive_xp_gained <- time_difference %/% internal$constants$xp_increment
  blueprint$experience$xp <- blueprint$experience$xp + passive_xp_gained

  old_level <- blueprint$experience$level

  # Check if XP meets threshold to level up

  if (blueprint$experience$xp >= internal$constants$xp_threshold_4) {
    blueprint$experience$level <- 4L
  } else if (blueprint$experience$xp >= internal$constants$xp_threshold_3) {
    blueprint$experience$level <- 3L
  } else if (blueprint$experience$xp >= internal$constants$xp_threshold_2) {
    blueprint$experience$level <- 2L
  } else if (blueprint$experience$xp >= internal$constants$xp_threshold_1) {
    blueprint$experience$level <- 1L
  }

  new_level <- blueprint$experience$level

  if (new_level > old_level) {
    message(
      blueprint$characteristics$name,
      " increased level from ", old_level, " to ", new_level, "!"
    )
  }

  return(blueprint)

}

.update_xp_freeze <- function(blueprint, age_last, age_updated) {

  if (internal$constants$age_freeze %in% c(age_last:age_updated)) {

    if (!is.na(blueprint$experience$xp_freeze)) {

      days_last_to_freeze <- internal$constants$age_freeze - age_last
      xp_per_hour <- 60 / internal$constants$xp_increment
      xp_to_freeze <- xp_per_hour * (days_last_to_freeze * 24)

      xp_freeze_value <- blueprint$experience$xp_freeze + xp_to_freeze

      blueprint$experience$xp_freeze <- xp_freeze_value

    }

  }

  return(blueprint)

}

.update_status <- function(blueprint, time_difference) {

  .check_blueprint(blueprint)

  # Calculate status value change given time
  happy_integral  <- time_difference %/% internal$constants$happy_decrement
  hungry_integral <- time_difference %/% internal$constants$hungry_decrement
  dirty_integral  <- time_difference %/% internal$constants$dirty_decrement

  # Ensure status scale bounds are not exceeded
  blueprint$status$happy  <- max(0L, blueprint$status$happy  - happy_integral)
  blueprint$status$hungry <- min(5L, blueprint$status$hungry + hungry_integral)
  blueprint$status$dirty  <- min(5L, blueprint$status$dirty  + dirty_integral)

  return(blueprint)

}

.update_alive <- function(blueprint, age) {

  .check_blueprint(blueprint)

  if (!inherits(age, "integer")) {
    stop("Argument 'age' must be of class integer.", call. = FALSE)
  }

  if (!is.na(blueprint$experience$xp_freeze)) {

    unalive_chance <- 100 / blueprint$experience$xp_freeze

    days_since_freeze <-
      blueprint$characteristics$age - internal$constants$age_freeze

    if (days_since_freeze > 0) {

      for (day in seq(days_since_freeze)) {

        unalive_chance_day <- unalive_chance * day
        alive_chance_day <- 1 - unalive_chance_day

        is_alive <- sample(
          c(FALSE, TRUE),
          size = 1,
          prob = c(
            unalive_chance_day,
            alive_chance_day
          )
        )

        blueprint$characteristics$alive <- is_alive

        if (!is_alive) {
          blueprint$experience$level <- 5L
          break
        }

      }

    }

  }

  return(blueprint)

}
