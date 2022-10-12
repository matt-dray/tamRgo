#' Return a Pet's Image as a Matrix
#'
#' @param species Character. The species of the pet to be drawn.
#'
#' @return A matrix.
#'
#' @examples \dontrun{ .get_pet_matrix("X")}
#'
#' @noRd
.get_pet_matrix <- function(species = c("X", "Y", "Z"), level = 0L:5L) {

  species <- match.arg(species)

  if (level < 0L | level > 5L) {
    stop(
      "Argument 'level' can only be an integer between 0 and 5.",
      call. = FALSE
    )
  }

  if (level == 0L) {
    return(species_images$XYZ$level_0)
  } else if (level == 4L) {
    return(species_images$XYZ$level_4)
  } else if (level == 5L) {
    return(species_images$XYZ$unalive)
  }

  if (species == "X") {
    if (level == 1L) {
      return(species_images$X$level_1)
    } else if (level == 2L) {
      return(species_images$X$level_2)
    } else if (level == 3L) {
      return(species_images$X$level_3)
    }
  }

  if (species == "Y") {
    if (level == 1L) {
      return(species_images$Y$level_1)
    } else if (level == 2L) {
      return(species_images$Y$level_2)
    } else if (level == 3L) {
      return(species_images$Y$level_3)
    }
  }

  if (species == "Z") {
    if (level == 1L) {
      return(species_images$Z$level_1)
    } else if (level == 2L) {
      return(species_images$Z$level_2)
    } else if (level == 3L) {
      return(species_images$Z$level_3)
    }
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
