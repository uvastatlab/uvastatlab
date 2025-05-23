#' @title Create a ggplot2 theme for StatLab
#'
#' @description This function applies a theme to ggplot2 plots.
#'
#' @param title_face Character. Font for plot title
#' @param title_size Numeric. Font size of title
#' @param axis_color Character. Color for axis text and lines
#' @param background_color Character. Fill color for the plot background
#' @param paper Character. Fill color for panel background
#' @param ink Character. Color for all text elements
#' @param base_family Character. Font family for all text elements
#' @param base_size Numeric. Base font size for text elements
#' @param text_size Numeric. Font size for axis text, legend text, and caption
#' @param base_line_size Numeric. Base line width for plot lines
#' @param base_rect_size Numeric. Border width for rectangular elements
#' @param use_palette Logical. TRUE to use color statlab_palette. Use with 7 groups or less. Default is FALSE.
#' @return A StatLab ggplot2 theme that can be added to a ggplot2 object
#'
#' @seealso
#' - [ggplot2 website](https://ggplot2.tidyverse.org/) - Official ggplot2 documentation
#'
#' @examples
#' library(ggplot2)
#' #create ggplot2
#' p1 <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
#' #add statlab_theme1 to ggplot2
#' p1 + theme_statlab1()
#'
#' @export
theme_statlab1 <- function(title_face = "bold",
                           title_size = 12,
                           axis_color = "black",
                           background_color = "white",
                           paper = "white",
                           ink = "black",
                           base_family = "sans",
                           base_size = 12, #default text
                           text_size = 10,
                           base_line_size = 0.5, #line thickness default
                           base_rect_size = 0.5, #rectangular element thickness
                           use_palette = FALSE) {

  # Define the custom color palette
  statlab_palette <- c("blue4", "darkorange", "goldenrod1", "gray62",
                       "peachpuff", "peru", "slategray2")

  theme <- ggplot2::theme(
    #Base elements
    line = ggplot2::element_line(
      colour = axis_color, linewidth = base_line_size,
      linetype = 1, lineend = "butt"),

    #Rec elements
    rect = ggplot2::element_rect(
      fill = background_color, colour = "#000000",
      linewidth = base_rect_size, linetype = 1),

    #Text elements
    text = ggplot2::element_text(
      family = base_family, #face = title_face,
      colour = ink, size = base_size,
      lineheight = 0.9, hjust = 0.5, vjust = 0.5, angle = 0,
      margin = ggplot2::margin(t = 0, r = 0, b = 0,
                               l = 0, unit = "pt"), # default margin
      debug = FALSE),

    #Axis elements
    axis.title = ggplot2::element_text(size =base_size, face = "plain",
                                       colour = axis_color),
    axis.text = ggplot2::element_text(size = text_size, face = "plain",
                                      colour = axis_color),
    axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = 2)),
    axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = 2)),
    axis.ticks = ggplot2::element_line(colour = axis_color, linewidth = 0.2),
    axis.ticks.length = ggplot2::unit(0.10, "cm"),

    #Legend elements
    legend.background = ggplot2::element_rect(fill = background_color, colour = NA),
    legend.key = ggplot2::element_rect(fill = background_color, colour = NA),
    legend.text = ggplot2::element_text(size = text_size, colour = ink),
    legend.title = ggplot2::element_text(size = base_size, face = title_face, colour = ink),

    #Panel elements (background & border)
    panel.background = ggplot2::element_rect(fill = "white", colour = NA),
    panel.grid.major = ggplot2::element_blank(),  #Remove major grid lines
    panel.grid.minor = ggplot2::element_blank(),  #Remove minor grid lines
    panel.border = ggplot2::element_rect(fill = NA, colour = "black", linewidth = 0.5),  #fine black border

    #Plot elements
    plot.title = ggplot2::element_text(size = title_size, face = title_face, hjust = 0.5),
    plot.background = ggplot2::element_rect(fill = "white", colour = NA),
    plot.caption = ggplot2::element_text(size = text_size, hjust = 1),

    #Spacing & margins
    plot.margin = ggplot2::margin(5, 5, 5, 5)
  )
     # Return theme + palette (if requested)
    if (use_palette) {
      return(list(theme,
                  ggplot2::scale_color_manual(values = statlab_palette),
                  ggplot2::scale_fill_manual(values = statlab_palette)))
    } else {
      return(theme)
    }
  }
