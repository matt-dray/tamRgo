#' Return a Pet's Image as a Matrix
#'
#' @param species Character. The species of the pet to be drawn.
#'
#' @return A matrix.
#'
#' @examples \dontrun{ .get_pet_matrix("X")}
#'
#' @noRd
.get_pet_matrix <- function(species = c("X", "Y", "Z")) {

  species <- match.arg(species)

  if (species == "X") {
    return(species_images[["X"]])
  }

  if (species == "Y") {
    return(species_images[["Y"]])
  }

  if (species == "Z") {
    return(species_images[["Z"]])
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
