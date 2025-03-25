#' Get StatLab Article Metadata
#'
#' Collects the article names, authors, links, and tags of all currently published \href{https://library.virginia.edu/data/articles}{StatLab articles}. Function written in 2025 for StatLab website built on drupal.
#'
#' @return A data frame of article names, authors, links, and tags.
#' @author Ethan Kadiyala
#'
#' @export
#'
#'
#' @examples
#' \dontrun{d <- get_statlab_article_metadata()}
get_statlab_article_metadata <- function() {
  start <- Sys.time()

  query <- 'https://library.virginia.edu/data/articles?page=0' # first page

  pg <- rvest::read_html(query)   # read page to extract final page number

  # get final page, extract hyperlink references
  links <- pg |> rvest::html_elements('a') |> rvest::html_attr('href')
  # find links containing '?page='
  page_links <- links[stringr::str_detect(links, '\\?page=')]
  # extract the numbers from the '?page=' pattern
  page_numbers <- stringr::str_extract(page_links, '(?<=\\?page=)\\d+') |> as.numeric()
  # get the last page number
  last_page <- max(page_numbers, na.rm = TRUE)

  # create output to append all page information to
  out <- data.frame(title = rep(NA, times = 0),
                    author = rep(NA, times = 0),
                    links = rep(NA, times = 0),
                    tags = rep(NA, times = 0))

  # loop through all pages
  current_pg <- 0 # page numbers start at 0
  while (current_pg <= last_page) {

    pg <- rvest::read_html(query)   # read page

    # extract hyperlink references
    links <- pg |> rvest::html_elements('a') |> rvest::html_attr('href')

    # get article links
    article_links <- links[stringr::str_detect(links, '/data/article') &  # extract all articles on page
                             !stringr::str_detect(links, 'https')] # excluding articles linked in the article preview

    # extract articles
    articles <- pg |>
      rvest::html_elements('.views-row') |>   # extracts article titles, snippets, and tags
      rvest::html_text2() |>                  # convert to string
      stringr::str_split(pattern = '\n')      # split by line breaks

    # loop through articles and extract titles, tags, and authors
    sub_out <- data.frame(title = rep(NA, times = length(articles)),
                          author = NA,
                          links = NA,
                          tags = NA)

    for (i in 1:length(articles)) {

      a <- articles[[i]]   # iterate through articles

      title <- a[[1]]   # extract title

      all_tags <- a[[length(a)]] |> stringr::str_split(pattern = ',') |> unlist() # extract tags and split by commas

      author <- all_tags[length(all_tags)]   # extract article authors

      link <- paste(c('https://library.virginia.edu', article_links[i]), collapse = '')

      tags <- all_tags[1:(length(all_tags)-1)] |> paste(collapse = ', ')   # extract article tags

      sub_out[i,] <- list(title, author, link, tags)   # append to df
    }
    # append to output
    out <- rbind(out, sub_out)
    # update
    query <- stringi::stri_replace(query, regex = '\\d+$', replacement = current_pg + 1)

    cat('\nCurrent page:', current_pg)

    current_pg <- current_pg + 1
  }

  end <- Sys.time()
  cat('\nRetrieving data took:', end - start, 'seconds.\n')
  out
}
