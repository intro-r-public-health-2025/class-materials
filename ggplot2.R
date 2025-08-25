# run this line to load the tidyverse family of packages, including ggplot2
library(tidyverse)

# this will temporarily assign the mpg dataset 
# to the mpg object in our current session
mpg <- ggplot2::mpg

# you can display the first few rows of this data set
head(mpg)

# this will give you more of a spreadsheet view of the data
View(mpg)

# this will make your first plot of the data
mpg_plot <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth(method = "lm", formula = "y ~ x")

# to display the plot, run this line
mpg_plot

# save the plot into an image file (.png)
ggsave("my-first-plot.png", plot = mpg_plot, height = 4, width = 6)


