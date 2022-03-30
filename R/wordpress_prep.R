#' Prepare blog post for UVA StatLab WordPress site
#' @description
#' \code{wp()} takes an HTML file generated from an R Markdown file in RStudio and makes various changes to the code so it can be copied and pasted into the UVA StatLab WordPress site. This should work for files with both R and Python code chunks.
#'
#' IMPORTANT: The YAML header of the Rmd file should have output set as follows:
#'
#' \preformatted{
#' output:
#'   html_document:
#'     self_contained: no
#'     pandoc_args: ["--wrap=none"]}
#'
#' @param file an HTML file knitted from R Markdown
#' @param name name of blog post author as character string
#'
#' @return An HTML file of the same name as the file argument with "WP_" prepended. Will be written to the current working directory. Open the file with a text editor and copy and paste contents into a new WordPress post.
#' @export
#'
#' @examples
#' \dontrun{
#' wp("somefile.html", name = "Clay Ford")
#' # WP_somefile.html output to working directory.
#' }
wp <- function(file, name) {
  if(!grepl(".(htm|html)$", file)) stop("Function requires HTML file.")

  if(missing(name)) stop("Provide name of author using name argument.")
  if(name == "Clay Ford") name <- '<a href=\"https://data.library.virginia.edu/tag/clay-ford/\">Clay Ford</a>'

  date <- format(Sys.Date(), "%B %d, %Y")

  # Prep html for RDS Wordpress
  # read HTML into single vector
  p <- readLines(file, encoding = "UTF-8") |>
    paste(collapse = "\n")
  # drop everything before the opening paragraph
  p <- sub(pattern = "<!DOCTYPE html>.+?</div>", replacement = "", p)
  # drop everything at end
  p <- sub(pattern = "<script>.+</html>", replacement = "", p)
  p <- trimws(p)
  # remove final </div> tag
  p <- sub(pattern = "</div>$", "", p) |> stringr::str_trim()

  # opening code tags
  p <- gsub(pattern = '<pre class=(\"r\"|\"python\")><code>',
            replacement = '<div style=\"padding-left: 40px; font-size: 80%\"><pre>\n',
            p)

  # closing code tags
  p <- gsub(pattern = '</code></pre>(?!\n<pre><code>)',
            replacement = '\n\n</pre></div>',
            p, perl = TRUE)

  # remove </code></pre>\n<pre><code> before output
  p <- gsub(pattern = '</code></pre>\n<pre><code>',
            replacement = '\n',
            p, perl = TRUE)

  # add  target="_blank" rel="noopener noreferrer" to links
  # tagging: <a href[^<>]+ is tagged with ()
  # Since it is tagged, it is used in the replacement as \\1 where
  # the attributes are added directly after it
  p <- gsub(pattern = '(<a href[^<>]+)',
            replacement = '\\1 target=\"_blank\" rel=\"noopener noreferrer\"',
            p, perl = TRUE)

  # add image placeholders
  # the file name is tagged: ((?<=/)[^/]+\\.(png|jpg))
  # it is used in the replacement as \\1
  pattern <- '<p><img src=.+((?<=/)[^/]+\\.(png|jpg))\\".+</p>'
  replacement <- "\n\n\n*** IMAGE PLACEHOLDER: \\1 ***\n\n\n"
  p <- gsub(pattern = pattern,
            replacement = replacement,
            p, perl = TRUE)

  # add footer
  footer <- paste0('For questions or clarifications regarding this article, contact the UVA Library StatLab: <a href=\"mailto:statlab@virginia.edu\">statlab@virginia.edu</a>\n\n<a href=\"https://data.library.virginia.edu/category/statlab-articles/\">View the entire collection</a> of UVA Library StatLab articles.\n\n<em>', name, '\nStatistical Research Consultant\nUniversity of Virginia Library\n',date,'</em>')
  p <- paste(p, footer, collapse = "\n")

  writeLines(p, con = paste0("WP_", basename(file)))
}

