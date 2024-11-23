# DS4002_Project3

## Software and Platform
### Coding for this project was done in both R studio and Python.
- R Packages: raster, tidyverse, tiff, ggplot2, magick
- Python Packages: tensorflow, keras, numpy, opensv-python, rasterio, glob, os
- Performed in both Windows and Mac.

## Documentation Map
### 1) SCRIPTS - This folder includes our source code for the project with detailed comments outlining the actions being taken to analyze the data and use it for modeling.
- Initial_EDA.R: This file goes through the training data to visualize image and mask data, understand image structure, as well as observe pixel intensity value distribution.
- Secondary EDA.R: This file alsp goes through the training data of both images and masks, analyzing pixel intensity value distribution of both the images and masks more in depth.
- Training_Model.ipynb: This file is code for training a U-Net model for semantic segmentation of forested and non-forested areas using satellite images.
- Visuals (1).ipynb: This file is the same code as Training_Model but also adds in more code to create visuals thate evaluate the model.
- Testing.ipynb: This file uses the testing datset to visualize the predictions against the original test images.

### 2) DATA - This folder holds our raw data, which was also used during analysis. 
- AMAZON (not included in github but to be saved to local device using Data Aquisition Instructions): Initial and final dataset folder containing 3 folders (Test, Training, Validation), of which contain hundreds of GeoTIFF Amazon forest satellite images.
- Data Acquisition Instructions: file describing how to download data from NIH link.
- Data Appendix: PDF file explaining and defining variables within data.
  
### 3) OUTPUT - This folder includes the output of our analysis, including charts and graphs to support or oppose our hypothesis.
- EDA Output.pdf: file including histograms and visualizations from Initial_EDA.R and Secondary EDA.R.
- Modeling Output.pdf: This file includes visuals and metrics of the model. 
  
## Reproducing Results

1. Go to Data Aquisition Instructions file in DATA folder and follow link and instructions to download zip file.
2. Run Initial_EDA.R to perform initial EDA and save output graphs to EDA Output file.
3. Run Secondary EDA.R to perform secondary EDA and save output graphs to EDA Output file.
4. Add the dataset to Google Drive
5. Run Training_Model.ipynb to perform CNN Model analysis on dataset and save table output to Modeling Output file.
6. Run Visuals (1). ipynb to view visuals and graphs of the performance of the model
7. Run Testing.ipynb to compare the model with the original images in the dataset. 


