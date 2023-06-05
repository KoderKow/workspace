#' Title
#'
#' @param n_threads
#' @param is_interactive
#'
#' @return
#' @export
#'
#' @examples
workspace_save <- function(
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

  file_name <- generate_file_name()

  list_to_save <- lapply(ls(envir = .GlobalEnv), as.symbol)

  if (length(list_to_save) == 0) {
    cat2(
      "Save cancelled. There are no variables in your global environment. Try again after creating some variables",
      symbol = red_x
    )

    return(invisible())
  }

  do.call(
    what = qs::qsavem,
    args = c(
      list_to_save,
      file = file_name,
      nthreads = n_threads
    )
  )

  return(invisible())
}
