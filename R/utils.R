# Colorful symbols
green_check <- "\033[32mv\033[39m"
red_todo <- "\033[31m*\033[39m"
red_x <- "\033[31mx\033[39m"

# Common regex pattern
last_hypen_pattern <- "-(?![^-]*-)"

# Create file names
generate_file_name <- function() {
  file_name_init <- gsub(
    x = as.character(Sys.time()),
    pattern = " |:",
    replacement = "-",
    perl = TRUE
  )

  file_name <- paste0("_workspace/ws-", file_name_init, ".qs")

  return(file_name)
}

# Custom printing
cat2 <- function(..., symbol = "") {
  cat(
    symbol,
    " ",
    ...,
    "\n",
    sep = ""
  )
}

# Check and update ignore files
ignore_check <- function(file_name) {
  # Check if .gitignore exists
  if (file.exists(file_name)) {
    # Read the .gitignore file
    ignore_content <- readLines(file_name)

    # Remove trailing empty lines
    while (length(ignore_content) > 0 && ignore_content[length(ignore_content)] == "") {
      ignore_content <- ignore_content[-length(ignore_content)]
    }

    # Check if _workspace is already in .gitignore
    if (!any(grepl("\\_workspace", ignore_content))) {
      # Append '_workspace' to the ignore_content
      ignore_content <- c(ignore_content, "_workspace")

      # Write the updated content back to the .gitignore file
      writeLines(ignore_content, file_name)

      cat2(
        "'_workspace' added to '",
        file_name,
        "'",
        symbol = green_check
      )
    }
  }

  return(invisible())
}


# Asserts
assert_interactive <- function(is_interactive) {
  if (!is_interactive) {
    stop("Restore cancelled. This function should only be ran interactively.")
  }
}

# Custom menu for testing
ws_menu <- function(choices, title = NULL) {
  # if (!interactive())
  #   stop("menu() cannot be used non-interactively")
  # if (isTRUE(graphics)) {
  #   if (.Platform$OS.type == "windows" || .Platform$GUI ==
  #       "AQUA" || (capabilities("tcltk") && capabilities("X11") &&
  #                  suppressWarnings(tcltk::.TkUp))) {
  #     res <- select.list(choices, multiple = FALSE, title = title,
  #                        graphics = TRUE)
  #     return(match(res, choices, nomatch = 0L))
  #   }
  # }
  nc <- length(choices)
  if (length(title) && nzchar(title[1L])) {
    cat(title[1L], "\n")
  }
  op <- paste0(format(seq_len(nc)), ": ", choices)
  if (nc > 10L) {
    fop <- format(op)
    nw <- nchar(fop[1L], "w") + 2L
    ncol <- getOption("width") %/% nw
    if (ncol > 1L) {
      op <- paste0(
        fop,
        c(
          rep.int(
            "  ",
            min(nc, ncol) -
              1L
          ),
          "\n"
        ),
        collapse = ""
      )
    }
  }
  cat("", op, "", sep = "\n")
  repeat {
    ind <- .Call(utils:::C_menu, as.character(choices))
    if (ind <= nc) {
      return(ind)
    }
    cat(gettext("Enter an item from the menu, or 0 to exit\n"))
  }
}
