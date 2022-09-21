
#' Create a Blueprint
#'
#' @param pet_name Character. A name for the new tamRgo pet. Maximum eight
#'     characters.
#'
#' @return A list.
#'
#' @examples \dontrun{.create_blueprint(name = "Kevin")}
#'
#' @noRd
.create_blueprint <- function(pet_name) {

  if (!is.character(pet_name) | nchar(pet_name) > 8) {
    stop("'pet_name' must be a string with 8 characters or fewer.")
  }

  rolled <- .roll_characteristics()
  datetime <- Sys.time()

  list(
    meta = list(
      pet_id = rolled$pet_id,
      last_interaction = datetime
    ),
    characteristics = list(
      name = pet_name,
      species = rolled$species,
      born = format(datetime, "%Y-%m-%d"),
      age = 0L
    ),
    experience = list(
      xp = 0L,
      level = 1L
    ),
    status = list(
      happy = 0L,
      hungry = 0L,
      dirty = 0L
    )
  )

}

#' Sample Characteristics for a New Pet
#'
#' @return A list.
#'
#' @examples \dontrun{.roll_characteristics()}
#'
#' @noRd
.roll_characteristics <- function() {

  pet_id_chars <- c(letters, LETTERS, 0:9)
  pet_id <- paste(sample(pet_id_chars, 16, replace = TRUE), collapse = "")

  species_list <- c("X", "Y", "Z")
  species <- sample(species_list, 1)

  list(
    pet_id = pet_id,
    species = species
  )

}

#' Write a Local Blueprint
#'
#' @param blueprint List. A pet's blueprint.
#' @param ask Logical. Should the user be asked about creating or updating the
#'     existing blueprint file? Defaults to TRUE.
#'
#' @return Nothing.
#'
#' @examples \dontrun{
#'     bp <- .create_blueprint("KEVIN")
#'     .write_blueprint(bp, ask = FALSE)
#'     }
#'
#' @noRd
.write_blueprint <- function(blueprint, ask = TRUE) {

  if (!is.list(blueprint) |
      length(blueprint) != 4 |
      all(lengths(blueprint) != c(2L, 4L, 2L, 3L))
  ) {
    stop("'blueprint' must be a list of lists")
  }

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  has_data_dir <- file.exists(data_dir)

  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!ask) {

    if (!has_data_dir) {
      dir.create(data_dir, recursive = TRUE)
    }

    saveRDS(blueprint, file.path(data_file))

    message("Saved pet blueprint.")

  }

  if (ask & !has_data_file) {

    answer <- readline("Save pet blueprint? y/n: ")

    if (substr(tolower(answer), 1, 1) == "y") {

      if (!has_data_dir) {
        dir.create(data_dir, recursive = TRUE)
      }

      saveRDS(blueprint, file.path(data_file))

      message("Saved pet blueprint.")

    } else {

      stop("Did not write pet's blueprint.")

    }

  }

  if (ask & has_data_file) {

    answer <- readline("Overwrite existing pet's blueprint? y/n: ")

    if (substr(tolower(answer), 1, 1) == "y") {

      if (!has_data_dir) {
        dir.create(data_dir, recursive = TRUE)
      }

      saveRDS(blueprint, file.path(data_file))

      message("Saved pet blueprint.")

    } else {

      stop("Did not overwrite existing pet blueprint.")

    }

  }

}

#' Read a Local Blueprint
#'
#' @return Nothing.
#'
#' @examples \dontrun{.create_blueprint(name = "Kevin")}
#'
#' @noRd
.read_blueprint <- function() {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("There is no blueprint to read.")
  }

  if (has_data_file) {
    readRDS(data_file)
  }

}

#' Update Blueprint Given Time
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction.
#'
#' @param happy_increment Integer. How many minutes must elapse before the
#'     'happy' status value decreases by 1?
#' @param hungry_increment Integer. How many minutes must elapse before the
#'     'hungry' status value decreases by 1?
#' @param dirty_increment Integer. How many minutes must elapse before the
#'     'dirty' status value decreases by 1?
#' @param xp_increment Integer. How many minutes must elapse before the pet
#'     gains 1 XP (experience point)?
#'
#' @return A list.
#'
#' @examples \dontrun{.update_blueprint()}
#'
#' @noRd
.update_blueprint <- function(
    happy_increment  = 10L,
    hungry_increment = 15L,
    dirty_increment  = 30L,
    xp_increment     = 5L
) {

  if(
    !is.integer(happy_increment) |
    !is.integer(hungry_increment) |
    !is.integer(dirty_increment) |
    !is.integer(xp_increment)
  ) {
    stop("'*_increment' must be an integer value.")
  }

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("A pet blueprint hasn't been found.")
  }

  bp <- .read_blueprint()

  current_interaction <- Sys.time()

  time_difference <-
    as.numeric(current_interaction - bp$meta$last_interaction, units = "mins")

  bp$meta$last_interaction <- current_interaction

  bp$characteristics$age <-
    as.numeric(Sys.Date() - as.Date(bp$characteristics$born), units = "days")

  bp$experience$xp <- bp$experience$xp + (time_difference %/% xp_increment)

  bp$status$happy <-
    max(bp$status$happy - (time_difference %/% happy_increment), 0L)

  bp$status$hungry <-
    min(bp$status$hungry + (time_difference %/% hungry_increment), 5L)

  bp$status$dirty <-
    min(bp$status$dirty + (time_difference %/% dirty_increment), 5L)

  .write_blueprint(bp, ask = FALSE)

  return(bp)

}
