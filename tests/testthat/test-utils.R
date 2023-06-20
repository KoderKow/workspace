# Test for generate_file_name function
test_that("generate_file_name function works correctly", {
  # Generate a file name
  file_name <- generate_file_name()
  file_name <- gsub(".*/(.*/)", "\\1", file_name)

  # The file name should start with "_workspace/ws-" and end with ".qs"
  expect_true(grepl("^_workspace/ws-", file_name))
  expect_true(grepl("\\.qs$", file_name))

  # The middle part of the file name should be a timestamp in the format "YYYY-MM-DD-HH-MM-SS"
  timestamp <- gsub("^_workspace/ws-|\\.qs$", "", file_name)
  expect_true(grepl("^\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}-\\d{2}", timestamp))
})

# Test for cat2 function
test_that("cat2 function works correctly", {
  expect_snapshot(cat2("Hello World!"))
  expect_snapshot(cat2(symbol = green_check, "Hello World!"))
})

# Test for ignore_check function
test_that("ignore_check adds '_workspace' to the .gitignore file when it doesn't exist", {
  withr::with_tempdir(
    code = {
      # Arrange
      file_name <- ".gitignore"

      ignore_content <- c("*.csv", "*.log")

      writeLines(ignore_content, file_name)

      # Act
      ignore_check(file_name)

      # Assert
      updated_ignore_content <- readLines(file_name)
      expect_true(any(grepl("\\_workspace", updated_ignore_content)))
    }
  )
})


# Test for assert_interactive function
test_that("assert_interactive function works correctly", {
  # Test case 1: Check if the function throws an error when is_interactive is TRUE
  is_interactive <- TRUE
  expect_silent(assert_interactive(is_interactive))

  # Test case 2: Check if the function does not throw an error when is_interactive is FALSE
  is_interactive <- FALSE
  expect_error(assert_interactive(is_interactive), "Restore cancelled. This function should only be ran interactively.")
})
