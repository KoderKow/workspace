workspace_restore <- function(
    file = "latest",
    nthreads = parallel::detectCores() / 2
) {
  # List all files in the folder
  files <- list.files(path = ".workspace", full.names = TRUE)

  if (length(files) == 0) {
    cat("no files. wah wah.")
    return(invisible())
  }

  if (file = "latest") {
    # Get the file with the latest modification date
    v_wanted_file <- files[which.max(file.info(files)$mtime)]

  } else {
    # Get file modification times
    file_info <- file.info(files)
    mod_times <- file_info$mtime

    # Sort the files by modification time
    sorted_files <- files[order(mod_times)]

    # Remove the prefix and suffix
    files_display <- gsub('^\\.workspace\\/ws-', '', sorted_files)
    files_display <- gsub('\\.qs$', '', files_display)

    # Replace the last two hyphens with colons
    files_display <- sub('-(\\d{2})-(\\d{2})$', ':\\1:\\2', files_display)

    # Replace the last hyphen with a space
    files_display <- sub('-(?!.*-)', ' ', files_display, perl = TRUE)

    # Pad each character to a width of 2 and assign to variables with index
    files_to_show_user <- paste0(
      "- ",
      sprintf("%02d", 1:length(files_display)),
      ": ",
      files_display
    )

    cat(files_to_show_user, sep = "\n")

    i <- readline(prompt = "Enter a number corresponding to wanted workspace savepoint from above:")
    v_wanted_file <- sorted_files[as.numeric(i)]
  }

  user_response <- readline(prompt = "Restoring will reset your global environment. Continue? Y/N")

  stopifnot(user_response %in% c("Y", "N"))

  if (user_response == "N") {
    cat("Restore cancelled.")
  }

  rm(list = ls())

  qs::qreadm(
    file = v_wanted_file,
    env = .GlobalEnv,
    nthreads = nthreads
  )

  return(invisible())
}
