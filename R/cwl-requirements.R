#' CWL requirements functions

#' @name cwl-requirements
#' @rdname cwl-requirements
#' @description requireDocker: If a workflow component should be run
#'     in a Docker container, this function specifies how to fetch or
#'     build the image.
#' @param docker Character. Specify a Docker image to retrieve using
#'     docker pull.
#' @param Load Character. Specify a HTTP URL from which to download a
#'     Docker image using docker load.
#' @param File Character. Supply the contents of a Dockerfile which will
#'     be built using docker build.
#' @param Import Character. Provide HTTP URL to download and gunzip a
#'     Docker images using `docker import.
#' @param ImageId Character. The image id that will be used for docker
#'     run. May be a human-readable image name or the image identifier
#'     hash. May be skipped if dockerPull is specified, in which case
#'     the dockerPull image id must be used.
#' @param OutputDir Character. Set the designated output directory to a
#'     specific location inside the Docker container.
#' @details More details about `requireDocker`, see:
#'     https://www.commonwl.org/v1.0/CommandLineTool.html#DockerRequirement
#' @return requireDocker: A list of docker requirement to fetch or
#'     build the image.
#' @export

requireDocker <- function(docker = NULL, Load = NULL, File = NULL,
                          Import = NULL, ImageId = NULL,
                          OutputDir = NULL){
    req <- list(class = "DockerRequirement",
                dockerPull = docker,
                dockerLoad = Load,
                dockerFile = File,
                dockerImport = Import,
                dockerImageId = ImageId,
                dockerOutputDirectory = OutputDir)
    req <- req[lengths(req) > 0]
    return(req)
}

#' @rdname cwl-requirements
#' @description requireJS: Indicates that the workflow platform must
#'     support inline Javascript expressions. If this requirement is
#'     not present, the workflow platform must not perform expression
#'     interpolatation.
#' @param expressionLib optional list. Additional code fragments that
#'     will also be inserted before executing the expression
#'     code. Allows for function definitions that may be called from
#'     CWL expressions.
#' @details More details about `requireJS`, see:
#'     https://www.commonwl.org/v1.0/CommandLineTool.html#InlineJavascriptRequirement
#' @return requireJS: A list of inline Javascript requirement.
#' @export

requireJS <- function(expressionLib = list()){
    req <- list(class = "InlineJavascriptRequirement",
                expressionLib = expressionLib)
    req <- req[lengths(req) > 0]
    return(req)
}

#' @rdname cwl-requirements
#' @description requireSoftware: A list of software packages that
#'     should be configured in the environment of the defined process.
#' @param packages The list of software to be configured.
#' @details More details about `requireSoftware`, see:
#'     https://www.commonwl.org/v1.0/CommandLineTool.html#SoftwareRequirement
#' @return requireSoftware: A list of software requirements.
#' @export

requireSoftware <- function(packages = list()){
    req <- list(class = "SoftwareRequirement",
                packages = packages)
    req <- req[lengths(req) > 0]
    return(req)
}

#' @rdname cwl-requirements
#' @description SoftwarePackage from anaconda.
#' @param package The software name.
#' @param source The source of software in anaconda. `bioconda` is
#'     used by default.
#' @param version The version of software.
#' @details More details about `requireSoftware`, see:
#'     https://www.commonwl.org/v1.0/CommandLineTool.html#SoftwarePackage
#' @return A list of software package.
#' @export
condaPackage <- function(package, source="bioconda", version=NULL){
    sp <- list(package = package,
               version = version,
               specs = list(paste0("https://anaconda.org/", source, "/", package)))
    sp <- sp[lengths(sp)>0]
    ## sp <- list(sp)
    ## names(sp) <- package
    return(sp)
}

#' @rdname cwl-requirements
#' @description InitialWorkDirRequirement: Define a list of files and
#'     subdirectories that must be created by the workflow platform in
#'     the designated output directory prior to executing the command
#'     line tool.
#' @param listing The list of files or subdirectories that must be
#'     placed in the designated output directory prior to executing
#'     the command line tool.
#' @details More details about `requireInitialWorkDir`, See:
#'     https://www.commonwl.org/v1.0/CommandLineTool.html#InitialWorkDirRequirement
#' @return requireInitialWorkDir: A list of initial work directory requirements. 
#' @export

requireInitialWorkDir <- function(listing = list()){
    req <- list(class = "InitialWorkDirRequirement",
                listing = listing)
    req <- req[lengths(req) > 0]
    return(req)
}

#' @rdname cwl-requirements
#' @description: Dirent: Define a file or subdirectory that must be
#'     placed in the designated output directory prior to executing
#'     the command line tool. May be the result of executing an
#'     expression, such as building a configuration file from a
#'     template.
#' @param entryname Character or Expression. The name of the file or
#'     subdirectory to create in the output directory. The name of the
#'     file or subdirectory to create in the output directory. If
#'     entry is a File or Directory, the entryname field overrides the
#'     value of basename of the File or Directory object. Optional.
#' @param entry Charactor or expression. Required.
#' @param writable Logical. If true, the file or directory must be
#'     writable by the tool. Changes to the file or directory must be
#'     isolated and not visible by any other CommandLineTool
#'     process. Default is FALSE (files and directories are
#'     read-only). Optional.
#' @details More details about `Dirent`,
#'     See:https://www.commonwl.org/v1.0/CommandLineTool.html#Dirent
#' @return Dirent: A list.
#' @export
#' 
Dirent <- function(entryname = character(), entry,
                   writable = FALSE){
    list(entryname = entryname,
         entry = entry,
         writable = writable)
}

