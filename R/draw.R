#' Return a Pet's Image as a Matrix
#'
#' @param species Character. The species of the pet to be drawn.
#' @param size Integer. The number of rows and oclumns in the matrix.
#'
#' @return A matrix.
#'
#' @examples \dontrun{mat <- .get_pet_matrix("X")}
#'
#' @noRd
.get_pet_matrix <- function(species = c("X", "Y", "Z"), size = 16L) {

  species <- match.arg(species)

  if (species == "X") {

    matrix(
      c(
        rep(c(rep("\U2588", 2), rep("\U2591", 2)), 2),
        rep(rep("\U2591", 4), 2)
      ),
      sqrt(size),
      byrow = TRUE
    )

  }

  if (species == "Y") {

    matrix(
      c(
        rep("\U2591", 4),
        rep(c("\U2591", rep("\U2588", 2), "\U2591"), 2),
        rep("\U2591", 4)
      ),
      sqrt(size),
      byrow = TRUE
    )

  }

  if (species == "Z") {

    matrix(
      c(
        rep(rep("\U2591", 4), 2),
        rep(c(rep("\U2591", 2), rep("\U2588", 2)), 2)
      ),
      sqrt(size),
      byrow = TRUE
    )

  }

}

#' Print Pet Image to Console
#'
#' @description Draw a matrix representaiton of a pet's image to the console
#'     row-by-row.
#'
#' @param pet_matrix Matrix.
#'
#' @return Nothing.
#'
#' @examples \dontrun{
#'     mat <- .get_pet_matrix("X")
#'     .draw_pet(mat)
#'     }
#'
#' @noRd
.draw_pet <- function(pet_matrix) {

  for (i in seq(nrow(pet_matrix))) {
    row <- paste(pet_matrix[i, ], collapse = "")
    message(row)
  }

}
