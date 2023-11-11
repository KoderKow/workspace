#' Restore the dev environment from a restore point
#'
#' @description
#' This function restores the development environment from a previously created
#' restore point, allowing you to revert your workspace to a previous state.
#'
#' @details
#' The `workspace_restore()` function restores the current development
#' environment from a save state. When using this function two options will be
#' presented:
#'
#' 1. **Latest**
#'     - Selecting the latest restore point issues a warning about resetting the
#'      global environment and asks for confirmation
#'     - Upon confirming, it restores the workspace to the latest restore point
#'     and displays a "Restore complete" message
#' 1. **List out the restore points**
#'     - Selecting to list out the restore points presents a menu with available
#'      restore points
#'         - Including the date and time along with any optional note associated
#'          with each restore point
#'     - Upon selecting a specific restore point, it warns about resetting the
#'     global environment and asks for confirmation
#'     - Upon confirming, it restores the workspace to the chosen restore point
#'     and displays a "Restore complete" message
#'
#' # Restore method
#'
#' There are two ways to restore the environment
#'
#' 1. **Clear**
#'     - Wipe the environment clean and restore the workspace from the wanted
#'     file
#'     - This option is best if you want to reproduce the wanted environment
#'     when it was saved
#' 2. **Merge**
#'     - Combines the current environment/workspace with the wanted file
#'     - There are two merge styles
#'         - 1: **Current environment**: When bringing in the workspace from the
#'          wanted file, it will prioritize the current environments variables
#'          if the same variable is used in both environments
#'         - 2: **Restore point**: When bringing in the workspace from the
#'         wanted file, it will prioritize the restore file's variables if the
#'         same variable is used in both environments
#'
#' @inheritParams workspace_save
#' @family workspace functions
#'
#' @return Nothing.
#' @export
#'
#' @examples
#' \dontrun{
#' # Initiate the restore process
#' workspace_restore()
#' }
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
      "Restore cancelled. There are no files to restore from. Did you run
      'workspace_save()'?",
      symbol = red_x
    )

    return(invisible())
  }

  r <- restore_method(files)

  cat2(
    "Do you want to clear your environment or merge?",
    symbol = red_todo
  )

  cm <- c("Clear", "Merge")
  user_clear_or_merge <- cm[utils::menu(cm)]

  if (user_clear_or_merge == "Clear") {
    cat2(
      "WARNING! Restoring will clear out your current environment and reset your
      global environment to '",
      r$files_display[r$i],
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
    suppressWarnings(rm(list = r$to_remove, envir = .GlobalEnv))

    qs::qreadm(
      file = r$wanted_file,
      env = .GlobalEnv,
      nthreads = n_threads
    )
  } else {
    cat2(
      "When merging do you want to prioritize the current environment or the
      restore point? For more information check the docs; '?workspace_restore'",
      symbol = red_todo
    )

    merge_options <- c("Current environment", "Restore point")
    user_merge_options <- merge_options[utils::menu(merge_options)]

    cat2(
      "Continuing will modify your current workspace environment. Continue?",
      symbol = red_x
    )

    user_response <- utils::menu(c("Yes", "No"))

    if (user_response %in% c(0L, 2L)) {
      cat2(
        "Restore cancelled",
        symbol = red_x
      )

      return(invisible())
    }

    # Save current env as a temp file
    tmp_dir <- withr::local_tempdir()
    tmp_ws <- workspace_save(
      note = "tmp_merge_",
      .dir = tmp_dir
    )

    # Based on the user's selection, load restore point without resetting for
    # "restore point". for "current environment" load the restore point and then
    # load the newly created restore point
    to_keep <- c("wanted_file", "n_threads")
    vars <- ls()
    to_remove <- setdiff(vars, to_keep)
    suppressWarnings(rm(list = to_remove, envir = .GlobalEnv))

    if (user_merge_options == "Current environment") {
      qs::qreadm(
        file = r$wanted_file,
        env = .GlobalEnv,
        nthreads = n_threads
      )

      qs::qreadm(
        file = tmp_ws,
        env = .GlobalEnv,
        nthreads = n_threads
      )
    } else {
      qs::qreadm(
        file = tmp_ws,
        env = .GlobalEnv,
        nthreads = n_threads
      )

      qs::qreadm(
        file = r$wanted_file,
        env = .GlobalEnv,
        nthreads = n_threads
      )
    }
  }

  cat2(
    "Restore complete",
    symbol = green_check
  )

  return(invisible())
}

restore_method <- function(files) {
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

  l_return <- list(
    wanted_file = wanted_file,
    files_display = files_display,
    i = i
  )

  return(l_return)
}
