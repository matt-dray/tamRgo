
#' Generate A Blueprint For A New tamRgo Pet
#'
#' @param pet_name Character. A name for the new tamRgo pet.
#' @param seed Integer or NULL. Supply a seed value to recreate a given tamRgo
#' pet's sampled values. Defaults to NULL.
#'
#' @details
#' A tamRgo 'blueprint' is a list of two lists ('characteristics' and 'status')
#' that stores information about a pet. The sublist 'characteristics' contains:
#' \describe{
#'   \item{species}{Type of pet}
#'   \item{stage}{Growth stage reached}
#'   \item{born}{Date of birth}
#'   \item{age}{Days since birth}
#' }
#' The sublist 'status' contains:
#' \describe{
#'   \item{hungry}{Hunger on a scale of 1 (least) to 5 (most)}
#'   \item{happy}{Happiness on a scale of 1 (least) to 5 (most)?}
#'   \item{dirty}{Dirtiness on a scale of 1 (least) to 5 (most)?}
#' }
#'
#' @return A list. See details.
#'
#' @export
#'
#' @examples \dontrun{create_blueprint("Kevin", 1234)}
.create_blueprint <- function(pet_name, seed = NULL) {

  if (!inherits(pet_name, "character")) {
    stop("'pet_name' must be a character string.")
  }

  rolled <- .roll_characteristics(seed)

  list(
    characteristics = list(
      name = pet_name,
      species = rolled$sp,
      stage = 1L,
      born = as.character(Sys.Date()),
      age = 0L
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
#' pet's sampled values. Defaults to NULL.
#'
#' @return
#' A list.
#'
#' @export
#'
#' @examples \dontrun{roll_characteristics(1234)}
.roll_characteristics <- function(seed = NULL) {

  if (!is.integer(seed)) {
    if (!is.null(seed)) {
      stop("'seed' must be an integer or NULL.")
    }
  }

  set.seed(seed)

  spp <- c("X", "Y", "Z")
  sp <- sample(spp, 1)

  rolled <- list(sp = sp)

  set.seed(NULL)

  return(rolled)

}
