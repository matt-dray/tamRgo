#' Generate a New Pet
#'
#' @description Lays an egg that contains a new digital pet who will live on
#'     your computer.
#'
#' @param pet_name Character. A name for your new pet. Maximum eight characters.
#'
#' @details A persistent 'blueprint' file of your pet's characteristics will be
#'     saved to your computer. It will be saved as an RDS to the directory
#'     location given by `tools::R_user_dir("tamRgo", which = "data")`. You can
#'     only have store one blueprint at a time, so you can only have one pet at
#'     a time on your computer. .
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{lay_egg(pet_name = "KEVIN")}
lay_egg <- function(pet_name) {

  bp <- .create_blueprint(pet_name)
  .write_blueprint(bp)

  message("You have a new egg", appendLF = FALSE); Sys.sleep(1)
  message(".", appendLF = FALSE); Sys.sleep(1)
  message(".", appendLF = FALSE); Sys.sleep(1)
  message(".", appendLF = FALSE); Sys.sleep(1)
  message(" it hatched!", appendLF = FALSE)
  message("\nYou can get_stats(), see_pet(), play(), feed(), clean().")

}

#' Print Pet Statistics
#'
#' @description Print to the console your pet's current characteristics and
#'     status values.
#'
#' @details The output will show the following elements:
#'
#' \describe{
#'   \item{Name}{Pet's user-provided name.}
#'   \item{Species}{Randomly-selected pet species.}
#'   \item{Age}{Days since born.}
#'   \item{Level}{Growth stage.}
#'   \item{Happy}{Happiness on a scale of 0 to 5.}
#'   \item{Hungry}{Hunger on a scale of 0 to 5.}
#'   \item{Dirty}{Dirtiness on a scale of 0 to 5.}
#' }
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{get_stats()}
get_stats <- function() {

  bp <- .check_and_update()

  if (bp$experience$level == 0L) level_text <- internal$constants$level_names$lvl_0
  if (bp$experience$level == 1L) level_text <- internal$constants$level_names$lvl_1
  if (bp$experience$level == 2L) level_text <- internal$constants$level_names$lvl_2
  if (bp$experience$level == 3L) level_text <- internal$constants$level_names$lvl_3
  if (bp$experience$level == 4L) level_text <- internal$constants$level_names$lvl_4
  if (bp$experience$level == 5L) level_text <- internal$constants$level_names$lvl_5

  empty_happy  <- rep("\U025A0", bp$status$happy)
  empty_hungry <- rep("\U025A0", bp$status$hungry)
  empty_dirty  <- rep("\U025A0", bp$status$dirty)

  filled_happy  <- rep("\U025A1", 5 - bp$status$happy)
  filled_hungry <- rep("\U025A1", 5 - bp$status$hungry)
  filled_dirty  <- rep("\U025A1", 5 - bp$status$dirty)

  if (bp$status$happy == 0L) {
    warn_happy  <- " !"
  } else {
    warn_happy <-  "  "
  }

  if (bp$status$hungry == 5L) {
    warn_hungry <- " !"
  } else {
    warn_hungry <- "  "
  }

  if (bp$status$dirty == 5L) {
    warn_dirty  <- " !"
  } else {
    warn_dirty  <- "  "
  }

  message(
    "Characteristics",
    "\n  Name:    ", bp$characteristics$name,
    "\n  Species: ", bp$characteristics$species,
    "\n  Age:     ", bp$characteristics$age,
    "\n  Level:   ", bp$experience$level, paste0(" (", level_text, ")")
  )

  if (bp$meta$alive) {
    message(
      "Status",
      "\n  Happy:   ", empty_happy,  filled_happy,  warn_happy,
      "\n  Hungry:  ", empty_hungry, filled_hungry, warn_hungry,
      "\n  Dirty:   ", empty_dirty,  filled_dirty,  warn_dirty
    )
  }

}

#' See Your Pet
#'
#' @description Print to the console an image of your digital pet.
#'
#' @details The appearance of your pet is dependent on its species and level,
#'     which you can view with \code{\link{get_stats}}.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{see_pet()}
see_pet <- function() {

  bp <- .check_and_update()

  pet_matrix <- .get_pet_matrix(
    bp$characteristics$species,
    bp$experience$level
  )

  .draw_pet(pet_matrix)

}

