
.create_blueprint <- function(pet_name) {

  if (!is.character(pet_name) | nchar(pet_name) > 8) {
    stop(
      "Argument 'pet_name' must be a string with 8 characters or fewer.",
      call. = FALSE
    )
  }

  rolled <- .roll_characteristics()
  datetime <- Sys.time()

  list(
    meta = list(
      pet_id = rolled$pet_id,
      last_interaction = datetime,
      alive = TRUE
    ),
    characteristics = list(
      name = pet_name,
      species = rolled$species,
      born = format(datetime, "%Y-%m-%d"),
      age = 0L
    ),
    experience = list(
      xp = 0L,
      xp_freeze = NA_real_,
      level = 0L
    ),
    status = list(
      happy = 3L,
      hungry = 3L,
      dirty = 0L
    )
  )

}

.roll_characteristics <- function() {

  pet_id_chars <- c(letters, LETTERS, 0:9)
  pet_id <- paste(sample(pet_id_chars, 16, replace = TRUE), collapse = "")

  species_list <- c("X", "Y", "Z")
  species <- sample(species_list, 1)

  list(
    pet_id = pet_id,
    species = species
  )

}

.write_blueprint <- function(blueprint, ask = TRUE) {

  .check_blueprint(blueprint)

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  has_data_dir <- file.exists(data_dir)

  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!ask) {

    if (!has_data_dir) {
      dir.create(data_dir, recursive = TRUE)
    }

    saveRDS(blueprint, file.path(data_file))

    message("Saved pet blueprint.")

  }

  if (ask & !has_data_file) {

    answer <- readline("Save pet blueprint? y/n: ")

    if (substr(tolower(answer), 1, 1) == "y") {

      if (!has_data_dir) {
        dir.create(data_dir, recursive = TRUE)
      }

      saveRDS(blueprint, file.path(data_file))

      message("Saved pet blueprint.")

    } else {

      stop("Did not write pet's blueprint.", call. = FALSE)

    }

  }

  if (ask & has_data_file) {

    answer <- readline("Overwrite existing pet's blueprint? y/n: ")

    if (substr(tolower(answer), 1, 1) == "y") {

      if (!has_data_dir) {
        dir.create(data_dir, recursive = TRUE)
      }

      saveRDS(blueprint, file.path(data_file))

      message("Saved pet blueprint.")

    } else {

      stop("Did not overwrite existing pet blueprint.", call. = FALSE)

    }

  }

}

.read_blueprint <- function() {

  data_dir <- tools::R_user_dir("tamRgo", which = "data")
  data_file <- file.path(data_dir, "blueprint.rds")
  has_data_file <- file.exists(data_file)

  if (!has_data_file) {
    stop("There is no blueprint to read.", call. = FALSE)
  }

  if (has_data_file) {
    readRDS(data_file)
  }

}
