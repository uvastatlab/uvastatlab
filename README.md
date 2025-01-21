# uvastatlab
Miscellaneous functions for the UVA Library StatLab

Install from GitHub:
`remotes::install_github("uvastatlab/uvastatlab")`

## Set up for package development (Windows)

- install the {devtools} package
- install RTools: [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/)
    * 	Do _not_ select the box for "Edit the system PATH". devtools and RStudio should put RTools on the PATH automatically when it is needed.
    * 	Do select the box for "Save version information to registry". It should be selected by default.
- You can request a "(package) development situation report" `with devtools::dev_sitrep()`. If this function returns no output everything should be ready for package development.

## Adding a function to the package

1. Open uvastatlab R project. (Clone from GitHub)
2. Start a new R script and save to the R folder
3. Write/edit your R function. Call external functions (i.e., anything not from the {base} package) using the package::function() syntax. Make sure the package is listed in the Imports section in the DESCRIPTION file. (See also the Dependencies section below.) DO NOT add packages that come with R, such as {stats} and {graphics} to the DESCRIPTION file. 
4. Run `devtools::load_all()` (Ctrl/Cmd + Shift + L)
5. Run function. Repeat steps 3 – 5 to edit and test your function.
6. Add documentation for function. Put cursor somewhere in function and go to Code > Insert roxygen skeleton. Add title, parameters, example, etc. [This page](https://stuff.mit.edu/afs/athena/software/r/current/RStudio/resources/roxygen_help.html) is a nice quick reference for documentation tags.
7. Run `devtools::document()` (Ctrl/Cmd + Shift + D) and preview documentation (`?function_name`). Edit documentation and run this again as needed to see changes. 
8. Run `devtools::check()` (Ctrl/Cmd + Shift + E)
9. Run `devtools::install()` to install package and restart R (Ctrl/Cmd + Shift + B). Load the package, test the function, review the documentation.

## Dependencies

If a function you're writing requires a function from another package (not including the recommended packages that come with R):

- First, add the function in the DESCRIPTION file under Imports. For example,
```
Imports:
    stringr
```
- Then do one of the following:
	1. Call the function using the `package::function()` syntax, or
	2. Add function to the Roxygen documentation using @importFrom. For example, to import `str_extract()` from the {stringr} package:
`@importFrom stringr str_extract`

You can also do the following to have it added automatically: `usethis::use_import_from("stringr", "str_extract")`

- You can also import an entire package into your namespace using @import (example: `@import dplyr`) but that increases the chance of function name conflicts. The R packages book says, "save this for very special situations."
Source: <https://r-pkgs.org/dependencies-in-practice.html#sec-dependencies-in-imports-r-code>


## Adding a data set to the package

- Package data goes in data/. Each file in this directory should be an .rda file created by `save()` containing a single R object, with the same name as the file. The easiest way to achieve this is to use `usethis::use_data()`. Example:
````
my_pkg_data <- sample(1000)
usethis::use_data(my_pkg_data)
````
- The snippet above creates data/my_pkg_data.rda inside the source of the pkg package and adds `LazyData: true` in the DESCRIPTION (if not already there). If the DESCRIPTION contains `LazyData: true`, then datasets will be lazily loaded. This means that they won’t occupy any memory until you use them. 
- Code to prep data should be stored in one or more .R files below data-raw/. `usethis::use_data_raw()` creates the data-raw/ folder and lists it in .Rbuildignore. (This has already been done.) A typical script in data-raw/ includes code to prepare a dataset and ends with a call to `usethis::use_data()`. See the wheat.R script as an example.
- Documenting dataset: use Roxygen template in the data.R file below R/. The "R code" is the name of the data set in quotes. See https://r-pkgs.org/data.html#sec-documenting-data for an example. Multiple data sets can be listed in the data.R file. Run `devtools::document()` to preview help page.


## Resources

- https://r-pkgs.org/ (online book)
- https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/ (blog post)
- https://kbroman.org/pkg_primer/ (Karl Broman's package primer)
- Review packages on GitHub
- Download "package source" from package’s CRAN page. It's a tar.gz file that needs to be unzipped/extracted. [7-zip](https://www.7-zip.org/) is good for this.

## Miscellaneous

- Use `@noRd` in roxygen skeleton to suppress creation of an .Rd file. Useful for removing a function from the documentation menu but not actually deleting from the package.
- Call `usethis::use_citation()` to initiate a citation entry for a package: https://r-pkgs.org/misc.html#sec-misc-inst-citation
- Adding `Roxygen: list(markdown = TRUE)` to your DESCRIPTION file allows you to use markdown syntax in the roxygen comments.


