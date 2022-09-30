
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
    stop("Argument 'pet_name' must be a string with 8 characters or fewer.")
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
    stop("Argument 'blueprint' must be a list of lists")
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
