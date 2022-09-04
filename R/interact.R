
#' Generate A New tamRgo Pet Egg
#'
#' @description
#' Create a new tamRgo-pet blueprint, write it to a new gist and set its pet ID
#' (i.e. GitHub gist ID) in your Renviron file as TAMRGO_PET_ID. The new pet is
#' at the egg stage.
#'
#' @param pet_name Character. A name for the new tamRgo pet.
#' @param overwrite_renviron Logical. Overwrite the existing pet ID value
#'     (TAMRGO_PET_ID) in your Renviron file? Defaults to TRUE.
#'
#' @return Nothing. A new GitHub gist is created and a message printed to the
#'     console.
#'
#' @export
#'
#' @examples \dontrun{lay_egg(name = "Kevin")}
lay_egg <- function(pet_name, overwrite_renviron = TRUE) {

  bp        <- .create_blueprint(pet_name)
  gist_info <- .post_blueprint(bp)
  pet_id    <- basename(gist_info$url)

  gist_url <- paste0(
    "https://gist.github.com/", gist_info$owner$login, "/", pet_id
  )

  message("You have a new egg!")

  if (overwrite_renviron) {
    suppressMessages(.set_renviron(pet_id, overwrite = TRUE))
    message("- pet_id (set in Renviron as TAMRGO_PET_ID): ", pet_id)
  }

  if (!overwrite_renviron) {
    message("- pet_id (not set in Renviron): ", pet_id)
  }

  message("- blueprint: ", gist_url)

}

#' See A Stats Summary For A tamRgo Pet
#'
#' @description
#' Print to the console the current characteristics and status of a tamRgo pet.
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#'     tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value stored
#'     in the user's Renviron.
#'
#' @return Nothing. A message is printed to the console.
#'
#' @export
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' see_stats(pet_id = gist_id)
#' }
see_stats <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  bp <- .read_blueprint(pet_id)

  message(
    "Pet characteristics",                     "\n",
    "- Name:    ", bp$characteristics$name,    "\n",
    "- Species: ", bp$characteristics$species, "\n",
    "- Stage:   ", bp$characteristics$stage,   "\n",
    "- Born:    ", bp$characteristics$born,    "\n",
    "- Age:     ", bp$characteristics$age,     "\n",
    "Pet status",                              "\n",
    "- Hungry:  ", bp$status$hungry, "/5",     "\n",
    "- Happy:   ", bp$status$happy,  "/5",     "\n",
    "- Dirty:   ", bp$status$dirty,  "/5"
  )

}

#' Release A tamRgo Pet Forever
#'
#' @description
#' Delete a tamRgo pet's blueprint (YAML file) from its associated GitHub gist.
#' Also unsets the pet ID (TAMRGO_PET_ID) from the Renviron.
#'
#' @param pet_id Character. A GitHub gist ID for a gist that contains a given
#'     tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value stored
#'     in the user's Renviron.
#'
#' @return Nothing. Interactive messages are printed to the console and a GitHub
#'     gist may be deleted.
#'
#' @export
#'
#' @examples \dontrun{release_pet()}
release_pet <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  pet_name <- .read_blueprint(pet_id)[["characteristics"]][["name"]]

  answer_1 <- readline(paste0("Say goodbye to ", pet_name, "? y/n: "))

  if (substr(tolower(answer_1), 1, 1) == "y") {

    answer_2 <- readline("Really delete your tamRgo pet's blueprint? y/n: ")

  } else {

    stop("Deletion process stopped.")

  }

  if (substr(tolower(answer_2), 1, 1) == "y") {

    .delete_blueprint(pet_id)
    .unset_renviron(pet_id)

    message("You deleted ", pet_name, "'s blueprint :(")

  } else {

    stop("Deletion process stopped.")

  }

}
