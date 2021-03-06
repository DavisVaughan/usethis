context("use_roxygen_md")

test_that("use_roxygen_md() adds DESCRIPTION fields to naive package", {
  skip_if_not_installed("roxygen2")
  pkg <- scoped_temporary_package()
  use_roxygen_md()
  expect_identical(
    desc::desc_get("Roxygen", pkg),
    c(Roxygen = "list(markdown = TRUE)")
  )
  expect_true(desc::desc_has_fields("RoxygenNote", pkg))
  expect_true(uses_roxygen_md())
})
