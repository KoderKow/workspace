#' Restore the dev environment from a restore point
#'
#' This function restores the development environment from a previously created restore point, allowing you to revert your workspace to a previous state.
#'
#' @inheritParams workspace_save
#' @family workspace functions
#'
#' @return Nothing.
#' @export
workspace_restore <- function(
  n_threads = 2,
  is_interactive = interactive()
) {
  assert_interactive(is_interactive)
  stopifnot(is.numeric(n_threads))

  # List all files in the folder
  files <- list.files(
    path = "_workspace",
    full.names = TRUE,
    pattern = "\\.qs$"
  )

  if (length(files) == 0) {
    cat2(
      "Restore cancelled. There are no files to restore from. Did you run 'workspace_save()'?",
      symbol = red_x
    )

    return(invisible())
  }

  cat2(
    "Would you like to use the latest or a specific restore point?",
    symbol = red_todo
  )

  method <- utils::menu(c("Latest", "List out the restore points"))

  if (method == 1) {
    # Get the file with the latest modification date
    wanted_file <- files[which.max(file.info(files)$mtime)]
    i <- 1
    files_display <- display_file_name(wanted_file)
  } else {
    # Get file modification times
    file_info <- file.info(files)
    mod_times <- order(file_info$mtime)

    # Sort the files by modification time
    sorted_files <- files[mod_times]

    # Remove the prefix and suffix
    files_display <- gsub("^_workspace\\/ws-", "", sorted_files)
    files_display <- gsub("\\.qs$", "", files_display)

    # meta data
    file_meta <- strsplit(files_display, "_", fixed = TRUE)

    files_display <-
      file_meta |>
      map_chr(meta_cleaner)

    cat2(
      "Enter a number corresponding to the wanted workspace restore point:",
      symbol = red_todo
    )

    i <- utils::menu(files_display)

    wanted_file <- sorted_files[i]
  }

  cat2(
    "WARNING! Restoring will reset your global environment to '",
    files_display[i],
    "'. Continue?",
    symbol = red_todo
  )

  user_response <- utils::menu(c("Yes", "No"))

  if (user_response %in% c(0L, 2L)) {
    cat2(
      "Restore cancelled",
      symbol = red_x
    )

    return(invisible())
  }

  # Clear all variables except wanted_file and n_threads
  to_keep <- c("wanted_file", "n_threads")
  vars <- ls()
  to_remove <- setdiff(vars, to_keep)
  suppressWarnings(rm(list = to_remove, envir = .GlobalEnv))

  qs::qreadm(
    file = wanted_file,
    env = .GlobalEnv,
    nthreads = n_threads
  )

  cat2(
    "Restore complete",
    symbol = green_check
  )

  return(invisible())
}
