
xm <- pixeltrix::click_pixels(8, 8)
ym <- pixeltrix::click_pixels(8, 8)
zm <- pixeltrix::click_pixels(8, 8)

matrix_to_sprite <- function(m, states = c("0" = "░", "1" = "█"), preview = TRUE) {

  mode(m) <- "character"
  x <- matrix(states[m], nrow(m), ncol(m))

  if (preview) {
    for (i in seq(nrow(x))) {
      row <- paste(x[i, ], collapse = "")
      message(row)
    }
  }

  return(x)

}

matrix_to_sprite(xm) -> x
matrix_to_sprite(ym) -> y
matrix_to_sprite(zm) -> z

species_images <- list(X = x, Y = y, Z = z)

usethis::use_data(species_images, internal = TRUE, overwrite = TRUE)
