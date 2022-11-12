
.update_blueprint <- function() {

  invisible(.check_blueprint_exists())
  bp <- .read_blueprint()

  # Record current values
  last_level <- bp$experience$level
  last_age <- bp$characteristics$age
  current_date <- Sys.Date()
  current_time <- Sys.time()
  time_diff <- as.integer(  # time elapsed since last interaction
    as.numeric(
      current_time - bp$meta$last_interaction,
      units = "mins"
    )
  )

  # Update blueprint elements
  bp <- .update_age(bp, current_date)
  bp <- .update_xp_freeze(bp, last_age, age_updated = bp$characteristics$age)
  bp <- .update_status(bp, time_diff)
  bp <- .update_xp(bp, time_diff)
  bp <- .update_alive(bp, age_updated = bp$characteristics$age)
  bp$meta$last_interaction <- current_time

  .write_blueprint(bp, ask = FALSE)

  if (bp$experience$level > last_level) {
    message(
      "Great! ", bp$characteristics$name, " has reached level ", bp$experience$level, "!",
      "\n- See how they look now with see_pet()",
      "\n- Review their stats with get_stats()"
    )
  }

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

  if (internal$constants$age_freeze %in% age_last:age_updated) {  # if age freeze met since last interaction

    if (is.na(blueprint$experience$xp_freeze)) {   # if the xp value has not yet been stored already

      # Calculate passive XP between last interaction and age freeze
      days_last_to_freeze <- internal$constants$age_freeze - age_last
      xp_per_hour <- 60 / internal$constants$xp_increment
      xp_to_freeze <- xp_per_hour * (days_last_to_freeze * 24)

      xp_freeze_value <- blueprint$experience$xp + xp_to_freeze

      blueprint$experience$xp_freeze <- xp_freeze_value

    }

  }

  return(blueprint)

}

.update_status <- function(blueprint, time_difference) {

  .check_blueprint(blueprint)

  # Calculate status value change given time
  happy_integral  <- time_difference %/% internal$constants$happy_decrement
  hungry_integral <- time_difference %/% internal$constants$hungry_increment
  dirty_integral  <- time_difference %/% internal$constants$dirty_increment

  # Ensure status scale bounds are not exceeded
  blueprint$status$happy  <- max(0L, blueprint$status$happy  - happy_integral)
  blueprint$status$hungry <- min(5L, blueprint$status$hungry + hungry_integral)
  blueprint$status$dirty  <- min(5L, blueprint$status$dirty  + dirty_integral)

  return(blueprint)

}

.update_alive <- function(blueprint, age_updated) {

  .check_blueprint(blueprint)

  if (!inherits(age_updated, "integer")) {
    stop("Argument 'age_updated' must be of class integer.", call. = FALSE)
  }

  if (!is.na(blueprint$experience$xp_freeze)) {  # if XP has been frozen

    last_interaction_date <- as.Date(
      format(blueprint$meta$last_interaction, "%Y-%m-%d")
    )

    if (Sys.Date() > last_interaction_date) {  # check only once per day

      days_since_interaction <- max(1, as.numeric(Sys.Date() - last_interaction_date))
      days_since_freeze <- max(1, age_updated - internal$constants$age_freeze)

      # Sequence of days since last interaction, expressed as days since XP freeze
      # (e.g. if 3 days since interaction, but 7 since freeze, then 4:7)
      days_to_sample <- seq(
        max(1, days_since_freeze - days_since_interaction),
        days_since_freeze
      )

      unalive_chance_base <- 100 / blueprint$experience$xp_freeze

      if (length(days_to_sample) > 0) {  # if there are days to sample for

        # sample for each post-freeze day that's elapsed since last interaction
        for (day in days_to_sample) {

          # Base chance multiplied by days since freeze
          unalive_chance <- min(0.999, unalive_chance_base * day)
          alive_chance   <- 1 - unalive_chance

          is_alive <- sample(
            c(FALSE, TRUE),
            size = 1,
            prob = c(unalive_chance, alive_chance)
          )

          blueprint$meta$alive <- is_alive

          if (!is_alive) {
            blueprint$characteristics$age <- blueprint$characteristics$age + day
            break
          }

        }

      }

    }

  }

  return(blueprint)

}
