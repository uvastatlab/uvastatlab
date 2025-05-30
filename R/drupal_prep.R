#' Prepare blog post for UVA StatLab Drupal site
#' @description
#' \code{drupal()} takes an HTML file generated from an R Markdown file in RStudio and makes various changes to the code so it can be copied and pasted into the UVA StatLab Drupal site. This should work for files with both R and Python code chunks.
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
#' @param name author full name in quotes (e.g., "Clay Ford")
#' @param date date in quotes (e.g., "May 30, 2025")
#' @param title title of author in quotes (e.g., "Statistical Research Consultant")
#'
#'
#' @return An HTML file of the same name as the file argument with "Drupal_" prepended. Will be written to the current working directory. Open the file with a text editor and copy and paste contents into a new Drupal post.
#' @export
#'
#' @examples
#' \dontrun{
#' drupal(file = "tweedie.html",
#'        name = "Clay Ford",
#'        date = "May 30, 2025",
#'        title = "Statistical Research Consultant")
#' # Drupal_tweedie.html output to working directory.
#' }
drupal <- function(file, name, date, title) {
  if(!grepl(".(htm|html)$", file)) stop("Function requires HTML file.")

  # TIP: use writeClipboard(p) to review results when debugging (Windows only)

  p <- readLines(file) |>
    paste(collapse = "\n")
  # drop everything before the opening paragraph
  p <- sub(pattern = "<!DOCTYPE html>.+?</div>", replacement = "", p)
  # drop everything at end
  p <- sub(pattern = "<script>.+</html>", replacement = "", p)
  p <- trimws(p)
  # remove final </div> tag
  p <- sub(pattern = "</div>$", "", p) |> stringr::str_trim()

  # opening code block
  p <- gsub(pattern = '<pre class=(\"r\"|\"python\")><code>',
            replacement = '<div class="rds-article--code" aria-label="code">\n<pre>\n<code>\n',
            p)

  # opening output block
  # find <pre><code> at start of line
  p <- gsub(pattern = '\n<pre><code>',
            replacement = '\n<div class="rds-article--output" aria-label="output">\n<pre>\n<code>\n',
            p)

  # closing code and output blocks
  p <- gsub(pattern = '</code></pre>',
            replacement = '\n</code>\n</pre>\n</div>',
            p)

  # add  target="_blank" rel="noopener noreferrer" to links
  # tagging: <a href[^<>]+ is tagged with ()
  # Since it is tagged, it is used in the replacement as \\1 where
  # the attributes are added directly after it
  p <- gsub(pattern = '(<a href=\"[^#][^<>]+)',
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

  # add signature

  sig <- paste0("<hr><p><em>", name,
                "</em><br><em>", title,
                "</em><br><em>University of Virginia Library</em><br><em>",
                date, "</em></p>")

  # check for footnotes
  if(grepl(pattern = "<div class=\"footnotes", x = p, fixed = TRUE)){
    end <- regmatches(p, regexpr(pattern = "<div class=\"footnotes [\\s\\S]*",
                                 text = p, perl = TRUE))
    insert <- paste0(sig, end)
    p <- sub(pattern = "<div class=\"footnotes [\\s\\S]*",
             replacement = insert, x = p, perl = TRUE)

    # if no footnotes, add to end
  } else {
    p <- paste0(p, sig)
  }

  writeLines(p, con = paste0("Drupal_", basename(file)), useBytes = TRUE)
}

