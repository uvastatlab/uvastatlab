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
3. Write/edit your R function. Call external functions (ie, anything not from the {base} package) using the package::function() syntax.
4. Run `devtools::load_all()` (Ctrl/Cmd + Shift + L)
5. Run function. Repeat steps 3 – 5 to edit and test your function.
6. Add documentation for function. Put cursor somewhere in function and go to Code > Insert roxygen skeleton. Add title, parameters, example, etc. [This page](https://stuff.mit.edu/afs/athena/software/r/current/RStudio/resources/roxygen_help.html) is a nice quick reference for documentation tags.
7. Run `devtools::document()` (Ctrl/Cmd + Shift + D) and preview documentation (`?function_name`). Edit documentation and run this again as needed to see changes. 
8. Run `devtools::check()` (Ctrl/Cmd + Shift + E)
9. Run `devtools::install()` to install package and restart R (Ctrl/Cmd + Shift + B). Load the package, test the function, review the documentation.

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


