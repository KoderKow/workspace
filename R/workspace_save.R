#' Create a restore point for the current development environment
#'
#' @description
#' This function creates a restore point for the current development environment
#' , allowing you to save the state of your workspace for future restoration.
#'
#' @details
#' The `workspace_save()` function creates a restore point for the current
#' development environment. If this is the first time the function is executed
#' in a development environment, it performs the following actions:
#'
#' 1. **Create '_workspace' Folder:** It creates a folder named '_workspace' in
#' the current working directory if it doesn't already exist
#' 1. **Ignore '_workspace' in Version Control:** It adds '_workspace' to the
#' '.gitignore' and '.Rbuildignore' files. This ensures that the folder is
#' excluded from version control and building processes
#' 1. **Generate Restore Point File:** It generates a restore point file with a
#' filename following the pattern
#' **'_workspace/ws-YYYY-MM-DD-HH-MM-SS_{OPTIONAL NOTE}.qs'**
#'     - **YYYY-MM-DD-HH-MM-SS** represents the date and time of the restore
#'     point creation
#'     - **{OPTIONAL NOTE}** corresponds to the optional note provided as a
#'     parameter to the function
#' 1. **Output Log Messages:** The function outputs log messages to provide
#' feedback on the execution status of each step
#'     - Log messages starting with a green 'v' indicate successful operations
#'
#' @param note Character. Default `""`. An optional note to add to the restore
#' point, providing additional context or information.
#' @param .dir Character. Default `getOption("workspace.dir", "_workspace")`.
#' Directory path to save workspace files.
#' @param n_threads Integer. Default `2`. The number of threads to use for the
#' saving process.
#' @param is_interactive Logical. Default `interactive()`. This parameter is
#' used for package development purposes only, and it is recommended to avoid
#' changing this setting.
#'
#' @family workspace functions
#'
#' @return File path of the newly created workspace file, invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Default
#' workspace_save()
#'
#' # Add a note
#' workspace_save("lm model")
#' }
workspace_save <- function(
  note = "",
  .dir = getOption("grkstyle.use_tabs", "_workspace"),
  n_threads = 2,
  is_interactive = interactive()
) {
  assert_interactive(is_interactive)
  stopifnot(is.numeric(n_threads))

  folder_name <- "_workspace"

  # Check if the folder exists
  if (!file.exists(.dir) || !file.info(.dir)$isdir) {
    dir.create(.dir)

    # Text file for more information
    text <- "The '_workspace' folder and the 'ws-{date/time}.qs' files are all
    generated with the R package 'workspace'!
    https://github.com/KoderKow/workspace for more details."

    # Write the text to a .txt file
    writeLines(text, "_workspace/info.txt")

    cat2(
      "Created the folder '_workspace' in the current working directory",
      symbol = green_check
    )
  }

  # Ignore folder for git and R packages, if they exist
  ignore_check(".gitignore")
  ignore_check(".Rbuildignore")

  file_name <- generate_file_name(note)

  list_to_save <- lapply(
    ls(envir = .GlobalEnv),
    as.symbol
  )

  if (length(list_to_save) == 0) {
    cat2(
      "Save cancelled. There are no variables in your global environment. Try
      again after creating some variables",
      symbol = red_x
    )

    return(invisible())
  }

  # TODO Move away from do.call
  do.call(
    what = qs::qsavem,
    args = c(
      list_to_save,
      file = file_name,
      nthreads = n_threads
    )
  )

  if (note != "tmp_merge_") {
    cat2(
      "Restore point created: '",
      file_name,
      "'",
      symbol = green_check
    )
  }

  return(invisible(file_name))
}
