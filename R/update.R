
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
  bp <- .update_alive(bp, age_updated = bp$characteristics$age)

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

# Store in the blueprint the XP value at a pre-chosen 'age freeze' (21). The XP gained
# to this point will be used to calculate the chance of reaching the unalive state in the
# .update_alive function. Will only run if the age freeze date is today or was recahed
# between the age at last interaction and today's age.
.update_xp_freeze <- function(blueprint, age_last, age_updated) {

  if (internal$constants$age_freeze %in% c(age_last:age_updated)) {  # if age freeze met since last interaction

    if (!is.na(blueprint$experience$xp_freeze)) {   # if the xp value has not yet been stored already

      # Calculate how many passive XP woul dhave been accumulated between last interaction and age freeze
      days_last_to_freeze <- internal$constants$age_freeze - age_last  # days between last interaction and the age freeze
      xp_per_hour <- 60 / internal$constants$xp_increment  # pass ive XP per hour
      xp_to_freeze <- xp_per_hour * (days_last_to_freeze * 24)  # XP per hour, times days between last interaction and age freeze

      xp_freeze_value <- blueprint$experience$xp_freeze + xp_to_freeze  # XP at last interaction plus XP to age freeze from last interaction

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

# Pet won't have a chance to reach the unalive state until the age for the XP freeze.
# At 21 days, the XP value is stored in the blueprint. For each day after the age freeze,
# the chance of the unalive state is calculated as 100 / frozen XP, multiplied by how many days
# since the freeze. So if the XP was 920 and it's three days later, then 100 / 920 = ~11%,
# multiplied by 3 is ~33%. If the frozen XP had been 1203, then the chance is ~25% on the third day.
# A frozen XP of 1024 results in approximately 10, 20, 31, 41, 51% for days 1 to 5 after
# the age freeze.
.update_alive <- function(blueprint, age_updated) {

  .check_blueprint(blueprint)

  if (!inherits(age_updated, "integer")) {
    stop("Argument 'age_updated' must be of class integer.", call. = FALSE)
  }

  if (!is.na(blueprint$experience$xp_freeze)) {

    # Calculate base chance of survival
    unalive_chance <- 100 / blueprint$experience$xp_freeze  # chance of sampling FALSE

    days_since_freeze <-  # number of days to sample for
      blueprint$characteristics$age_updated - internal$constants$age_freeze

    if (days_since_freeze > 0) {  # if the XP freeze has occurred

      for (day in seq(days_since_freeze)) {  # for each day since the freeze

        # Calculate day's chance of survival
        unalive_chance_day <- min(0.999, unalive_chance * day)  # chance of unalive state increases with time
        alive_chance_day <- 1 - unalive_chance_day  # chance of alive is inverse

        is_alive <- sample(
          c(FALSE, TRUE),
          size = 1,
          prob = c(unalive_chance_day, alive_chance_day)
        )

        blueprint$characteristics$alive <- is_alive

        if (!is_alive) {
          blueprint$experience$level <- 5L  # set level to unalive stage
          break  # no need to calculate chance for further days if is_alive is FALSE already
        }

      }

    }

  }

  return(blueprint)

}
