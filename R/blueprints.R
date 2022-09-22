
#' Create a Blueprint
#'
#' @description Generate a blueprint for a new pet. Includes date-dependent and
#'    randomised elements.
#'
#' @param pet_name Character. A name for the new tamRgo pet. Maximum eight
#'     characters.
#'
#' @details The full blueprint contains the following values.
#'
#' Section 'meta':
#' \describe{
#'   \item{pet_id}{Unique (probably) identification number.}
#'   \item{last_interaction}{Datetime that user last interacted with their pet.}
#' }
#'
#' Section 'characteristics':
#' \describe{
#'   \item{name}{Pet's user-provided name.}
#'   \item{species}{Randomly-selected pet species.}
#'   \item{born}{Date that the pet was created.}
#'   \item{age}{Days since born.}
#' }
#'
#' Section 'experience':
#' \describe{
#'   \item{xp}{Experience points.}
#'   \item{level}{Growth stage.}
#' }
#'
#' Section 'status':
#' \describe{
#'   \item{happy}{Happiness on a scale of 0 to 5.}
#'   \item{hungry}{Hunger on a scale of 0 to 5.}
#'   \item{dirty}{Dirtiness on a scale of 0 to 5.}
#' }
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
      level = 0L
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
#' @details A sub-function of \code{\link{.create_blueprint}}.
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
#' @description Save a newly-created pet blueprint to the package's directory
#'     for user-specific data. The package will seek the blueprint from this
#'     location, but its relatively hidden from the user.
#'
#' @param blueprint List. A pet's blueprint created via \code{\link{lay_egg}}.
#' @param ask Logical. Should the user be asked about creating or updating the
#'     existing blueprint file? Defaults to TRUE. Used internally with FALSE to
#'     ignore interactivity.
#'
#' @return Nothing.
#'
#' @examples
#' \dontrun{
#' bp <- .create_blueprint("KEVIN")
#' .write_blueprint(bp, ask = FALSE)
#' }
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
#' @examples \dontrun{.read_blueprint()}
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

#' Update Time-Dependent Blueprint Values
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects statuses ('happy',
#'     'hungry', 'dirty') and experience values ('XP', 'level').
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
#' @return A list.
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

  bp <- .update_status(bp, time_diff)
  bp <- .update_xp(bp, time_diff)

  .write_blueprint(bp, ask = FALSE)

  return(bp)

}

#' Update Time-Dependent Status Values
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects statuses ('happy',
#'     'hungry', 'dirty').
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

#' Update Time-Dependent Experience Values
#'
#' @description Update time-dependent blueprint values given how much time has
#'     elapsed since the last recorded interaction. Affects  experience values
#'     ('XP', 'level').
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

  bp$experience$xp <- bp$experience$xp + (time_difference %/% xp_increment)

  if (blueprint$experience$xp >= xp_threshold_1) {
    blueprint$experience$level <- 1L
  } else if (blueprint$experience$xp >= xp_threshold_2) {
    blueprint$experience$level <- 2L
  } else if (blueprint$experience$xp >= xp_threshold_3) {
    blueprint$experience$level <- 3L
  }

  return(blueprint)

}
