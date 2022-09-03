
#' Generate A New tamRgo Pet
#'
#' @description
#' Create a new tamRgo pet blueprint and write it to a new gist
#'
#' @param pet_name Character. A name for the new tamRgo pet.
#'
#' @return Nothing. A new GitHub gist is created and a message printed ot the
#'     console.
#'
#' @export
#'
#' @examples \dontrun{lay_egg("Kevin")}
lay_egg <- function(pet_name) {

  x <- .create_blueprint(pet_name)

  y <- .post_blueprint(x)

  clipr::write_clip(basename(y$url))

  message(
    "You have a new egg!\n",
    "- pet_id: ", basename(y$url), " (written to clipboard)\n",
    "- blueprint: ", y$url
  )

}
