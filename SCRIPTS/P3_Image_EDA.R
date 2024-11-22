# DS 4002 - Project 3 Image Classification
# The following script encompasses the code for exploratory data analysis 
# with our training data (both images and labels). This allows us to better 
# understand how our image data appears and is structured, in order to then 
# preprocess the images for our convolutional neural networks model. The image data
# consists of tiff files of satellite images of the Amazon. 

# Downloading the required packages ----------------
# if package not yet installed, first run code: install.packages('package name')
# then load using library function below
library(raster)
library(tidyverse)
library(tiff)

# Importing image data -----------------------------
# (replace file path with your own path to folder location of Training folder)
pathloc = '/Users/risgu/Desktop/DS 4002/AMAZON/AMAZON/Training/'

# creating a list of images
folder_list <- list.files(pathloc)
folder_list # output is the two folders stored in training: images, labels

# accessing tiff data within each folder
folder_path<-paste0(pathloc, folder_list, '/')

# Using tidyverse package 
file_name <- map(folder_path, 
                 function(x) paste0(x, list.files(x))) %>% 
  unlist()
head(file_name) # output of paths with file names

# How many images do we have in our training data?
length(file_name) # output = 998

# Randomly visualizing 6 images from the data ------
set.seed(33) # Randomly select image
sample_image <- sample(file_name, 6)
img<-map(sample_image, readTIFF) # load image into R, using tiff package for readTiff

# Visualizing all 6 images in the console - requires resizing margins 
# partitioning plot console
par(mfrow=c(2,3), mar=c(1,1,1,1))
#loop through and plot each image 
for (i in seq_along(img)) {
  if(!is.null(img[[i]])) {
    plot(as.raster(img[[i]]))
  }
}
# Images can be read in order of left to right, starting from the top: 1, 2, 3,
# and bottom row: 4, 5, 6

# Understanding the structure of the images -------
str(img)

# output for images 1 and 2 and interpretation: 
# $ : num [1:512, 1:512] 0.00392 0.00392 0.00392 0.00392 0.00392 ...
# $ : num [1:512, 1:512, 1:4] 0.0034 0.00537 0.00749 0.00865 0.00821 ...
# Image 1 is a 512x512 matrix, with each value representing pixel intensity for a
# grayscale image. This is a label, which we can confirm by looking at the 
# file locations in sample_image.
# Image 2 is also a 512x512 matrix, but with 4 channels (red green blue alpha)
# and wider range of pixel intensities. This image is from the image file. 

# Visualizing pixel values ------------------------
# Function to analyze pixel values from above images 
analyze_pixel_values <- function(img) {
  # Convert image to matrix
  pixel_matrix <- as.matrix(img)
  # Flatten the matrix to a vector
  pixel_values <- as.vector(pixel_matrix)
  # Calculate statistics
  mean_value <- mean(pixel_values, na.rm = TRUE)
  median_value <- median(pixel_values, na.rm = TRUE)
  sd_value <- sd(pixel_values, na.rm = TRUE)
  
  return(list(mean = mean_value, median = median_value, sd = sd_value))
}

# Analyze pixel values for the first three images
for (i in 1:3) {
  image_stats <- analyze_pixel_values(img[[i]])
  cat(sprintf("Image %d - Mean: %.2f, Median: %.2f, SD: %.2f\n", 
              i, image_stats$mean, image_stats$median, image_stats$sd))
}

# Plot histograms of pixel values
par(mfrow = c(3, 1))
for (i in 1:3) {
  hist(as.vector(as.matrix(img[[i]])), 
       main = paste("Histogram of Pixel Values for Image", i), 
       xlab = "Pixel Value", 
       breaks = 50, 
       col = "lightblue")
}

# For additional EDA looking at pixel values, refer to the secondary EDA R Script
# found in the scripts folder.
