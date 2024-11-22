
### This file serves as the secondary EDA for our image data. It first reads in the images, then resizes them to make them smaller
### Next a function is used to verify that both images and masks have been resized. Finally, histograms are plotted to compare the image 
### mask pixel intensity makeup of all 499 images and masks. The mask pixels are all binary (either black or white), but are not in 0,1 
### format, so these masks are then converted to this format and verified using an additional function. A final histogram is created using 
### just the mask files to ensure that the distribution only falls on 0 and 1.

setwd("~/Documents/DS 4002/Project 3")

# Install packages
install.packages(c("tiff", "ggplot2", "magick"))
library(tiff)
library(ggplot2)
library(magick)


image_folder <- "~/Documents/DS 4002/Project 3/AMAZON/Training/image" # replace with unique file path
mask_folder <- "~/Documents/DS 4002/Project 3/AMAZON/Training/label" # replace with unique file path

# List files in directory
image_files <- list.files(image_folder, pattern = "\\.tif$", full.names = TRUE) #should be 499 files
mask_files <- list.files(mask_folder, pattern = "\\.tif$", full.names = TRUE) #should be 499 files

images <- lapply(image_files, readTIFF) #reads images to convert to data
masks <- lapply(mask_files, readTIFF) #reads masks to convert to data

# Check the dimensions of the first image and mask
cat("First image dimensions:", dim(images[[1]]), "\n")
cat("First mask dimensions:", dim(masks[[1]]), "\n")



### RESIZE IMAGES ###

resize_image <- function(image_path) {
  img <- image_read(image_path)
  img_resized <- image_resize(img, "255x255")
  image_write(img_resized, image_path)
}

# Apply resizing to all images and masks
lapply(image_files, resize_image)
lapply(mask_files, resize_image)

# Function to check image dimensions
check_image_size <- function(image_path) {
  img <- image_read(image_path)
  dimensions <- image_info(img)
  return(dimensions$width == 255 && dimensions$height == 255)
}

# Check sizes for images
image_results <- sapply(image_files, check_image_size)
mask_results <- sapply(mask_files, check_image_size)

# Print results
cat("Image Sizes:\n")
print(image_results)

cat("\nMask Sizes:\n")
print(mask_results)

# Summary of results
cat("\nSummary:\n")
cat("Images resized correctly:", all(image_results), "\n")
cat("Masks resized correctly:", all(mask_results), "\n")



### EXPLORATORY DATA ANALYSIS ###


# Plot the first image and its corresponding mask

dim(images[[1]])
dim(images[[2]])

par(mfrow = c(2, 2))
plot(as.raster(images[[1]]), main = "First Image")
plot(as.raster(masks[[1]]), main = "First Mask")
plot(as.raster(images[[2]]), main = "Second Image")
plot(as.raster(masks[[2]]), main = "Second Mask")


### FIRST THREE IMAGES AND MASKS ###


# Function to analyze image pixel values
analyze_pixel_values <- function(image) {
  # Convert image to matrix
  pixel_matrix <- as.matrix(image)
  
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
  image_stats <- analyze_pixel_values(images[[i]])
  cat(sprintf("Image %d - Mean: %.2f, Median: %.2f, SD: %.2f\n", 
              i, image_stats$mean, image_stats$median, image_stats$sd))
}

# Plot histograms of pixel values
par(mfrow = c(3, 1))
for (i in 1:3) {
  hist(as.vector(as.matrix(images[[i]])), 
       main = paste("Histogram of Pixel Values for Image", i), 
       xlab = "Pixel Value", 
       breaks = 50, 
       col = "lightblue")
}

# Function to analyze pixel values for masks 
analyze_mask_pixel_values <- function(mask) {
  # Convert mask to matrix
  mask_matrix <- as.matrix(mask)
  
  # Flatten the matrix to a vector
  mask_pixel_values <- as.vector(mask_matrix)
  
  # Calculate statistics
  mean_value <- mean(mask_pixel_values, na.rm = TRUE)
  median_value <- median(mask_pixel_values, na.rm = TRUE)
  sd_value <- sd(mask_pixel_values, na.rm = TRUE)
  
  return(list(mean = mean_value, median = median_value, sd = sd_value))
}

# Analyze pixel values for the first three masks
for (i in 1:3) {
  mask_stats <- analyze_mask_pixel_values(masks[[i]])
  cat(sprintf("Mask %d - Mean: %.2f, Median: %.2f, SD: %.2f\n", 
              i, mask_stats$mean, mask_stats$median, mask_stats$sd))
}

# Plot histograms of mask pixel values
par(mfrow = c(3, 1))
for (i in 1:3) {
  hist(as.vector(as.matrix(masks[[i]])), 
       main = paste("Histogram of Pixel Values for Mask", i), 
       xlab = "Pixel Value", 
       breaks = 50, 
       col = "lightgreen")
}


# Function to check if a mask has binary pixel values
is_binary_mask <- function(mask_file) {
  mask <- readTIFF(mask_file)  # Read the mask
  unique_values <- unique(as.vector(mask))  # Get unique pixel values
  return(all(unique_values %in% c(0, .00392)))  # Check if all values are 0 or 1
}

# List to store results
binary_results <- logical(length(mask_files))

# Check each mask file
for (i in seq_along(mask_files)) {
  binary_results[i] <- is_binary_mask(mask_files[i])
}

# Summary of results
if (all(binary_results)) {
  cat("All masks contain only binary pixel values (0s and 1s).\n")
} else {
  cat("Some masks contain non-binary pixel values.\n")
  non_binary_masks <- mask_files[!binary_results]
  cat("Non-binary masks:", paste(non_binary_masks, collapse = ", "), "\n")
}

# Function to convert mask values to binary
convert_to_binary <- function(mask_file) {
  mask <- readTIFF(mask_file)  # Read the mask
  binary_mask <- ifelse(mask > 0.001, 1, 0)  # Convert values to 0 and 1
  return(binary_mask)
}

# Loop through all mask files and convert them
binary_masks <- lapply(mask_files, convert_to_binary)

# Analyze pixel values for the first three binary masks
for (i in 1:3) {
  binary_mask_stats <- analyze_mask_pixel_values(binary_masks[[i]])
  cat(sprintf("Mask %d - Mean: %.2f, Median: %.2f, SD: %.2f\n", 
              i, binary_mask_stats$mean, binary_mask_stats$median, binary_mask_stats$sd))
}

# Plot histograms of mask pixel values
par(mfrow = c(3, 1))
for (i in 1:3) {
  hist(as.vector(as.matrix(binary_masks[[i]])), 
       main = paste("Histogram of Pixel Values for Mask", i), 
       xlab = "Pixel Value", 
       breaks = 50, 
       col = "lightgreen")
}

