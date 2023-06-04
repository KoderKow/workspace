generate_file_name <- function() {

  folder_name <- ".workspace"

  # Check if the folder exists
  if (!file.exists(folder_name) || !file.info(folder_name)$isdir) {
    dir.create(folder_name)
    cat(sprintf("Folder '%s' created.\n", folder_name))
  }

  # Read the contents of the .gitignore file
  gitignore_file <- ".gitignore"
  gitignore_contents <- readLines(gitignore_file)

  # Check if the folder is already present in the .gitignore file
  if (folder_name %in% gitignore_contents) {
    cat(sprintf("Folder '%s' is already present in .gitignore.", folder_name))
  } else {
    # Append the folder name to the .gitignore file
    append_text <- sprintf("\n%s", folder_name)
    cat(sprintf("Adding folder '%s' to .gitignore...", folder_name))
    write(append_text, file = gitignore_file, append = TRUE)
  }

  # Generate the file name
  v_file_name <-
    Sys.time() %>%
    as.character() %>%
    gsub(
      x = .,
      pattern = " |:",
      replacement = "-",
      perl = TRUE
    ) %>%
    paste0(".workspace/ws-", ., ".qs")

  return(v_file_name)
}
