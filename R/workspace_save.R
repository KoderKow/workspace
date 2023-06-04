workspace_save <- function(nthreads = parallel::detectCores() / 2) {
  v_file_name <- generate_file_name()

  do.call(
    what = qs::qsavem,
    args = c(
      lapply(ls(envir = .GlobalEnv), as.symbol),
      file = v_file_name,
      nthreads = nthreads
    ))

  return(invisible())
}
