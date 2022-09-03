
#' Create A tamRgo Pet's Blueprint
#'
#' @description
#' Write a new GitHub gist with the name 'tamRgo.yaml' that contains a tamRgo
#' pet's 'blueprint' (its list of characteristics and status values).
#'
#' @param blueprint A list of lists. Contains characteristics and status
#' values for a given tamRgo pet. See details.
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
#' @return Nothing.
#'
#' @examples \dontrun{post_blueprint(blueprint)}
.post_blueprint <- function(blueprint) {

  if (
    any(
      !inherits(blueprint, "list"),
      length(blueprint) != 2,
      names(!blueprint %in% c("characteristics", "status")),
      !names(x[["characteristics"]]) %in% c("name", "species", "stage", "born", "age"),
      !names(x[["status"]]) %in% c("hungry", "happy", "dirty")
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

  blueprint_yaml <- yaml::as.yaml(blueprint)

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
#' tamRgo pet's blueprint.
#'
#' @return Nothing.
#'
#' @examples \dontrun{delete_blueprint("9a0138f474f15ceabf267e704c830625")}
.delete_blueprint <- function(pet_id) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop("'pet_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  # TODO: delete an existing gist.

}

#' Update A tamRgo Pet's Blueprint
#'
#' @description
#' Update an existing GitHub gist that contains a tamRgo pet's 'blueprint' (its
#' list of characteristics and status values).
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#' tamRgo pet's blueprint.
#'
#' @return Nothing.
#'
#' @examples \dontrun{update_blueprint("9a0138f474f15ceabf267e704c830625")}
.update_blueprint <- function(pet_id) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop("'pet_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  # TODO: overwrite an existing gist.

}
