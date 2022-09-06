#' A tamRgo Pet Blueprint (List)
#'
#' @description
#' A demo blueprint of a tamRgo pet as a list.
#'
#' @format A list with two elements of length 5 and 3 respectively, containing
#'     character or integer vectors of length 1.
#' \describe{
#'   \item{characteristics}{'name' (character), 'species' (character), 'stage' (integer), 'born' (character) and 'age' (integer)}
#'   \item{status}{'hungry' (integer), 'happy' (integer) and 'dirty' (integer)}
#' }
"blueprint_list"

#' A tamRgo Pet Blueprint (YAML String)
#'
#' @description
#' A demo blueprint of a tamRgo pet as a character string that represents a YAML
#' file.
#'
#' @format A character string that represents a YAML file with two lists of 5
#'     and 3 members respectively.
#' \describe{
#'   \item{characteristics}{'name' (character), 'species' (character), 'stage' (integer), 'born' (character) and 'age' (integer)}
#'   \item{status}{'hungry' (integer), 'happy' (integer) and 'dirty' (integer)}
#' }
"blueprint_yaml"
