xyz0 <- pixeltrix::click_pixels(7, 7)

x1 <- pixeltrix::click_pixels(8, 8)
x2 <- pixeltrix::click_pixels(10, 10)
x3 <- pixeltrix::click_pixels(12, 12)

y1 <- pixeltrix::click_pixels(8, 8)
y2 <- pixeltrix::click_pixels(10, 10)
y3 <- pixeltrix::click_pixels(12, 12)

z1 <- pixeltrix::click_pixels(8, 8)
z2 <- pixeltrix::click_pixels(10, 10)
z3 <- pixeltrix::click_pixels(12, 12)

matrix_to_sprite <- function(m, states = c("0" = " ", "1" = "█"), preview = TRUE) {

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

matrix_to_sprite(xyz0) -> xyz0_s

matrix_to_sprite(x1) -> x1_s
matrix_to_sprite(x2) -> x2_s
matrix_to_sprite(x3) -> x3_s

matrix_to_sprite(y1) -> y1_s
matrix_to_sprite(y2) -> y2_s
matrix_to_sprite(y3) -> y3_s

matrix_to_sprite(z1) -> z1_s
matrix_to_sprite(z2) -> z2_s
matrix_to_sprite(z3) -> z3_s

species_images <- list(
  X = list(level_0 = xyz0_s, level_1 = x1_s, level_2 = x2_s, level_3 = x3_s),
  Y = list(level_0 = xyz0_s, level_1 = y1_s, level_2 = y2_s, level_3 = y3_s) ,
  Z = list(level_0 = xyz0_s, level_1 = z1_s, level_2 = z2_s, level_3 = z3_s)
)

usethis::use_data(species_images, internal = TRUE, overwrite = TRUE)
