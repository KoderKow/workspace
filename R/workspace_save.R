#' Create a restore point for the current dev environment
#'
#' This function creates a restore point for the current development environment, allowing you to save the state of your workspace for future restoration.
#'
#' @param note Character. Default `""`. An optional note to add to the restore point, providing additional context or information.
#' @param n_threads Integer. Default `2`. The number of threads to use for the saving process.
#' @param is_interactive Logical. Default `interactive()`. This parameter is used for package development purposes only, and it is recommended to avoid changing this setting.
#'
#' @family workspace functions
#'
#' @return Nothing.
#' @export
workspace_save <- function(
  note = "",
  n_threads = 2,
  is_interactive = interactive()
) {
  assert_interactive(is_interactive)
  stopifnot(is.numeric(n_threads))

  folder_name <- "_workspace"

  # Check if the folder exists
  if (!file.exists(folder_name) || !file.info(folder_name)$isdir) {
    dir.create(folder_name)

    # Text file for more information
    text <- "The '_workspace' folder and the 'ws-{date/time}.qs' files are all generated with the R package 'workspace'! https://github.com/KoderKow/workspace for more details."

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

  list_to_save <- lapply(ls(envir = .GlobalEnv), as.symbol)

  if (length(list_to_save) == 0) {
    cat2(
      "Save cancelled. There are no variables in your global environment. Try again after creating some variables",
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

  cat2(
    "Restore point created: '",
    file_name,
    "'",
    symbol = green_check
  )

  return(invisible())
}
