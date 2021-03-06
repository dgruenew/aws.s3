% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_bucket.R
\name{get_bucket}
\alias{get_bucket}
\alias{get_bucket_df}
\title{List bucket contents}
\usage{
get_bucket(
  bucket,
  prefix = NULL,
  delimiter = NULL,
  max = NULL,
  marker = NULL,
  parse_response = TRUE,
  ...
)

get_bucket_df(
  bucket,
  prefix = NULL,
  delimiter = NULL,
  max = NULL,
  marker = NULL,
  ...
)
}
\arguments{
\item{bucket}{Character string with the name of the bucket, or an object of class \dQuote{s3_bucket}.}

\item{prefix}{Character string that limits the response to keys that begin with the specified prefix}

\item{delimiter}{Character string used to group keys.  Read the AWS doc for more detail.}

\item{max}{Integer indicating the maximum number of keys to return. The function will recursively access the bucket in case \code{max > 1000}. Use \code{max = Inf} to retrieve all objects.}

\item{marker}{Character string that pecifies the key to start with when listing objects in a bucket. Amazon S3 returns object keys in alphabetical order,  starting with key after the marker in order.}

\item{parse_response}{logical, should we attempt to parse the response?}

\item{\dots}{Additional arguments passed to \code{\link{s3HTTP}}.}
}
\value{
\code{get_bucket} returns a list of objects in the bucket (with class \dQuote{s3_bucket}), while \code{get_bucket_df} returns a data frame (the only difference is the application of the \code{as.data.frame()} method to the list of bucket contents. If \code{max} is greater than 1000, multiple API requests are executed and the attributes attached to the response object reflect only the final request.
}
\description{
List the contents of an S3 bucket as either a list or data frame
}
\details{
From the AWS doc: \dQuote{This implementation of the GET operation returns some or all (up to 1000) of the objects in a bucket. You can use the request parameters as selection criteria to return a subset of the objects in a bucket.} The \code{max} and \code{marker} arguments can be used to retrieve additional pages of results. Values from a call are store as attributes
}
\examples{
\dontrun{
  # basic usage
  b <- bucketlist()
  get_bucket(b[1,1])
  get_bucket_df(b[1,1])

  # bucket names with dots
  ## this (default) should work:
  get_bucket("this.bucket.has.dots", url_style = "path")
  ## this probably wont:
  #get_bucket("this.bucket.has.dots", url_style = "virtual")
}

}
\references{
\href{https://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketGET.html}{API Documentation}
}
\seealso{
\code{\link{bucketlist}}, \code{\link{get_object}}
}
