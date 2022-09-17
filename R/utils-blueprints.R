
#' Generate A Blueprint For A New tamRgo Pet
#'
#' @param pet_name Character. A name for the new tamRgo pet.
#' @param seed Integer or NULL. Supply a seed value to recreate a given tamRgo
#'     pet's sampled values. Defaults to NULL.
#'
#' @details
#' A tamRgo 'blueprint' is a list of two lists ('characteristics' and 'status')
#' that stores information about a pet. The sublist 'characteristics' contains:
#' \describe{
#'   \item{pet_id}{Unique pet identification number (GitHub Gist ID number)}
#'   \item{name}{The pet's name}
#'   \item{species}{Type of pet}
#'   \item{born}{Date of birth}
#'   \item{stage}{Growth stage reached}
#'   \item{age}{Days since birth}
#'   \item{xp}{Experience points}
#' }
#' The sublist 'status' contains:
#' \describe{
#'   \item{hungry}{Hunger on a scale of 1 (least) to 5 (most)}
#'   \item{happy}{Happiness on a scale of 1 (least) to 5 (most)}
#'   \item{dirty}{Dirtiness on a scale of 1 (least) to 5 (most)}
#' }
#'
#' @return A list. See details.
#'
#' @examples \dontrun{.create_blueprint(name = "Kevin", seed = 1234L)}
.create_blueprint <- function(pet_name, seed = NULL) {

  if (!inherits(pet_name, "character")) {
    stop("'pet_name' must be a character string.")
  }

  rolled <- .roll_characteristics(seed)

  list(
    characteristics = list(
      pet_id = NULL,
      name = pet_name,
      species = rolled$species,
      born = as.character(Sys.Date()),
      age = 0L,
      stage = 1L,
      xp = 0L
    ),
    status = list(
      hungry = 0L,
      happy = 0L,
      dirty = 0L
    )
  )

}

#' Sample Characteristics For A New tamRgo Pet
#'
#' @param seed Integer or NULL. Supply a seed value to recreate a given tamRgo
#'     pet's sampled values. Defaults to NULL.
#'
#' @return A list.
#'
#' @examples \dontrun{.roll_characteristics(seed = 1234L)}
.roll_characteristics <- function(seed = NULL) {

  if (!is.integer(seed)) {
    if (!is.null(seed)) {
      stop("'seed' must be an integer or NULL.")
    }
  }

  set.seed(seed)

  spp <- c("X", "Y", "Z")
  sp <- sample(spp, 1)

  rolled <- list(species = sp)

  set.seed(NULL)

  return(rolled)

}
