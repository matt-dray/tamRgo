
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

#' Create an 'tamRgo.environ' File in User's Home Directory
#'
#' @description
#' Create a persistent file in the user's home directory called tamRgo.environ
#' and write to it a provided pet ID (i.e. gist ID) value, with the label
#' TAMRGO_PET_ID.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     stored in the user's Renviron.
#' @param read Logical. Read back the value from the newly-created
#'     tamRgo.environ file in the Renviron? Defaults to TRUE
#'
#' @return Nothing.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .create_environ(pet_id = gist_id)
#' }
.create_environ <- function(pet_id, read = TRUE) {

  if (any(!is.character(pet_id), nchar(pet_id) != 32L)) {
    stop(
      "'pet_id' must be a GitHub gist ID: a string of 32 characters.",
      call. = FALSE
    )
  }

  if (!is.logical(read)) {
    stop("'read' must be logical (TRUE or FALSE).")
  }

  response <- utils::menu(
    c("Yes", "No"),
    title = paste(
      "\n{tamRgo} needs to save a file called tamRgo.environ",
      "in your home directory. It will contain a local copy of your pet's ID",
      "(which is also the unqiue ID of the GitHub gist that hosts remotely your
      pet's blueprint YAML file). Is this ok?"
    )
  )

  if (response == 1) {

    env_path <- file.path(Sys.getenv("HOME"), "tamRgo.environ")

    if (file.exists(env_path)) {
      message("\ntamRgo.environ already exists and will be overwritten")
    }

    pet_env <- c(paste0("TAMRGO_PET_ID=\"", pet_id, "\""))

    writeLines(pet_env, env_path)

    message(env_path, " created.")

    if (read == TRUE) {
      readRenviron(env_path)
    }

  } else if (response == 2) {

    stop("tamRgo.renviron was not written.")

  }

}

#' Delete the 'tamRgo.environ' File in User's Home Directory
#'
#' @description
#' Delete the tamRgo.environ file in the user's home directory. This is the
#' persistent file that contains a pet ID (i.e. gist ID) stored as
#' TAMRGO_PET_ID.
#'
#' @return Nothing.
#'
#' @examples \dontrun{.destroy_environ(pet_id = gist_id)}
.destroy_environ <- function() {

  env_path <- file.path(Sys.getenv("HOME"), "tamRgo.environ")

  file_exists <- file.exists(env_path)

  if (!file_exists) {
    stop("File tamRgo.environ doesn't exist in your home directory.")
  }

  response <- utils::menu(
    c("Yes", "No"),
    title = paste(
      "\nDelete the file called tamRgo.environ from your home directory?",
      "It contains a local copy of your pet's ID (which is also the unqiue ID",
      "of the GitHub gist that hosts remotely your pet's blueprint YAML file).",
      "Is this ok?"
    )
  )

  if (response == 1) {
    file.remove(env_path)
    message(env_path, " deleted.")
  }  else if (response == 2) {
    stop("tamRgo.renviron was not written.")
  }

}
