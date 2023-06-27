#' runPipeline
#'
#' @param workdir path to location where code can store test files and results
#' @param configfile path to GGIR configuration file.
#' @param datadir path to directory where the accelerometer files to test are stored.
#' @param verbose verbose
#' @param timetag Boolean to indicate whether timestamp should be added to filenames
#' @return Stores the GGIR output based on the configuration file provided and compares
#' it with the previous output stored in the same workdir.
#' @export
#' @import GGIR
#' @import diffdf

runPipeline = function(workdir = c(), datadir = c(), configfile = c(),
                       verbose = TRUE, timetag = TRUE) {

  # Run GGIR
  if (GGIR::isfilelist(datadir) == FALSE) datadir = dir(datadir, full.names = TRUE)
  studyname = format(Sys.time(), format = "%y%m%d_%H%M%S")

  GGIR::GGIR(datadir = datadir,
             outputdir = workdir,
             studyname = studyname,
             configfile = configfile,
             verbose = verbose)

  # Check if there is previous data stored
  files = grep("^output_", dir(workdir), value = TRUE)
  currentDir = files[which(files == paste0("output_", studyname))]
  prevDir = sort(files[-which(files == currentDir)], decreasing = TRUE)[1]

  # if not ever run before, output cannot be compared
  if (is.na(prevDir)) stop("Next time you run this function, you will get a comparison with the output generated here.")

  # Load GGIR results
  currentOutput = prevOutput = list()
  currentFN = dir(file.path(workdir, currentDir, "results"), pattern = "*.csv", full.names = TRUE)
  prevFN = dir(file.path(workdir, prevDir, "results"), pattern = "*.csv", full.names = TRUE)

  if (length(currentFN) != length(prevFN)) {
    stop("Different number of output files were generated, make sure you used the same configfile.")
  } else {
    for (i in 1:length(currentFN)) {
      current = data.table::fread(currentFN[i])
      prev = data.table::fread(prevFN[i])

      # compare prev and current
      outputFN = paste0(workdir, "/diff_in_", basename(basename(currentFN[i])))
      outputFN = gsub(".csv", ".txt", outputFN)
      if (i == 1) {}
      issues = diffdf::diffdf(base = prev, compare = current,
                              suppress_warnings = TRUE,
                              file = outputFN)
      areEqual = !diffdf::diffdf_has_issues(issues)
      if (areEqual == TRUE) file.remove(outputFN)

      cat("\nCheck files",
          paste0("'", basename(currentFN)[i], "are identical:"),
          areEqual)
    }
  }
}
