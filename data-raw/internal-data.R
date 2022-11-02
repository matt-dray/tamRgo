

# Load in existing data for editing ---------------------------------------


load("R/sysdata.rda")


# Create internal data list of species images -----------------------------


# Use {pixeltrix} to generate binary matrices representing sprites
# remotes::install_github("matt-dray/pixeltrix")
library(pixeltrix)

# Interactive pixel drawing, outputs binary matrix
xyz0 <- click_pixels(7, 7)
x1   <- click_pixels(8, 8)
x2   <- click_pixels(10, 10)
x3   <- click_pixels(12, 12)
y1   <- click_pixels(8, 8)
y2   <- click_pixels(10, 10)
y3   <- click_pixels(12, 12)
z1   <- click_pixels(8, 8)
z2   <- click_pixels(10, 10)
z3   <- click_pixels(12, 12)
xyz4 <- click_pixels(12, 12)
xyz5 <- click_pixels(10, 10)


# Function to convert from binary matrix to pixel matrix
matrix_to_sprite <- function(
    m,  # binary matrix representing sprite
    states = c("0" = " ", "1" = "█"),  # convert binary to 'pixels'
    preview = TRUE  # autoprint to console
) {

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

# Generate a pixel matrix for each sprite from their binary matrix
xyz0_sprite <- matrix_to_sprite(xyz0)
x1_sprite   <- matrix_to_sprite(x1)
x2_sprite   <- matrix_to_sprite(x2)
x3_sprite   <- matrix_to_sprite(x3)
y1_sprite   <- matrix_to_sprite(y1)
y2_sprite   <- matrix_to_sprite(y2)
y3_sprite   <- matrix_to_sprite(y3)
z1_sprite   <- matrix_to_sprite(z1)
z2_sprite   <- matrix_to_sprite(z2)
z3_sprite   <- matrix_to_sprite(z3)
xyz4_sprite <- matrix_to_sprite(xyz4)
xyz5_sprite <- matrix_to_sprite(xyz5)

# Put the sprite matrices into a list object
sprites <- list(
  sp_xyz = list(lvl_0 = xyz0_sprite, lvl_4 = xyz4_sprite, lvl_5 = xyz5_sprite),
  sp_x   = list(lvl_1 = x1_sprite,   lvl_2 = x2_sprite,   lvl_3 = x3_sprite),
  sp_y   = list(lvl_1 = y1_sprite,   lvl_2 = y2_sprite,   lvl_3 = y3_sprite),
  sp_z   = list(lvl_1 = z1_sprite,   lvl_2 = z2_sprite,   lvl_3 = z3_sprite)
)



# Other graphics ----------------------------------------------------------


dirt <- click_pixels(5, 7)
graphics <- list(dirt = matrix_to_sprite(dirt))


# Declare constants -------------------------------------------------------


constants <- list(
  happy_decrement  = 15L,
  hungry_increment = 30L,
  dirty_increment  = 45L,
  xp_increment     = 30L,
  xp_threshold_1   = 100L,
  xp_threshold_2   = 200L,
  xp_threshold_3   = 500L,
  xp_threshold_4   = 1000L,
  age_freeze       = 21L,
  level_names = list(
    lvl_0 = "newborn",
    lvl_1 = "child",
    lvl_2 = "youngling",
    lvl_3 = "adult",
    lvl_4 = "mature",
    lvl_5 = "unalive"
  )
)


# Write and read ----------------------------------------------------------


# Combine the lists
internal <- list(
  sprites = internal$sprites,
  graphics = internal$graphics,
  constants = constants
)

# Write the object
usethis::use_data(internal, internal = TRUE, overwrite = TRUE)


