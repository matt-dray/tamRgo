
#' Create A tamRgo Pet's Blueprint
#'
#' @description
#' Write a new tamRgo pet's 'blueprint' (a list of characteristics and status
#' values) to a new GitHub gist.
#'
#' @param tamRgo_blueprint A list of lists. Contains characteristics and status
#' values for a given tamRgo pet. See details.
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
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{post_blueprint(blueprint)}
post_blueprint <- function(tamRgo_blueprint) {

  if (!inherits(tamRgo_blueprint, "list") |
      length(tamRgo_blueprint != 2) |
      names(!tamRgo_blueprint %in% c("characteristics", "status")) |
      !names(x[["characteristics"]]) %in% c("name", "species", "stage", "born", "age") |
      !names(x[["status"]]) %in% c("hunger", "happy", "clean")
  ) {
    stop(
      "'tamRgo_blueprint' must be a list of length 2."
    )
  }

  # TODO: post a blueprint to a gist.

}

#' Update A tamRgo Pet's Blueprint From An Interactive Session.
#'
#' @description
#' Update an existing tamRgo pet's 'blueprint' (its list of characteristics and
#' status values) in an existing GitHub gist.
#'
#' @param tamRgo_id Character. A GitHub gist ID for a gist that contains a given
#' tamRgo pet's blueprint.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{update_blueprint("9a0138f474f15ceabf267e704c830625")}
update_blueprint <- function(tamRgo_id) {

  if (!is.character(tamRgo_id) | nchar(tamRgo_id) != 32L) {
    stop("'tamRgo_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  # TODO: overwrite an existing gist.

}

#' Read A tamRgo Pet's Blueprint From A GitHub Gist
#'
#' @description
#' Read a YAML file from a GitHub Gist that contains a tamRgo 'blueprint'.
#'
#' @param tamRgo_id Character. A GitHub gist ID for a gist that contains a given
#' tamRgo pet's blueprint.
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
#' @return A list. See details.
#'
#' @export
#'
#' @examples \dontrun{read_blueprint("9a0138f474f15ceabf267e704c830625")}
read_blueprint <- function(tamRgo_id) {

  if (!is.character(tamRgo_id) | nchar(tamRgo_id) != 32L) {
    stop("'tamRgo_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  x <- gh::gh("GET /gists/{gist_id}", gist_id = tamRgo_id)

  y <- x$files$tamRgo.yaml$raw_url

  yaml::read_yaml(y)

}
