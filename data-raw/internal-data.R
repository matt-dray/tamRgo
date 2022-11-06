

# Load in existing data for editing ---------------------------------------


load("R/sysdata.rda")


# Create internal data list of species images -----------------------------


# Use {pixeltrix} to generate binary matrices representing sprites
# remotes::install_github("matt-dray/pixeltrix")
library(pixeltrix)

# Interactive pixel drawing, outputs binary matrix
all_0 <- click_pixels(7, 7)
x_1   <- click_pixels(8, 8)
x_2   <- click_pixels(10, 10)
x_3   <- click_pixels(12, 12)
y_1   <- click_pixels(8, 8)
y_2   <- click_pixels(10, 10)
y_3   <- click_pixels(12, 12)
z_1   <- click_pixels(8, 8)
z_2   <- click_pixels(10, 10)
z_3   <- click_pixels(12, 12)
all_4 <- click_pixels(12, 12)
all_unalive <- click_pixels(10, 10)
dirt <- click_pixels(5, 7)

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
all_0_sprite <- matrix_to_sprite(all_0)
x_1_sprite   <- matrix_to_sprite(x_1)
x_2_sprite   <- matrix_to_sprite(x_2)
x_3_sprite   <- matrix_to_sprite(x_3)
y_1_sprite   <- matrix_to_sprite(y_1)
y_2_sprite   <- matrix_to_sprite(y_2)
y_3_sprite   <- matrix_to_sprite(y_3)
z_1_sprite   <- matrix_to_sprite(z_1)
z_2_sprite   <- matrix_to_sprite(z_2)
z_3_sprite   <- matrix_to_sprite(z_3)
all_4_sprite <- matrix_to_sprite(all_4)
all_unalive_sprite <- matrix_to_sprite(all_unalive)
dirt_sprite <- matrix_to_sprite(dirt)

# Put the sprite matrices into a list object
sprites <- list(
  sp_all = list(lvl_0 = all_0_sprite, lvl_4 = all_4_sprite, unalive = all_unalive_sprite),
  sp_x   = list(lvl_1 = x_1_sprite,   lvl_2 = x_2_sprite,   lvl_3 = x_3_sprite),
  sp_y   = list(lvl_1 = y_1_sprite,   lvl_2 = y_2_sprite,   lvl_3 = y_3_sprite),
  sp_z   = list(lvl_1 = z_1_sprite,   lvl_2 = z_2_sprite,   lvl_3 = z_3_sprite),
  other  = list(dirt = dirt_sprite)
)


# Declare constants -------------------------------------------------------


constants <- list(
  happy_decrement  = 15L,
  hungry_increment = 30L,
  dirty_increment  = 45L,
  xp_increment     = 30L,
  xp_threshold_1   = 100L,
  xp_threshold_2   = 200L,
  xp_threshold_3   = 400L,
  xp_threshold_4   = 800L,
  age_freeze       = 7L,
  level_names = list(
    lvl_0 = "newborn",
    lvl_1 = "child",
    lvl_2 = "youngling",
    lvl_3 = "adult",
    lvl_4 = "mature"
  )
)


# Write and read ----------------------------------------------------------


# Combine the lists
internal <- list(sprites = sprites, constants = constants)

# Write the object
usethis::use_data(internal, internal = TRUE, overwrite = TRUE)
