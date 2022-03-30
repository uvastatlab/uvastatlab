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
#'
#' @return An HTML file of the same name as the file argument with "WP_" prepended. Will be written to the current working directory. Open the file with a text editor and copy and paste contents into a new WordPress post.
#' @export
#'
#' @examples
#' \dontrun{
#' wp("somefile.html")
#' # WP_somefile.html output to working directory.
#' }
wp <- function(file) {
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
  # /(<a href[^<>]+)>/is', '\\1 target="_blank"
  p <- gsub(pattern = '(<a href[^<>]+)',
            replacement = '\\1 target=\"_blank\" rel=\"noopener noreferrer\"',
            p, perl = TRUE)

  # add image placeholders
  pattern <- '<p><img src=.+((?<=/)[^/]+\\.(png|jpg))\\".+</p>'
  replacement <- "\n\n\n*** IMAGE PLACEHOLDER: \\1 ***\n\n\n"
  p <- gsub(pattern = pattern, replacement = replacement, p, perl = TRUE)

  # TO DO:add footer
  writeLines(p, con = paste0("WP_", basename(file)))
}

