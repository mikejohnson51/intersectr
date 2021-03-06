% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nc_utils.R
\name{find_var_by_att}
\alias{find_var_by_att}
\title{Find NetCDF Variable by attribute}
\usage{
find_var_by_att(x, attribute, value = ".*", strict = TRUE)
}
\arguments{
\item{x}{data.frame returned by ncmeta::nc_atts, open NetCDF object,
or character file path or url to be opened with RNetCDF::open.nc}

\item{attribute}{character the attribute name to search for variables with}

\item{value}{character defaults to any only return variables that have the
attribute with the given value}

\item{strict}{boolean if TRUE, only exact matches of value will be returned}
}
\description{
Given an attribute name and potentially a value,
searches for and returns variables with the desired attribute.
}
\examples{
nc <- system.file("extdata/metdata.nc", package = "intersectr")

find_var_by_att(nc, "coordinates")

find_var_by_att(nc, "units")

find_var_by_att(nc, "units", "degrees", strict = FALSE)

find_var_by_att(nc, "units", "degrees", strict = TRUE)

find_var_by_att(nc, "units", "degrees_east", strict = TRUE)

}
