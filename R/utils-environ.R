
#' Create an 'tamRgo.environ' File in User's Home Directory
#'
#' @description
#' Create a persistent file in the user's home directory called tamRgo.environ
#' and write to it a provided pet ID (i.e. gist ID) value, with the label
#' TAMRGO_PET_ID.
#'
#' @param pet_id Character. A GitHub gist ID for a YAML file that contains a
#'     given tamRgo pet's blueprint. By default it uses the TAMRGO_PET_ID value
#'     that's in the current environment.
#'
#' @return Nothing.
#'
#' @examples \dontrun{
#' gist_id <- "1234567890abcdefghijklmnopqrstuv"
#' .create_environ(pet_id = gist_id)
#' }
.create_environ <- function(pet_id) {

  .check_pet_id(pet_id)

  response <- readline(
    "Write your pet's ID to a persistent file in your home directory? y/n: "
  )

  if (substr(tolower(response), 1, 1) == "y") {

    env_path <- file.path(Sys.getenv("HOME"), "tamRgo.environ")

    if (file.exists(env_path)) {
      message("tamRgo.environ already exists and will be overwritten")
    }

    pet_env <- c(paste0("TAMRGO_PET_ID=\"", pet_id, "\""))

    writeLines(pet_env, env_path)

    message(env_path, " created.")

    readRenviron(env_path)

    message("Pet ID '", pet_id, "' activated.")

  } else if (substr(tolower(response), 1, 1) == "n")

    stop("tamRgo.renviron was not written.")

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
#' @examples \dontrun{.delete_environ()}
.delete_environ <- function() {

  env_path <- file.path(Sys.getenv("HOME"), "tamRgo.environ")

  file_exists <- file.exists(env_path)

  if (!file_exists) {
    stop("File tamRgo.environ doesn't exist in your home directory.")
  }

  response <- readline(
    "Delete your pet's ID from the persistent file in your home directory? y/n: "
  )

  if (substr(tolower(response), 1, 1) == "y") {
    file.remove(env_path)
    message(env_path, " was deleted.")
  }  else if (substr(tolower(response), 1, 1) == "n") {
    stop("tamRgo.renviron was not deleted from your home directory.")
  }

}

#' Read the 'tamRgo.environ' File in User's Home Directory
#'
#' @description
#' Read into the environment a pet ID (i.e. gist ID) that's stored as
#' TAMRGO_PET_ID in the tamRgo.environ file in the user's home directory,
#'
#' @param env_path Character. Path to a possible 'tamRgo.environ' file on the
#'     user's machine.
#'
#' @return Nothing.
#'
#' @examples \dontrun{.read_environ()}
.read_environ <- function(
    env_path = file.path(Sys.getenv("HOME"), "tamRgo.environ")
) {
  readRenviron(env_path)
}

#' Check the 'tamRgo.environ' File Exists in User's Home Directory
#'
#' @description
#' Check that the tamRgo.environ file exisst in the user's home directory. This
#' is the persistent file that contains a pet ID (i.e. gist ID) stored as
#' TAMRGO_PET_ID.
#'
#' @param env_path Character. Path to a possible 'tamRgo.environ' file on the
#'     user's machine.
#'
#' @return Logical.
#'
#' @examples \dontrun{.check_environ_exists()}
.check_environ_exists <- function(
    env_path = file.path(Sys.getenv("HOME"), "tamRgo.environ")
) {
  file.exists(env_path)
}