#' Play with Your Pet
#'
#' @description Play a game of chance with your pet, which increases your pet's
#'     'happy' status value by 1, up to a maximum of 5.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{play()}
play <- function() {

  bp <- .check_and_update()

  if (bp$status$happy == 5) {
    stop(
      "Happiness is already at the maximum value! Can't play.",
      call. = FALSE
    )
  }

  if (bp$status$dirty > 0) {
    stop(
      paste(
        bp$characteristics$name, "is dirty! You should clean() before you play!"
      ),
      call. = FALSE
    )
  }

  chance_bad_base <- 1 - (1 / (bp$status$hungry + 1))
  chance_bad <- chance_bad_base / 4
  chance_good <- (1 - chance_bad_base) / 6

  results <- vector(mode = "list", length = 5)

  for (i in 1:5) {

    shown <- sample(
      1:10,
      size = 1,
      prob = c(rep(chance_good, 3), rep(chance_bad, 4), rep(chance_good, 3))
    )

    actual <- sample(1:10, size = 1)
    actual_direction <- sign(actual - shown)

    guess <- tolower(
      readline(
        paste0("The number is ", shown, ". Higher or lower? Type 'H' or 'L': ")
      )
    )

    if (guess == "h") guess_direction <- 1
    if (guess == "l") guess_direction <- -1

    is_correct <- actual_direction == guess_direction

    if (is_correct) {

      results[i] <- TRUE
      correct_n <- length(Filter(isTRUE, results))
      message("Correct! It was ", actual, ". Score: ", correct_n, "/5.")

    }

    if (!is_correct) {

      results[i] <- FALSE
      correct_n <- length(Filter(isTRUE, results))
      message("Wrong! It was ", actual, ". Score: ", correct_n, "/5.")

    }

  }

  correct_n <- length(Filter(isTRUE, results))
  message("Result: you scored ", correct_n, "/5!")

  if (correct_n > 0) {
    bp$status$happy <- min(bp$status$happy + 1L, 5L)
  }

  bp$experience$xp <- bp$experience$xp + correct_n
  suppressMessages(.write_blueprint(bp, ask = FALSE))

  message("'Happy' status value is now ", bp$status$happy, "/5")

}

#' Feed Your Pet
#'
#' @description Give food to your pet, which reduces your pet's 'hungry' status
#'     value by 1, down to a minimum of 0.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{feed()}
feed <- function() {

  bp <- .check_and_update()

  if (bp$status$hungry == 0) {
    stop(
      "Hunger is already at the minimum value! Can't feed.",
      call. = FALSE
    )
  }

  bp$status$hungry <- max(bp$status$hungry - 1L, 0L)
  suppressMessages(.write_blueprint(bp, ask = FALSE))
  message("'Hungry' status value is now ", bp$status$hungry, "/5")

}

#' Clean Your Pet
#'
#' @description  Clean dirt off your pet, which reduces your pet's 'dirty'
#'     status value by 1, down to a minimum of 0.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{clean()}
clean <- function() {

  bp <- .check_and_update()

  if (bp$status$dirty == 0) {
    stop(
      "Dirtiness is already at the minimum value! Can't clean.",
      call. = FALSE
    )
  }

  bp$status$dirty <- 0L
  suppressMessages(.write_blueprint(bp, ask = FALSE))
  message("'Dirty' status value is now 0/5")

}

#' Release Your Pet
#'
#' @description Release your pet into the world. Once released, they're gone
#'     forever.
#'
#' @details Deletes the persistent 'blueprint' file of your pet's
#'     characteristics that's saved as an RDS in the directory location given
#'     by `tools::R_user_dir("tamRgo", which = "data")`.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{release()}
release <- function() {

  bp <- .check_and_update()

  answer_a <-
    readline(paste0("Really release ", bp$characteristics$name, "? y/n: "))

  if (substr(tolower(answer_a), 1, 1) == "y") {

    answer_b <- readline("Are you sure? y/n: ")

    if (substr(tolower(answer_b), 1, 1) == "y") {

      file.remove(
        file.path(tools::R_user_dir("tamRgo", which = "data"), "blueprint.rds")
      )

      message(bp$characteristics$name, " was set free!")

    } else {
      message(bp$characteristics$name, " was not released.")
    }

  } else {
    message(bp$characteristics$name, " was not released.")
  }

}
