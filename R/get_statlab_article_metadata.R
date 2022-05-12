#' Retrieve metadata for all StatLab articles
#'
#' Collects the article names, authors, and tags for all articles published on the StatLab website at a given time.
#'
#' @return A data frame
#'
#' @examples
#' \dontrun{get_statlab_article_metadata()}
#'
#' @export
get_statlab_article_metadata <- function() {
  start <- Sys.time()
  # Initial parameters
  query <- 'https://data.library.virginia.edu/category/statlab-articles/page/1'
  continue <- T
  all_articles <- list()

  # Web scrape
  while (continue == T) {
    # Get the names and tags of the articles on a given page
    pg <- rvest::read_html(query)
    articles <- pg |> rvest::html_elements('article') |> rvest::html_text2()
    article_names <- sapply(articles, function(x) stringi::stri_extract(x, regex = '^.+(?=\\nPosted)'))
    article_tags <- lapply(articles, function(x) sort(unlist(strsplit(stringi::stri_extract(x, regex = '(?<=Tags\\: ).+$'), ', '))))
    names(article_tags) <- article_names
    # Add results to list, suffering through vectorization, as the list is quite small altogether
    all_articles <- append(all_articles, article_tags)
    # Check if process should continue on next page
    current_pg <- as.numeric(stringi::stri_extract(query, regex = '(?<=page\\/)\\d+$'))
    cat('\rCollected page', current_pg)
    query <- stringi::stri_replace(query, regex = '\\d+$', replacement = current_pg + 1)
    continue <- ifelse(httr::status_code(httr::GET(query)) == 200, T, F)
  }

  # Get valid author names
  possible_authors <- rvest::read_html('https://data.library.virginia.edu/rds-staff/') |> rvest::html_elements(css = 'strong') |> rvest::html_text()
  possible_authors <- stringi::stri_replace_all(str = possible_authors, regex = '\\,.+$', replacement = '')
  # Determine each article's author
  each_author <- sapply(all_articles, function(x) x[x %in% possible_authors])
  # Determine non-author tags for each article
  all_articles <- lapply(all_articles, function(x) x[(x %in% possible_authors) == F])
  # Determine max number of non-author tags
  max_tags <- max(sapply(all_articles, length))
  # Structure output
  out <- data.frame(article = names(all_articles), author = each_author, row.names = 1:length(all_articles))
  col_names <- paste0('tag_', 1:max_tags)
  out[col_names] <- NA
  for (i in 1:nrow(out)) {
    out[i, (ncol(out) - max_tags + 1):(ncol(out) - max_tags + length(all_articles[[i]]))] <- all_articles[[i]]
  }

  end <- Sys.time()
  cat('\nRetrieving data took:', end - start, 'seconds.\n')
  out
}
