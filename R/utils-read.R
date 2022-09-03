
#' Read A tamRgo Pet's Blueprint
#'
#' @description
#' Read a YAML file from a GitHub Gist that contains a tamRgo 'blueprint'.
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#' tamRgo pet's blueprint.
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
#' @examples \dontrun{read_blueprint("9a0138f474f15ceabf267e704c830625")}
.read_blueprint <- function(pet_id) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop("'pet_id' must be a GitHub gist ID: a string of 32 characters.")
  }

  x <- gh::gh("GET /gists/{gist_id}", gist_id = pet_id)

  y <- x$files$tamRgo.yaml$raw_url

  yaml::read_yaml(y)

}
