
.get_pet_matrix <- function(blueprint) {

  if (!blueprint$meta$alive) return(internal$sprites$sp_all$unalive)

  if (blueprint$experience$level == 0L) return(internal$sprites$sp_all$lvl_0)

  if (blueprint$characteristics$species == "X") {
    if (blueprint$experience$level == 1L) return(internal$sprites$sp_x$lvl_1)
    if (blueprint$experience$level == 2L) return(internal$sprites$sp_x$lvl_2)
    if (blueprint$experience$level == 3L) return(internal$sprites$sp_x$lvl_3)
  }

  if (blueprint$characteristics$species == "Y") {
    if (blueprint$experience$level == 1L) return(internal$sprites$sp_y$lvl_1)
    if (blueprint$experience$level == 2L) return(internal$sprites$sp_y$lvl_2)
    if (blueprint$experience$level == 3L) return(internal$sprites$sp_y$lvl_3)
  }

  if (blueprint$characteristics$species == "Z") {
    if (blueprint$experience$level == 1L) return(internal$sprites$sp_z$lvl_1)
    if (blueprint$experience$level == 2L) return(internal$sprites$sp_z$lvl_2)
    if (blueprint$experience$level == 3L) return(internal$sprites$sp_z$lvl_3)
  }

  if (blueprint$experience$level == 4L) return(internal$sprites$sp_all$lvl_4)

}

.draw_pet <- function(pet_matrix) {

  for (i in seq(nrow(pet_matrix))) {
    row <- paste(pet_matrix[i, ], collapse = "")
    message(row)
  }

}
