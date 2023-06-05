#' Title
#'
#' @param n_threads
#' @param is_interactive
#'
#' @return
#' @export
#'
#' @examples
workspace_restore <- function(
  n_threads = 2,
  is_interactive = interactive()
) {
  assert_interactive(is_interactive)
  stopifnot(is.numeric(n_threads))

  # List all files in the folder
  files <- list.files(path = "_workspace", full.names = TRUE, pattern = "\\.qs$")

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

  method <- ws_menu(c("Latest", "List out the restore points"))

  if (method == 1) {
    # Get the file with the latest modification date
    wanted_file <- files[which.max(file.info(files)$mtime)]
  } else {
    # Get file modification times
    file_info <- file.info(files)
    mod_times <- order(file_info$mtime)

    # Sort the files by modification time
    sorted_files <- files[mod_times]

    # Remove the prefix and suffix
    files_display <- gsub("^_workspace\\/ws-", "", sorted_files)
    files_display <- gsub("\\.qs$", "", files_display)

    # Replace the last two hyphens with colons
    files_display <- sub(last_hypen_pattern, ":", files_display, perl = TRUE)
    files_display <- sub(last_hypen_pattern, ":", files_display, perl = TRUE)

    # Replace the last hyphen with a space
    files_display <- sub(last_hypen_pattern, " ", files_display, perl = TRUE)

    cat2(
      "Enter a number corresponding to the wanted workspace restore point:",
      symbol = red_todo
    )

    i <- ws_menu(files_display)

    wanted_file <- sorted_files[i]
  }

  cat2(
    "WARNING! Restoring will reset your global environment. Continue?",
    symbol = red_todo
  )

  user_response <- ws_menu(c("Yes", "No"))

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
