
#' Write A Pet ID To An Renviron File
#'
#' @description
#' Set the pet ID (i.e. GitHub gist ID) as the 'TAMRGO_PET_ID' value in the
#' user's Renviron file. This prevents a user having to supply the pet_id
#' whenever they interact with their pet.
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#'     tamRgo pet's blueprint.
#' @param overwrite Logical. Should an existing pet ID value in the Renviron be
#'     overwritten by the supplied pet_id?
#'
#' @return Nothing. Updates the user's Renviron file, prints messages to the
#'     console.
#'
#' @examples \dontrun{.write_id_to_renviron("1234567890")}
.write_renviron <- function(pet_id, overwrite = FALSE) {

  renviron_list <- as.list(Sys.getenv())

  id_exists <- "TAMRGO_PET_ID" %in% names(renviron_list)

  if (id_exists) {

    id_matches <- renviron_list$TAMRGO_PET_ID == pet_id

    if (id_matches) {
      stop("You've already set that 'pet_id' value in your Renviron file.")
    }

    if (!overwrite) {
      stop(
        "TAMRGO_PET_ID is already set in your Renviron file. ",
        "Re-run with 'overwrite = TRUE' to overwrite it.",
        call. = FALSE
      )
    }

    if (overwrite) {

      Sys.setenv(TAMRGO_PET_ID = pet_id)

      message(
        "TAMRGO_PET_ID is already set in your Renviron file. ",
        "It's now been overwritten with the provided 'pet_id' value."
      )

    }

  }

  if (!id_exists) {
    Sys.setenv(TAMRGO_PET_ID = pet_id)
    message("TAMRGO_PET_ID has been set with the provided 'pet_id' value.")
  }

}
