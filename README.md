# AWS S3 Client Package

**NOTE:** This package was orphaned on CRAN, and thus removed. I have forked the repo with minor changes to the description file to allow others to install.

**aws.s3** is a simple client package for the Amazon Web Services (AWS) Simple Storage Service (S3) REST API. While [other packages](https://github.com/ropensci/webservices#amazon) currently connect R to S3, they do so incompletely (mapping only some of the API endpoints to R) and most implementations rely on the AWS command-line tools, which users may not have installed on their system.

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

A detailed description of how credentials can be specified is provided at: https://github.com/cloudyr/aws.signature/. The easiest way is to simply set environmetn variables on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). Or they can be set within R:

```R
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = "mytoken")
```

To use the package with S3-compatible storage provided by other cloud platforms, set the `AWS_S3_ENDPOINT` environment variable to the appropriate host name. By default, the package uses the AWS endpoint: `s3.amazonaws.com`


## Code Examples

The package can be used to examine publicly accessible S3 buckets and publicly accessible S3 objects without registering an AWS account. If credentials have been generated in the AWS console and made available in R, you can find your available buckets using:

```R
library("aws.s3")
bucketlist()
```

If your credentials are incorrect, this function will return an error. Otherwise, it will return a list of information about the buckets you have access to.

### Buckets

To get a listing of all objects in a public bucket, simply call

```R
get_bucket(bucket = '1000genomes')
```

Amazon maintains a listing of [Public Data Sets](https://aws.amazon.com/datasets) on S3.

To get a listing for all objects in a private bucket, pass your AWS key and secret in as parameters.  (As described above, all functions in **aws.s3** will look for your keys as environment variables by default, greatly simplifying the process of making a s3 request.)

```R
# specify keys in-line
get_bucket(
  bucket = 'my_bucket',
  key = YOUR_AWS_ACCESS_KEY,
  secret = YOUR_AWS_SECRET_ACCESS_KEY
)

# specify keys as environment variables
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey")
get_bucket("my_bucket")
```

S3 can be a bit picky about region specifications. `bucketlist()` will return buckets from all regions, but all other functions require specifying a region. A default of `"us-east-1"` is relied upon if none is specified explicitly and the correct region can't be detected automatically. (Note: using an incorrect region is one of the most common - and hardest to figure out - errors when working with S3.)

### Objects

There are eight main functions that will be useful for working with objects in S3:

 1. `s3read_using()` provides a generic interface for reading from S3 objects using a user-defined function
 2. `s3write_using()` provides a generic interface for writing to S3 objects using a user-defined function
 3. `get_object()` returns a raw vector representation of an S3 object. This might then be parsed in a number of ways, such as `rawToChar()`, `xml2::read_xml()`, `jsonlite::fromJSON()`, and so forth depending on the file format of the object
 4. `save_object()` saves an S3 object to a specified local file
 5. `put_object()` stores a local file into an S3 bucket
 6. `s3save()` saves one or more in-memory R objects to an .Rdata file in S3 (analogously to `save()`). `s3saveRDS()` is an analogue for `saveRDS()`
 7. `s3load()` loads one or more objects into memory from an .Rdata file stored in S3 (analogously to `load()`). `s3readRDS()` is an analogue for `readRDS()`
 8. `s3source()` sources an R script directly from S3

They behave as you would probably expect:

```R
# save an in-memory R object into S3
s3save(mtcars, bucket = "my_bucket", object = "mtcars.Rdata")

# `load()` R objects from the file
s3load("mtcars.Rdata", bucket = "my_bucket")

# get file as raw vector
get_object("mtcars.Rdata", bucket = "my_bucket")
# alternative 'S3 URI' syntax:
get_object("s3://my_bucket/mtcars.Rdata")

# save file locally
save_object("mtcars.Rdata", file = "mtcars.Rdata", bucket = "my_bucket")

# put local file into S3
put_object(file = "mtcars.Rdata", object = "mtcars2.Rdata", bucket = "my_bucket")
```


## Installation

Since this package has been orphaned, it is no longer on CRAN.  Please install directly from here:

```R
if (!require("remotes")) {
    install.packages("remotes")
}
remotes::install_github("dgruenew/aws.s3")
```
