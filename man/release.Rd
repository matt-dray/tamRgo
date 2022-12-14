% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interact.R
\name{release}
\alias{release}
\title{Release Your Pet}
\usage{
release()
}
\value{
Nothing.
}
\description{
Release your pet into the world. Once released, they're gone
forever.
}
\details{
Deletes the persistent 'blueprint' file of your pet's
characteristics that's saved as an RDS in the directory location given
by \code{tools::R_user_dir("tamRgo", which = "data")}.
}
\examples{
\dontrun{release()}
}
