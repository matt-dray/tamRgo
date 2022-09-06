# blueprint-demo

blueprint_list <- .create_blueprint("Kevin", 1234L)
usethis::use_data(blueprint_list, overwrite = TRUE)

blueprint_yaml <- yaml::as.yaml(blueprint_list)
usethis::use_data(blueprint_yaml, overwrite = TRUE)
