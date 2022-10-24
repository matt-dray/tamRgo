
.get_pet_matrix <- function(species = c("X", "Y", "Z"), level = 0L:5L) {

  species <- match.arg(species)

  if (level < 0L | level > 5L) {
    stop(
      "Argument 'level' can only be an integer between 0 and 5.",
      call. = FALSE
    )
  }

  if (level == 0L) return(internal$sprites$sp_xyz$lvl_0)
  if (level == 4L) return(internal$sprites$sp_xyz$lvl_4)
  if (level == 5L) return(internal$sprites$sp_xyz$lvl_5)

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

}

.draw_pet <- function(pet_matrix) {

  for (i in seq(nrow(pet_matrix))) {
    row <- paste(pet_matrix[i, ], collapse = "")
    message(row)
  }

}
