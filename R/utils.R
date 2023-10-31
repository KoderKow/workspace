# Colorful symbols
green_check <- "\033[32mv\033[39m"
red_todo <- "\033[31m*\033[39m"
red_x <- "\033[31mx\033[39m"

# Common regex pattern
last_hypen_pattern <- "-(?![^-]*-)"

# Create file names
generate_file_name <- function(note = "") {
  file_name_init <- gsub(
    x = as.character(Sys.time()),
    pattern = " |:",
    replacement = "-",
    perl = TRUE
  )

  file_name <- paste0("_workspace/ws-", file_name_init, "_", note, ".qs")

  return(file_name)
}

map <- function(.x, .f, ...) {
  lapply(.x, .f, ...)
}

map_mold <- function(.x, .f, .mold, ...) {
  out <- vapply(.x, .f, .mold, ..., USE.NAMES = FALSE)
  names(out) <- names(.x)
  out
}

map_chr <- function(.x, .f, ...) {
  map_mold(.x, .f, character(1), ...)
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
    v_check_1 <- length(ignore_content) > 0
    v_check_2 <- ignore_content[length(ignore_content)] == ""

    while (v_check_1 && v_check_2) {
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

# Display file name
meta_cleaner <- function(file_meta) {
  # Replace the last two hyphens with colons
  clean_meta <- sub(last_hypen_pattern, ":", file_meta[1], perl = TRUE)
  clean_meta <- sub(last_hypen_pattern, ":", clean_meta, perl = TRUE)

  # Replace the last hyphen with a space
  clean_meta <- sub(last_hypen_pattern, " ", clean_meta, perl = TRUE)

  # Put the string back together
  # Show the note if it exists
  final_string <- paste0(
    clean_meta,
    ifelse(length(file_meta[-1]) > 0, " | ", ""),
    paste0(file_meta[-1], collapse = "_")
  )

  return(final_string)
}

display_file_name <- function(file_path) {
  # Remove the prefix and suffix
  files_display <- gsub("^_workspace\\/ws-", "", file_path)
  files_display <- gsub("\\.qs$", "", files_display)

  # meta data
  file_meta <- strsplit(files_display, "_", fixed = TRUE)[[1]]

  final_string <- meta_cleaner(file_meta)

  return(final_string)
}
