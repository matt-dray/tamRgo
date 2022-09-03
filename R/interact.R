
#' Generate A New tamRgo Pet
#'
#' @description
#' Create a new tamRgo pet blueprint and write it to a new gist
#'
#' @param pet_name Character. A name for the new tamRgo pet.
#' @param overwrite_renviron Logical.
#'
#' @return Nothing. A new GitHub gist is created and a message printed ot the
#'     console.
#'
#' @export
#'
#' @examples \dontrun{lay_egg("Kevin")}
lay_egg <- function(pet_name, overwrite_renviron = TRUE) {

  bp <- .create_blueprint(pet_name)
  gist_info <- .post_blueprint(bp)
  pet_id <- basename(gist_info$url)

  gist_url <- paste0(
    "https://gist.github.com/", gist_info$owner$login, "/", pet_id
  )

  clipr::write_clip(gist_url)

  message("You have a new egg!.")

  if (overwrite_renviron) {
    suppressMessages(.write_renviron(pet_id, overwrite = TRUE))
    message("- pet_id (written to Renviron): ", pet_id)
  }

  if (!overwrite_renviron) {
    message("- pet_id (not written to Renviron): ", pet_id)
  }

  message("- blueprint (copied to clipboard): ", gist_url)

}