#' @rdname cwl-requirements
#' @description Create manifest for configure files.
#' @param inputID The input ID from corresponding `InputParam`.
#' @param sep The separator of the input files in the manifest config.
#' @export
#' @examples
#' p1 <- InputParam(id = "ifiles", type = "File[]?", position = -1)
#' CAT <- cwlProcess(baseCommand = "cat",
#'        requirements = list(requireDocker("alpine"), requireManifest("ifiles"), requireJS()),
#'        arguments = list("ifiles"),
#'        inputs = InputParamList(p1))
#' 
requireManifest <- function(inputID, sep = "\\n"){
    js <- paste0("${var x='';for(var i=0;i<inputs.", inputID,
                 ".length;i++){x+=inputs.", inputID, "[i].path+'",
                 sep, "'}return(x)}")

    req1 <- requireInitialWorkDir(
        list(Dirent(entryname = inputID,
                    entry = js)))
    return(req1)
}

#' @rdname cwl-requirements
#' @return requireSubworkflow: A SubworkflowFeatureRequirement list.
#' @export
requireSubworkflow <- function(){
    list(class = "SubworkflowFeatureRequirement")
}

#' @rdname cwl-requirements
#' @return rquireScatter: A ScatterFeatureRequirement list.
#' @export
requireScatter <- function(){
    list(class = "ScatterFeatureRequirement")
}

#' @rdname cwl-requirements
#' @return requireMultipleInput: A MultipleInputFeatureRequirement list.
#' @export
requireMultipleInput <- function(){
    list(class = "MultipleInputFeatureRequirement")
}

#' @rdname cwl-requirements
#' @return requireStepInputExpression: A StepInputExpressionRequirement list.
#' @export
requireStepInputExpression <- function(){
    list(class = "StepInputExpressionRequirement")
}

#' @rdname cwl-requirements
#' @param envlist A list of environment variables.
#' @return requireEnvVar: A EnvVarRequirementlist.
#' @export
requireEnvVar <- function(envlist){
    list(class = "EnvVarRequirement",
         envDef = envlist)
}

#' @rdname cwl-requirements
#' @param rscript An R script to run.
#' @return A requirement list with Rscript as manifest entry.
#' @export
requireRscript <- function(rscript){
    rs <- paste0(readLines(rscript), collapse = "\n")
    req1 <- requireInitialWorkDir(
        list(Dirent(entryname = basename(rscript),
                    entry = rs)))
    return(req1)
}

#' @rdname cwl-requirements
#' @param coresMin Minimum reserved number of CPU cores (default is
#'     1).
#' @param coresMax Maximum reserved number of CPU cores.
#' @param ramMin Minimum reserved RAM in mebibytes (2**20) (default is
#'     256).
#' @param ramMax Maximum reserved RAM in mebibytes (2**20)
#' @param tmpdirMin Minimum reserved filesystem based storage for the
#'     designated temporary directory, in mebibytes (2**20) (default
#'     is 1024).
#' @param tmpdirMax Maximum reserved filesystem based storage for the
#'     designated temporary directory, in mebibytes (2**20).
#' @param outdirMin Minimum reserved filesystem based storage for the
#'     designated output directory, in mebibytes (2**20) (default is
#'     1024).
#' @param outdirMax Maximum reserved filesystem based storage for the
#'     designated output directory, in mebibytes (2**20).
#' @return ResourceRequirement: A ResourceRequirement list.
#' @export
requireResource <- function(coresMin = NULL, coresMax = NULL,
                            ramMin = NULL, ramMax = NULL,
                            tmpdirMin = NULL, tmpdirMax = NULL,
                            outdirMin = NULL, outdirMax = NULL){
    req1 <- list(class = "ResourceRequirement",
                 coresMin = coresMin, coresMax = coresMax,
                 ramMin = ramMin, ramMax = ramMax,
                 tmpdirMin = tmpdirMin, tmpdirMax = tmpdirMax,
                 outdirMin = outdirMin, outdirMax = outdirMax)
    .removeEmpty(req1)
}

#' @rdname cwl-requirements
#' @return ShellCommandRequirement: A ShellCommandRequirement list.
#' @export
requireShellCommand <- function(){
    list(class = "ShellCommandRequirement")
}

#' @rdname cwl-requirements
#' @description requireShellScript: create shell script to work dir.
#' @param script Shell script.
#' @return requireShellScript: Initial directory with shell script.
#' @export
requireShellScript <- function(script){
    entry <- Dirent(entryname = "script.sh", entry = script)
    requireInitialWorkDir(listing = list(entry))
}

#' @rdname cwl-requirements
#' @param shell Default shell.
#' @param script script.sh
#' @return baseCommand for shell script
#' @export
ShellScript <- function(shell = "bash", script = "script.sh"){
    c(shell, script)
}

#' @rdname cwl-requirements
#' @description CondaTool: create dockerfile for tools.
#' @param tools A character vector for tools to install by conda.
#' @return CondaTool: Dockerfile
#' @export
CondaTool <- function(tools){
    dockerfile <- paste0("
FROM continuumio/miniconda3

RUN conda config --add channels r
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

RUN conda install -y ", paste(tools, collapse = " "),
"\n")
    return(dockerfile)
}

#' @rdname cwl-requirements
#' @description requireNetwork: Whether a process requires network
#'     access.
#' @param networkAccess TRUE or FALSE.
#' @return requireNetwork: a list of NetworkAccess requirement.
#' @export
requireNetwork <- function(networkAccess = TRUE){
    list(class = "NetworkAccess",
         networkAccess = networkAccess)
}

