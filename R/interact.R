
#' Generate A New tamRgo Pet Egg
#'
#' @description
#' Create a new tamRgo-pet blueprint, write it to a new gist and set its pet ID
#' (i.e. GitHub gist ID) in your Renviron file as TAMRGO_PET_ID. The new pet is
#' at the egg stage.
#'
#' @param pet_name Character. A name for the new tamRgo pet.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{lay_egg(name = "Kevin")}
lay_egg <- function(pet_name) {

  bp <- .create_blueprint(pet_name)
  gist_info <- .post_blueprint(bp)
  pet_id <- basename(gist_info$url)
  bp$characteristics$pet_id <- pet_id
  suppressMessages(.patch_blueprint(pet_id, "pet_id", pet_id))

  message("You have a new egg!")

  has_environ <- .check_environ_exists()
  .create_environ(pet_id)

}

#' Load A tamRgo Pet
#'
#' @description
#' Fetch a pet ID (i.e. GitHub gist ID) from the TAMRGO_PET_ID variable in the
#' tamRgo.environ file on the user's home directory. If tamRgo.environ doesn't
#' exist, then prompt to create it.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' load_pet(pet_id = gist_id)
#' }
load_pet <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (pet_id == "") {

    has_environ <- .check_environ_exists()

    if (has_environ) {
      .read_environ()
    }

  } else {

    .create_environ(pet_id)

  }

}

#' See A Stats Summary For A tamRgo Pet
#'
#' @description
#' Print to the console the current characteristics and status of a tamRgo pet.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's home directory in a tamRgo.environ file.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' see_stats(pet_id = gist_id)
#' }
see_stats <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (pet_id == "") {
    load_pet(pet_id)
    pet_id <- Sys.getenv("TAMRGO_PET_ID")
  } else {
    .create_environ(pet_id)
  }

  bp <- .get_blueprint(pet_id)

  message(
    "Pet characteristics",                     "\n",
    "- Name:    ", bp$characteristics$name,    "\n",
    "- Species: ", bp$characteristics$species, "\n",
    "- Born:    ", bp$characteristics$born,    "\n",
    "- Age:     ", bp$characteristics$age,     "\n",
    "- Stage:   ", bp$characteristics$stage,   "\n",
    "- XP:      ", bp$characteristics$xp,      "\n",
    "Pet status",                              "\n",
    "- Hungry:  ", bp$status$hungry, "/5",     "\n",
    "- Happy:   ", bp$status$happy,  "/5",     "\n",
    "- Dirty:   ", bp$status$dirty,  "/5"
  )

}

#' Feed A tamRgo Pet
#'
#' @description
#' Feed a tamRgo pet, decreasing its 'hungry' status by 1.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' feed_pet(pet_id = gist_id)
#' }
feed_pet <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (pet_id == "") {
    load_pet(pet_id)
    pet_id <- Sys.getenv("TAMRGO_PET_ID")
  } else {
    .create_environ(pet_id)
  }

  change_value <- -1L
  .change_status(pet_id, "hungry", change_value, 0L, 5L)

  .patch_blueprint(pet_id, "hungry", change_value)

}

#' Play With A tamRgo Pet
#'
#' @description
#' Play with a tamRgo pet, increasing its 'happy' status by 1.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' play_with_pet(pet_id = gist_id)
#' }
play_with_pet <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (pet_id == "") {
    load_pet(pet_id)
    pet_id <- Sys.getenv("TAMRGO_PET_ID")
  } else {
    .create_environ(pet_id)
  }

  change_value <- 1L
  .change_status(pet_id, "happy", change_value, 0L, 5L)

  .patch_blueprint(pet_id, "happy", change_value)


}

#' Clean A tamRgo Pet
#'
#' @description
#' Clean a tamRgo pet, decreasing its 'dirty' status by 1.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' clean_pet(pet_id = gist_id)
#' }
clean_pet <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (pet_id == "") {
    load_pet(pet_id)
    pet_id <- Sys.getenv("TAMRGO_PET_ID")
  } else {
    .create_environ(pet_id)
  }

  change_value <- -1L
  .change_status(pet_id, "dirty", change_value, 0L, 5L)

  .patch_blueprint(pet_id, "dirty", change_value)

}

#' Release A tamRgo Pet Forever
#'
#' @description
#' Delete a tamRgo pet's blueprint (YAML file) from its associated GitHub gist.
#' Also unsets the pet ID (TAMRGO_PET_ID) from the Renviron.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{release_pet()}
release_pet <- function(pet_id) {

  .check_pet_id(pet_id)

  pet_name <- .get_blueprint(pet_id)[["characteristics"]][["name"]]

  answer_1 <- readline(
    paste0(
      "Say goodbye to ", pet_name,
      " (pet_id ", paste0(substr(pet_id, 1, 8), "..."), ")? y/n: "
    )
  )

  if (substr(tolower(answer_1), 1, 1) == "y") {

    answer_2 <- readline(
      "Really delete your tamRgo pet's blueprint (GitHub gist)? y/n: "
    )

  } else {
    stop("Deletion process stopped.", call. = FALSE)
  }

  if (substr(tolower(answer_2), 1, 1) == "y") {

    .delete_blueprint(pet_id)
    .delete_environ()

    message("A tear rolls down your cheek.")

  } else {
    stop("Deletion process stopped.", call. = FALSE)
  }

}
