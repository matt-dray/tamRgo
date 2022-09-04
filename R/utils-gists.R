
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
#' @param what Character. The name of the characteristic or status to be updated
#'     in the pet blueprint. See details.
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
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .update_blueprint(pet_id = gist_id)
#' }
.update_blueprint <- function(
    pet_id = Sys.getenv("TAMRGO_PET_ID"),
    what = c(
      "name", "species", "stage", "born", "age",
      "hungry", "happy", "dirty"
    ),
    new_value
) {

  what <- match.arg(what)

  bp <- .read_blueprint(pet_id)

  if (what %in% c("name", "species", "stage", "born", "age")) {
    bp[["characteristics"]][[what]] <- new_value
  }

  if (what %in% c("hungry", "happy", "dirty")) {
    bp[["status"]][[what]] <- new_value
  }

  blueprint_yaml <- paste0(yaml::as.yaml(bp), "\n")

  x <- gh::gh(
    "PATCH /gists/{gist_id}",
    gist_id = pet_id,
    files = list(tamRgo.yaml = list(content = blueprint_yaml))
  )

  message("Blueprint updated: '", what, "' changed to '", new_value, "'")

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

  gist_content <- gh::gh("GET /gists/{gist_id}", gist_id = pet_id)

  gist_url <- gist_content$files$tamRgo.yaml$raw_url

  yaml::read_yaml(gist_url)

}
