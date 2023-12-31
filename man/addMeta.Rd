% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meta.R
\name{meta}
\alias{meta}
\alias{meta<-}
\alias{addMeta}
\title{addMeta
Add or change meta information for a cwl recipe.}
\usage{
meta(cwl)

meta(cwl) <- value

addMeta(
  cwl,
  label = character(),
  doc = character(),
  inputLabels = character(),
  inputDocs = character(),
  outputLabels = character(),
  outputDocs = character(),
  stepLabels = character(),
  stepDocs = character(),
  extensions = list()
)
}
\arguments{
\item{cwl}{`cwlProcess` object for data or tool
recipe. `cwlWorkflow` object for a pipeline recipe.}

\item{value}{A list of meta information to add to `cwl`.}

\item{label}{Character string specifying a label for the
recipe. E.g., "bwa align", "gencode annotation".}

\item{doc}{Character string describing the recipe. E.g,
"Align reads to reference genome".}

\item{inputLabels}{Vector of character string, specifying labels
for each input parameter.}

\item{inputDocs}{Vector of character string as descriptions for
each input parameter.}

\item{outputLabels}{Vector of character string, specifying labels
for each output parameter.}

\item{outputDocs}{Vector of character string as descriptions for
each output parameter.}

\item{stepLabels}{Vector of character string, specifying labels for
each step. Use only if `cwl` is a `cwlWorkflow` object.}

\item{stepDocs}{Vector of character string as description for each
step. Use only if `cwl` is a `cwlWorkflow` object.}

\item{extensions}{A list of character strings. Can be used to add
meta information about the recipe. Generally, add fields of
information that does not require execution as part of the
recipe evaluation. for information about "author", "url",
"date", "example", use the exact names as list names as shown
in examples, so that they can be correctly passed into
corresponding fields in markdown file when using
`meta2md`. Other information can be added as a list element
with arbitrary names.}
}
\value{
`meta()`: return a list of all available meta information
    for the `cwl` object.

`addMeta()`: `cwlProcess` or `cwlWorkflow` object, with added meta
    information, which can be returned using `meta(cwl)`. Meta
    information can be converted into markdown file with `meta2md`
    function.
}
\description{
addMeta
Add or change meta information for a cwl recipe.
}
\examples{
\dontrun{
library(RcwlPipelines)
cwlSearch(c("bwa", "align"))
bwaAlign <- RcwlPipelines::cwlLoad("pl_bwaAlign")
bwaAlign <- addMeta(
  cwl = bwaAlign,
  label = "align",
  doc = "align reads to reference genome",
  inputLabels = c("threads", "readgroup", "reference", "read1", "read2"),
  inputDocs = c("number of threads", "read groups",
                "reference genome", "read pair1", "read pair2"),
  outputLabels = c("Bam", "Idx"),
  outputDocs = c("outputbam file", "index file"),
  stepLabels = c(bwa = "bwa"),
  stepDocs = c(bwa = "bwa alignment"))
cat(meta2md(bwaAlign))
}

\dontrun{
rcp <- ReUseData::recipeLoad("gencode_annotation")
meta(rcp)
rcp1 <- addMeta(
  cwl = rcp,
  label = "",
  doc = "An empty description line", 
  inputLabels = c("input label1", "input label2"),
  inputDocs = c("input description 1", "input description 2"), 
  outputLabels = c("output label1"),
  outputDocs = c("output description 1"), 
  extensions = list(
    author = "recipe author's name",
    url = "http://ftp.ebi.ac.uk/pub/databases/gencode/",
    date = as.character(Sys.Date()),
    example = "An example"))
meta(rcp1)
cat(meta2md(rcp1))
}
}
