
#' Set A tamRgo Pet ID In The Renviron
#'
#' @description
#' Set the pet ID (i.e. GitHub gist ID) as the 'TAMRGO_PET_ID' value in the
#' user's Renviron file. This prevents a user having to supply the pet_id
#' whenever they interact with their pet.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#' @param overwrite Logical. Should an existing pet ID value in the Renviron be
#'     overwritten by the supplied pet_id? Defaults to TRUE.
#'
#' @return Nothing. Updates the user's Renviron file, prints messages to the
#'     console.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .set_renviron(pet_id = gist_id)
#' }
.set_renviron <- function(
    pet_id = Sys.getenv("TAMRGO_PET_ID"),
    overwrite = TRUE
) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop(
      "'pet_id' must be a GitHub gist ID: a string of 32 characters.",
      call. = FALSE
    )
  }

  id_exists <- "TAMRGO_PET_ID" %in% names(Sys.getenv())

  if (id_exists) {

    id_matches <- Sys.getenv("TAMRGO_PET_ID") == pet_id

    if (id_matches) {
      stop(
        "You've already set that 'pet_id' value in your Renviron file.",
        call. = FALSE
      )
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

    message(
      "The Renviron variable TAMRGO_PET_ID has been set with the provided ",
      "'pet_id' value."
    )

  }

}

#' Unset A tamRgo Pet ID From The Renviron
#'
#' @description
#' Set the pet ID (i.e. GitHub gist ID) as the 'TAMRGO_PET_ID' value in the
#' user's Renviron file. This prevents a user having to supply the pet_id
#' whenever they interact with their pet.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#'
#' @return Nothing. Updates the user's Renviron file, prints messages to the
#'     console.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .unset_renviron(pet_id = gist_id)
#' }
.unset_renviron <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop(
      "'pet_id' must be a GitHub gist ID: a string of 32 characters.",
      call. = FALSE
    )
  }

  id_exists <- "TAMRGO_PET_ID" %in% names(Sys.getenv())

  if (id_exists) {

    Sys.unsetenv("TAMRGO_PET_ID")

    message("The Renviron variable TAMRGO_PET_ID has been reset.")

  }

}






.create_environ <- function(pet_id) {

  pet_env <- c(paste0("TAMRGO_PET_ID=\"", pet_id, "\""))

  create_env <- utils::menu(
    c("Yes", "No"),
    title = paste(
      "\n{tamRgo} needs to save a file called tamRgo.environ",
      "in your home directory. It will contain a local copy of your pet's ID",
      "(which is also the unqiue ID of the GitHub gist that hosts remotely your
      pet's blueprint YAML file). Is this ok?"
    )
  )

  if (create_env == 1) {

    env_path <- file.path(Sys.getenv("HOME"), "tamRgo.environ")

    if (file.exists(env_path)) {
      message("\ntamRgo.environ already exists and will be overwritten")
    }

    writeLines(pet_env, env_path)

    message(env_path, " created.")

    readRenviron(env_path)

  } else if (create_env == 2) {

    stop("tamRgo.renviron was not written.")

  }

}

.destroy_environ <- function() {

  env_path <- file.path(Sys.getenv("HOME"), "tamRgo.environ")

  file.remove(env_path)

}
