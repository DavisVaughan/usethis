## attempt to activate a project, which is nice during development
tryCatch(proj_set("."), error = function(e) NULL)

## If session temp directory appears to be, or be within, a project, there
## will be large scale, spurious test failures.
## The IDE sometimes leaves .Rproj files behind in session temp directory or
## one of its parents.
## Delete such files manually.
session_temp_proj <- proj_find(path_temp())
if (!is.null(session_temp_proj)) {
  Rproj_files <- fs::dir_ls(session_temp_proj, glob = "*.Rproj")
  ui_line(c(
    "Rproj file(s) found at or above session temp dir:",
    paste0("* ", Rproj_files),
    "Expect this to cause spurious test failures."
  ))
}

scoped_temporary_package <- function(dir = file_temp(pattern = "testpkg"),
                                     env = parent.frame(),
                                     rstudio = FALSE) {
  scoped_temporary_thing(dir, env, rstudio, "package")
}

scoped_temporary_project <- function(dir = file_temp(pattern = "testproj"),
                                     env = parent.frame(),
                                     rstudio = FALSE) {
  scoped_temporary_thing(dir, env, rstudio, "project")
}

scoped_temporary_thing <- function(dir = file_temp(pattern = pattern),
                                   env = parent.frame(),
                                   rstudio = FALSE,
                                   thing = c("package", "project")) {
  thing <- match.arg(thing)
  if (fs::dir_exists(dir)) {
    ui_stop("Target {ui_code('dir')} {ui_path(dir)} already exists.")
  }

  old_project <- proj_get_()
  ## Can't schedule a deferred project reset if calling this from the R
  ## console, which is useful when developing tests
  if (identical(env, globalenv())) {
    ui_done("Switching to a temporary project!")
    if (!is.null(old_project)) {
      command <- paste0('proj_set(\"', old_project, '\")')
      ui_todo(
        "Restore current project with: {ui_code(command)}"
      )
    }
  } else {
    withr::defer({
      ui_silence({
        proj_set(old_project, force = TRUE)
      })
      setwd(old_project)
      fs::dir_delete(dir)
    }, envir = env)
  }

  ui_silence({
    switch(thing,
      package = create_package(dir, rstudio = rstudio, open = FALSE, check_name = FALSE),
      project = create_project(dir, rstudio = rstudio, open = FALSE)
    )
    proj_set(dir)
  })
  setwd(dir)
  invisible(dir)
}

toggle_rlang_interactive <- function() {
  before <- getOption("rlang_interactive")
  after <- if (identical(before, FALSE)) TRUE else FALSE
  options(rlang_interactive = after)
  ui_line(glue::glue("rlang_interactive: {before %||% '<unset>'} --> {after}"))
  invisible()
}

skip_if_not_ci <- function() {
  ci_providers <- c("GITHUB_ACTIONS", "TRAVIS", "APPVEYOR")
  ci <- any(toupper(Sys.getenv(ci_providers)) == "TRUE")
  if (ci) {
    return(invisible(TRUE))
  }
  skip("Not on GitHub Actions, Travis, or Appveyor")
}

skip_if_no_git_user <- function() {
  cfg <- git2r::config()
  user_name <- cfg$local$`user.name` %||% cfg$global$`user.name`
  user_email <- cfg$local$`user.email` %||% cfg$global$`user.email`
  user_name_exists <- !is.null(user_name)
  user_email_exists <- !is.null(user_email)
  if (user_name_exists && user_email_exists) {
    return(invisible(TRUE))
  }
  skip("No Git user configured")
}

expect_usethis_error <- function(...) {
  expect_error(..., class = "usethis_error")
}

expect_error_free <- function(...) {
  expect_error(..., regexp = NA)
}

is_build_ignored <- function(pattern, ..., base_path = proj_get()) {
  lines <- read_utf8(path(base_path, ".Rbuildignore"))
  length(grep(pattern, x = lines, fixed = TRUE, ...)) > 0
}

test_file <- function(fname) testthat::test_path("ref", fname)

expect_proj_file <- function(...) expect_true(file_exists(proj_path(...)))
expect_proj_dir <- function(...) expect_true(dir_exists(proj_path(...)))
