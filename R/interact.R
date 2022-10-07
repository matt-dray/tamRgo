#' Create a New Pet
#'
#' @description Generate and save a new pet's blueprint. The pet begins life as
#'     an egg.
#'
#' @param pet_name Character. A name for the new tamRgo pet. Maximum eight
#'     characters.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{lay_egg(name = "KEVIN")}
lay_egg <- function(pet_name) {

  bp <- .create_blueprint(pet_name)
  .write_blueprint(bp)

  message("You have a new egg", appendLF = FALSE); Sys.sleep(1)
  message(".", appendLF = FALSE); Sys.sleep(1)
  message(".", appendLF = FALSE); Sys.sleep(1)
  message(".", appendLF = FALSE); Sys.sleep(1)
  message(" it hatched!", appendLF = FALSE)
  message("\nSee its stats with get_stats()")

}

#' Print Your Pet's Stats
#'
#' @description Print to the console the characteristics, experience and status
#'     of the current pet.
#'
#' @details The  output will show the following elements of the blueprint:
#'
#' Section 'characteristics':
#' \describe{
#'   \item{name}{Pet's user-provided name.}
#'   \item{species}{Randomly-selected pet species.}
#'   \item{born}{Date that the pet was created.}
#'   \item{age}{Days since born.}
#'   \item{level}{Growth stage.}
#'   \item{xp}{Experience points.}
#'   \item{happy}{Happiness on a scale of 0 to 5.}
#'   \item{hungry}{Hunger on a scale of 0 to 5.}
#' }
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{see_stats()}
get_stats <- function() {

  bp <- .check_and_update()

  message(
    "Characteristics",
    "\n  Name:    ", bp$characteristics$name,
    "\n  Species: ", bp$characteristics$species,
    "\n  Age:     ", bp$characteristics$age,
    "\n  Level:   ", bp$experience$level,
    "\nStatus",
    "\n  Happy:   ", rep("\U025A0", bp$status$happy),  rep("\U025A1", 5 - bp$status$happy),
    "\n  Hungry:  ", rep("\U025A0", bp$status$hungry), rep("\U025A1", 5 - bp$status$hungry)
  )

}

#' See Your Pet
#'
#' @description Print to the console an image of your pet.
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
#' @description Increase 'happy' status value by 1 (max 5).
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{play()}
play <- function() {

  bp <- .check_and_update()

  if (bp$status$happy >= 5) {
    stop("Happiness is already at the maximum value! Can't play.")
  }

  bp$status$happy <- min(bp$status$happy + 1L, 5L)
  bp$experience$xp <- bp$experience$xp + 10L
  suppressMessages(.write_blueprint(bp, ask = FALSE))
  message("'Happy' status value is now ", bp$status$happy, "/5")

}

#' Feed Your Pet
#'
#' @description Reduce 'hungry' status value by 1 (min 0).
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{feed()}
feed <- function() {

  bp <- .check_and_update()

  if (bp$status$hungry <= 0) {
    stop("Hunger is already at the minimum value! Can't feed.")
  }

  bp$status$hungry <- max(bp$status$hungry - 1L, 0L)
  bp$experience$xp <- bp$experience$xp + 5L
  suppressMessages(.write_blueprint(bp, ask = FALSE))
  message("'Hungry' status value is now ", bp$status$hungry, "/5")

}

#' Release Your Pet
#'
#' @description Delete the current blueprint.
#'
#' @return Nothing.
#'
#' @export
#'
#' @examples \dontrun{see_stats()}
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
