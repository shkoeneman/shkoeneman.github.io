#Script to automatically build website and then push it to Github

#####################
### Build Website ###
#####################

#Load libraries
library(rmarkdown)

#Set working directory
setwd("C:/Users/shkan/OneDrive/Documents/Personal/MC_Group_Pick/shkoeneman.github.io")

#Load the project
renv::load(project = "C:/Users/shkan/OneDrive/Documents/Personal/MC_Group_Pick/shkoeneman.github.io")

#Render the website
#Also set some system environment variables we will need
Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/quarto/bin/tools")
rmarkdown::render_site()



