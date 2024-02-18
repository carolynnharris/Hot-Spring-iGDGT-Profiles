# Hot-Spring-iGDGT-Profiles
Visualize relationship between pH, temperature, and the relative abundance of iGDGT lipids.

# OVERVIEW 
This project provides an R script that creates several visualizations to help analyze the relationship between two environmental factors, temperature and pH, and the distribution of iGDGT lipids in sediment samples. The code is written using hot spring data from the El Tatío Geyser Field in Chile as an example. The sample data includes 7 hot springs; temperature ranges from 60 to 85 °C and pH ranges from 3 to 7. Ring Index is strongly associated with spring pH, but not with spring temperature. The relative abundance of highly ringed iGDGT moieties (e.g. iGDGT >4) increases with increasing acidity (decreasing pH). 

# CONTENTS 
## R script: GDGT Data Viz.R
Script that produces several visualizations of the El Tatio hot spring data. All figures are saved as .pngs to the working directory. Dependencies: The data file 'El Tatio_GDGTs.xlsx' must be in same directory as script, otherwise edit the script to designate the full file path.

## R project: GDGT Data Viz.Rproj
An Rproject file, allowing this script to be easily executed in Rstudio.


## Sample data file: El Tatio_GDGTs.xlsx
Sample data file including environmental metadata (temperature, pH), and iGDGT lipid data (relative abundances of iGDGTs 0 through 8 and Ring Index) for 7 hot springs in the El Tatio Geyser Field in Chile. Hot springs sediments were collected during a field campaign led by William Leavitt in January 2022. iGDGT lipids were extracted from hot spring sediments at Dartmouth College and analyzed at Harvard University. Credit: Wil Leavitt, Carolynn Harris, Olivia Pendas. 

## Figures
### Temp_vs_pH.png
Scatterplot of temperature vs. pH for all hot springs. The solid black line indicates what pH is true neutral at different temperatures. 

### RingIndex_vs_pH.png
Scatterplot of ring index vs. temperature for all hot springs. Data points are color coded based on temperature. A linear regression line is included and the equation and fit (R2) are displayed on the figure. 

### RingIndex_vs_temp.png
Scatterplot of ring index vs. temperature for all hot springs. Data points are color coded based on pH. A linear regression line is included and the equation and fit (R2) are displayed on the figure. Because this relationship is not significant for the sample data, the regression line is shown as a dashed, grey line. 

### iGDGT_Profiles_by_pH.png
Stacked barplot showing the relative abundance of iGDGTs 0 through 8. Each bar represents one hot spring. Springs are arranged in ascending pH. The X-axis indicated pH integer bins.  

### iGDGT_vs_pH_Regressions_by_moietie.png
A figure showing the relative abundance of each iGDGT moietie vs. pH for all 9 iGDGT moieties. The r2 value and p-value of the regressions are displayed on the plot. If p < 0.05, the regression is shown as a solid, black line. If p <= 0.05, the regression is shown as a dashed, grey line.

## Note 
Ring Index (RI) was calculated as the weighted average number of GDGT rings in a sample based on the equation in Schouten et al., 2007. 
#### RI = [%GDGT-1 + 2*(%GDGT-2) + 3*(%GDGT-3) + 4*(%GDGT-4) + 5*(%GDGT-5) + 6*(%GDGT-6) + 7*(%GDGT-7) + 8*(%GDGT-8)]/100
