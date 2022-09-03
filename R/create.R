
#' Generate A Blueprint For A New tamRgo Pet
#'
#' @param pet_name Character. A name for hte new tamRgo pet.
#' @param seed Integer or NULL. Supply a seed value to recreate a given tamRgo
#' pet's sampled values. Defaults to NULL.
#'
#' @details
#' A tamRgo 'blueprint' is a list of lists. The sublist 'characteristics'
#' contains:
#' \describe{
#'   \item{species}{Placeholder}
#'   \item{stage}{Placeholder}
#'   \item{born}{Placeholder}
#'   \item{age}{Placeholder}
#' }
#' The sublist 'status' contains
#' \describe{
#'   \item{hunger}{Placeholder}
#'   \item{happy}{Placeholder}
#'   \item{clean}{Placeholder}
#' }
#'
#' @return A list of lists. See details.
#'
#' @export
#'
#' @examples \dontrun{create_blueprint("Kevin", 1234)}
create_blueprint <- function(pet_name, seed = NULL) {

  rolled <- roll_characteristics(seed)

  list(
    characteristics = list(
      name = pet_name,
      species = rolled$sp,
      stage = 1L,
      born = as.character(Sys.Date()),
      age = 0L
    ),
    status = list(
      hunger = 5L,
      happy = 0L,
      clean = 0L
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
roll_characteristics <- function(seed = NULL) {

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
