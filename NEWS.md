# workspace 0.1.1

## Enhancement

- Enhanced the restore confirmation message to display detailed information about the desired file [#1](https://github.com/KoderKow/workspace/issues/1)
  - Refactored portions of the code within `workspace_restore()` for modularity
  - Implemented unit tests for the refactored code
- Added a parameter to `workspace_save()` to control where workspace files are saved [#5](https://github.com/KoderKow/workspace/issues/5)
- Added an option while restoring to merge the current workspace with another file's workspace [#9](https://github.com/KoderKow/workspace/issues/9)
- Improved user prompts to show that their environment will be cleared out while restoring

## Feature

- Introduced the ability to utilize the save and restore functions as add-ins [#2](https://github.com/KoderKow/workspace/issues/2)

# workspace 0.1.0

- Added a `NEWS.md` file to track changes to the package
