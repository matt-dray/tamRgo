#' Return a Pet's Image as a Matrix
#'
#' @param species Character. The species of the pet to be drawn.
#'
#' @return A matrix.
#'
#' @examples \dontrun{ .get_pet_matrix("X")}
#'
#' @noRd
.get_pet_matrix <- function(species = c("X", "Y", "Z"), level = 1L:3L) {

  species <- match.arg(species)

  if (level == 0L) {
    return(species_images[["X"]][["level_0"]])
  }

  if (species == "X" & level == 1L) {
    return(species_images[["X"]][["level_1"]])
  } else if (species == "X" & level == 2L) {
    return(species_images[["X"]][["level_2"]])
  } else if (species == "X" & level == 3L) {
    return(species_images[["X"]][["level_3"]])
  }

  if (species == "Y" & level == 1L) {
    return(species_images[["Y"]][["level_1"]])
  } else if (species == "Y" & level == 2L) {
    return(species_images[["Y"]][["level_2"]])
  } else if (species == "Y" & level == 3L) {
    return(species_images[["Y"]][["level_3"]])
  }

  if (species == "Z" & level == 1L) {
    return(species_images[["Z"]][["level_1"]])
  } else if (species == "Z" & level == 2L) {
    return(species_images[["Z"]][["level_2"]])
  } else if (species == "Z" & level == 3L) {
    return(species_images[["Z"]][["level_3"]])
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
