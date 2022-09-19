


.check_pet_id <- function(pet_id = Sys.getenv("TAMRGO_PET_ID")) {

  if (!is.character(pet_id) | nchar(pet_id) != 32L) {
    stop(
      "'pet_id' must be a GitHub gist ID: a string of 32 characters.",
      call. = FALSE
    )
  }

}
