
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
#'   \item{species}{Type of pet}
#'   \item{stage}{Growth stage reached}
#'   \item{born}{Date of birth}
#'   \item{age}{Days since birth}
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
      name = pet_name,
      species = rolled$species,
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

#' Create A tamRgo Pet's Blueprint
#'
#' @description
#' Write a new GitHub gist with the name 'tamRgo.yaml' that contains a tamRgo
#' pet's 'blueprint' (its list of characteristics and status values).
#'
#' @param blueprint A list of lists. Contains characteristics and status
#'     values for a given tamRgo pet. See details.
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
#'   \item{happy}{Happiness on a scale of 1 (least) to 5 (most)}
#'   \item{dirty}{Dirtiness on a scale of 1 (least) to 5 (most)}
#' }
#'
#' @return Nothing.
#'
#' @examples
#' \dontrun{
#' bp <- create_blueprint(name = "Kevin", seed = 1234L)
#' .post_blueprint(blueprint = bp)
#' }
.post_blueprint <- function(blueprint) {

  if (
    any(
      !inherits(blueprint, "list"),
      length(blueprint) != 2,
      names(!blueprint %in% c("characteristics", "status")),
      !names(blueprint[["characteristics"]]) %in% c(
        "name", "species", "stage", "born", "age"
      ),
      !names(blueprint[["status"]]) %in% c("hungry", "happy", "dirty")
    )
  ) {
    stop(
      "'blueprint' must be a list of length 2.\n",
      "Run ?post_blueprint for details of its structure."
    )
  }

  gist_desc <- paste(
    "A blueprint for a digital pet, made with the {tamRgo} R package at",
    Sys.time()
  )

  blueprint_yaml <- paste0(yaml::as.yaml(blueprint), "\n")

  gh::gh(
    "POST /gists",
    description = gist_desc,
    files = list(tamRgo.yaml = list(content = blueprint_yaml)),
    public = TRUE
  )

}

#' Delete A tamRgo Pet's Blueprint
#'
#' @description
#' Delete an existing GitHub gist that contains a tamRgo pet's 'blueprint' (its
#' list of characteristics and status values).
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#'     tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value stored
#'     in the user's Renviron.
#'
#' @return Nothing.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .delete_blueprint(pet_id = gist_id)
#' }
.delete_blueprint <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop("'pet_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  gh::gh("DELETE /gists/{gist_id}", gist_id = pet_id)

}

#' Update A tamRgo Pet's Blueprint
#'
#' @description
#' Update an existing GitHub gist that contains a tamRgo pet's 'blueprint' (its
#' list of characteristics and status values).
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#'     tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value stored
#'     in the user's Renviron.
#'
#' @return Nothing.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .update_blueprint(pet_id = gist_id)
#' }
.update_blueprint <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop("'pet_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  # TODO: overwrite an existing gist.

}

#' Read A tamRgo Pet's Blueprint
#'
#' @description
#' Read a YAML file from a GitHub Gist that contains a tamRgo 'blueprint'.
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#'     tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value stored
#'     in the user's Renviron.
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
#'   \item{happy}{Happiness on a scale of 1 (least) to 5 (most)}
#'   \item{dirty}{Dirtiness on a scale of 1 (least) to 5 (most)}
#' }
#'
#' @return A list. See details.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .read_blueprint(pet_id = gist_id)
#' }
.read_blueprint <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (any(!is.character(pet_id), nchar(pet_id) != 32L)) {
    stop("'pet_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  x <- gh::gh("GET /gists/{gist_id}", gist_id = pet_id)

  y <- x$files$tamRgo.yaml$raw_url

  yaml::read_yaml(y)

}
