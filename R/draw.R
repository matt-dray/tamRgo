
.get_pet_matrix <- function(species = c("X", "Y", "Z"), level = 0L:4L) {

  species <- match.arg(species)

  if (level < 0L | level > 4L) {
    stop(
      "Argument 'level' can only be an integer between 0 and 4.",
      call. = FALSE
    )
  }

  if (level == 0L) return(internal$sprites$sp_all$lvl_0)

  if (species == "X") {
    if (level == 1L) return(internal$sprites$sp_x$lvl_1)
    if (level == 2L) return(internal$sprites$sp_x$lvl_2)
    if (level == 3L) return(internal$sprites$sp_x$lvl_3)
  }

  if (species == "Y") {
    if (level == 1L) return(internal$sprites$sp_y$lvl_1)
    if (level == 2L) return(internal$sprites$sp_y$lvl_2)
    if (level == 3L) return(internal$sprites$sp_y$lvl_3)
  }

  if (species == "Z") {
    if (level == 1L) return(internal$sprites$sp_z$lvl_1)
    if (level == 2L) return(internal$sprites$sp_z$lvl_2)
    if (level == 3L) return(internal$sprites$sp_z$lvl_3)
  }

  if (level == 4L) return(internal$sprites$sp_all$lvl_4)

  return(internal$sprites$sp_all$lvl_5)  # if all else fails, unalive sprite

}

.draw_pet <- function(pet_matrix) {

  for (i in seq(nrow(pet_matrix))) {
    row <- paste(pet_matrix[i, ], collapse = "")
    message(row)
  }

}
