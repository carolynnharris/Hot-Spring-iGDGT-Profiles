cat("\014") #clears console
rm(list=ls()) 
graphics.off()

#### load relevant packages ####
library("readxl")
library("tidyverse")
library("gt")

#### load data ####
dat <- read_excel("El Tatio_GDGTs.xlsx")

# Create data frame of neutral pH at different temperatures
temp <- seq(10, 110, by = 1)
pH <- 8 * (temp^2 * 10^(-5)) - (0.0208 * temp) + 7.4692
neutral_line <- data.frame(Temp = temp, pH = pH)


#### PLOTTING CODE STARTS HERE ####
#### Hot spring T vs. pH plot ####
png("Temp_vs_pH.png",
    width = 4, height = 3, units = 'in', res = 300)
par(mfrow=c(1,1),
    mar=c(3,3,2,6),
    mgp = c(3, 0.4, 0)) 
plot(dat$Temp ~ dat$pH,
     las = 1,
     xlim = c(1,10),
     ylim = c(50, 90),
     pch = 21, 
     cex = 1.5,
     col = "deeppink2",
     lwd = 3,
     xlab = "",
     ylab = "",
     xaxt = "n",
     yaxt = "n")
# plot neutral pH line
lines(neutral_line$Temp ~ neutral_line$pH,
      lwd = 2)

# add axes
axis(1, at = c(1,3,5,7,9),
     las = 1,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
axis(2, at = c(seq(50, 90, 10)),
     las = 1,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
title(main = "El Tatio Hot Springs", 
      line = 0.5, 
      cex.main = 1.2,
      outer = F,
      adj = 0.5)
title(xlab = "pH", 
      line = 1.4, 
      cex.lab = 1.3,
      outer = F)
title(ylab = "T °C", 
      line = -1.2, 
      cex.lab = 1.3,
      outer = T)
legend("topright",
       xpd = NA, # plots in outer margin area
       cex = 0.8,
       inset = c(-0.55, -0.05),
       bty = "n",
       legend = c("Neutral pH"),
       col = "black",
       lty = 1,
       lwd = 2)  
dev.off()


#### Ring Index vs. pH with points colored by temp ####
# Define a function to map temp values to colors in 50 to 100 *C range 
color_map <- colorRampPalette(c("blue", "red"))(100 - 50 + 1)

# Add a new column "col_Temp" with the corresponding color hex codes
dat <- transform(dat, 
                  col_Temp = color_map[cut(Temp, breaks = 50, labels = FALSE) + 1])

# make dataframe for scalebar
Temp <- c(seq(50, 100, 10))
col_Temp <- c(rep(NA, length(Temp)))
col_Temp_dat <- as.data.frame(cbind(Temp, col_Temp))
col_Temp_dat <- transform(col_Temp_dat, 
                          col_Temp = color_map[cut(Temp, breaks = 50, labels = FALSE) + 1])

# linear regression
pHvsRI <- lm(dat$Ring_index~dat$pH)
summary(pHvsRI)
anova(pHvsRI)

# Extract the coefficients and R^2 value
coefficients <- coef(pHvsRI)
slope <- round(coefficients[2], 1)
intercept <- round(coefficients[1], 1)
r_squared <- round(summary(pHvsRI)$r.squared, 2)


# figure png
png("RingIndex_vs_pH.png",
    width = 4, height = 3, units = 'in', res = 300)
par(mfrow=c(1,1),
    mar=c(3,3,2,6),
    mgp = c(3, 0.4, 0)) 
plot(dat$Ring_index ~ dat$pH,
     las = 1,
     xlim = c(1,10),
     ylim = c(0,5),
     pch = 16, 
     cex = 2,
     col = dat$col_Temp, # color code points by Temperature
     lwd = 1.5,
     xlab = "",
     ylab = "",
     xaxt = "n",
     yaxt = "n")
abline(pHvsRI,
       lwd = 3)
# aadd regression parameters
equation_text <- paste("RI =", slope, "* pH +", intercept)
r_squared_text <- paste("R^2 =", r_squared)
text(1, 0.6, 
     pos = 4, 
     labels = c(equation_text), 
     col = "black",
     cex = 0.8)
text(1, 0.2, 
     pos = 4, 
     labels = c(r_squared_text), 
     col = "black",
     cex = 0.8)
axis(1, at = c(1,3,5,7,9),
     las = 1,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
axis(2, at = seq(0,5,1),
     las = 1,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
title(main = "Ring Index vs pH", 
      line = 0.5, 
      cex.main = 1.2,
      outer = F,
      adj = 0.5)
title(xlab = "pH", 
      line = 1.4, 
      cex.lab = 1.3,
      outer = F)
title(ylab = "Ring Index", 
      line = -1.2, 
      cex.lab = 1.3,
      outer = T)

legend("topright",
       xpd = NA, # plots in outer margin area
       title = "T °C",
       cex = 0.8,
       inset = c(-0.25, 0.2),
       bty = "n",
       legend = rev(col_Temp_dat$Temp),
       pch = c(15),
       col = rev(col_Temp_dat$col_Temp),
       pt.cex = c(2),
       pt.lwd = c(3))
dev.off()



#### Ring Index vs. temp with points colored by pH ####
# Define a function to map pH values to colors in the range 1 to 10
color_map_pH <- colorRampPalette(c("darkorchid4", "thistle2"))(10 - 1 + 1)

# Add a new column "col_Temp" with the corresponding color hex codes
dat <- transform(dat, 
                  col_pH = color_map_pH[cut(pH, breaks = 9, labels = FALSE) + 1])

# make dataframe for scalebar
pH <- c(seq(1,10,1))
col_pH <- c(rep(NA, length(pH)))
col_pH_dat <- as.data.frame(cbind(pH, col_pH))
col_pH_dat <- transform(col_pH_dat, 
                          col_pH = color_map_pH[cut(pH, breaks = 9, labels = FALSE) + 1])

# linear regression
TempvsRI <- lm(dat$Ring_index~dat$Temp)
summary(TempvsRI)
anova(TempvsRI)

# Extract the coefficients and R^2 value
coefficients <- coef(TempvsRI)
slope <- round(coefficients[2], 2)
intercept <- round(coefficients[1], 2)
r_squared <- round(summary(TempvsRI)$r.squared, 2)


# figure png
png("RingIndex_vs_temp.png",
    width = 4, height = 3, units = 'in', res = 300)
par(mfrow=c(1,1),
    mar=c(3,3,2,6),
    mgp = c(3, 0.4, 0)) 
plot(dat$Ring_index ~ dat$Temp,
     las = 1,
     xlim = c(50,90),
     ylim = c(0,5),
     pch = 16, 
     cex = 2,
     col = dat$col_pH, # color code points by Temperature
     lwd = 1.5,
     xlab = "",
     ylab = "",
     xaxt = "n",
     yaxt = "n")
abline(TempvsRI,
       lwd = 3,
       lty = 2,
       col = "grey70")
equation_text <- paste("RI =", slope, "* T +", intercept)
r_squared_text <- paste("R^2 =", r_squared)
text(50, 0.6, 
     pos = 4, 
     labels = c(equation_text), 
     col = "grey70",
     cex = 0.8)
text(50, 0.2, 
     pos = 4, 
     labels = c(r_squared_text), 
     col = "grey70",
     cex = 0.8)
axis(1, at = seq(50,90,10),
     las = 1,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
axis(2, at = seq(0,5,1),
     las = 1,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
title(main = "Ring Index vs. Temp", 
      line = 0.5, 
      cex.main = 1.2,
      outer = F,
      adj = 0.5)
title(xlab = "T °C", 
      line = 1.4, 
      cex.lab = 1.3,
      outer = F)
title(ylab = "Ring Index", 
      line = -1.2, 
      cex.lab = 1.3,
      outer = T)

# legend("topright",
#        xpd = NA, # plots in outer margin area
#        cex = 0.9,
#        inset = c(-0.34, -0.03),
#        bty = "n",
#        legend = c("dat"),
#        pch = c(16),
#        col = c("black"),
#        pt.cex = c(2),
#        pt.lwd = c(3))
legend("topright",
       xpd = NA, # plots in outer margin area
       title = "pH",
       cex = 0.8,
       inset = c(-0.25, 0),
       bty = "n",
       legend = rev(col_pH_dat$pH),
       pch = c(15),
       col = rev(col_pH_dat$col_pH),
       pt.cex = c(2),
       pt.lwd = c(3))
dev.off()


#### iGDGT relative abundance stacked barplot, ordered by pH ####
# create color pallete for iGDGTs, with 9 breaks (b/c 9 iGDGTs are being plotted)
start_color <- "cyan3"
end_color <- "deeppink2"
GDGT_palette <- colorRampPalette(c(start_color, end_color))(9)

### reshape data into matrix with Site Names as column names and iGDGT rel
# abundances as row names ###
dat <- arrange(dat, pH) # sort by pH
matrix <- dat %>%
  select(Site, iGDGT.0, iGDGT.1, iGDGT.2, iGDGT.3, iGDGT.4, iGDGT.5, iGDGT.6, iGDGT.7, iGDGT.8) %>%
  ungroup() %>%
  column_to_rownames(var = "Site") %>%
  t()

png("iGDGT_Profiles_by_pH.png",
    width = 4.5, height = 3, units = 'in', res = 300)
par(mfrow=c(1,1),
    mar=c(3,4,2,8),
    mgp = c(3, 0.4, 0)) 
barplot(matrix, 
        col = GDGT_palette,
        border = "white",
        space = 0.08,
        las = 1,
        yaxt = "n",
        xaxt = "n",
        xlab = "")
# add in X-axis labels based on pH integer bins
axis(1,
     at = c(0.6, 2.7, 3.8, 6, 7),
     las = 1,
     labels = c("3", "4", "5", "6","7"),
     tck = -0.035,
     cex.axis = 1)
axis(2, at = seq(0, 1, .5),
     las = 1,
     labels = T,
     tck = -0.035,
     cex.axis = 1,
     line = 0)
# add minor Y ticks
axis(2, at = seq(0, 1, .25),
     las = 1,
     labels = F,
     tck = -0.02,
     cex.axis = 0.75,
     line = 0)

title(main = "iGDGT Profiles", 
      line = 0.5, 
      cex.main = 1.2,
      outer = F,
      adj = 0.5)
title(xlab = "pH", 
      line = 1.4, 
      cex.lab = 1.2,
      outer = F)
title(ylab = "Rel. Abundance", 
      line = 1.8, 
      cex.lab = 1.2,
      outer = F)

legend("topright",
       xpd = T, # plots in outer margins
       cex = 1.1,
       inset = c(-0.55, -0.05),
       bty = "n",
       legend = c("iGDGT-8", 
                  "iGDGT-7", 
                  "iGDGT-6", 
                  "iGDGT-5", 
                  "iGDGT-4", 
                  "iGDGT-3", 
                  "iGDGT-2", 
                  "iGDGT-1", 
                  "iGDGT-0"),
       col = rev(GDGT_palette),
       pt.cex = 1.5,
       pch = c(15, 15, 15, 15))
dev.off()

#### iGDGT vs. pH regressions for each iGDGT moietie ####

# Calculate the maximum abundance value among all iGDGT columns
max_abundance <- max(sapply(dat[, paste0("iGDGT.", 0:8)], max))

png("iGDGT_vs_pH_regressions_by_moietie.png",
    width = 10, height = 4, units = 'in', res = 300)  # Adjust width and height as needed
par(mfrow = c(2, 5), 
    mar = c(3.5, 4, 2, 1), 
    mgp = c(2.5, 0.5, 0))


# Loop through each iGDGT lipid column and create a scatterplot
for (i in 0:8) {
  col_name <- paste0("iGDGT.", i)
  plot(dat$pH, dat[[col_name]], 
       main = paste("iGDGT", i), 
       xlab = "", 
       ylab = "Relative Abundance", 
       las = 1,
       pch = 16, 
       col = "cyan3", 
       cex = 2,
       ylim = c(0, max_abundance)) 
  # Add in X-axis title
  title(xlab = "pH", line = 1.5)
  
  # Fit linear regression model
  lm_model <- lm(dat[[col_name]] ~ dat$pH)
  
  # Get R-squared value and p-value
  r_squared <- summary(lm_model)$r.squared
  p_value <- summary(lm_model)$coefficients[2, 4]
  
  # Add regression line with adjusted properties based on p-value
  if (p_value < 0.05) {
    abline(lm_model, col = "black", lwd = 2, lty = 1)
  } else {
    abline(lm_model, col = "grey70", lwd = 2, lty = 2)
  }
  
  # Add R-squared and p-value to plot
  legend("topleft",
         legend = c(paste("R^2 =", round(r_squared, 2)),
                    paste("p =", signif(p_value, digits = 3))),
         col = "black",
         bty = "n",
         cex = 1.2)
}

dev.off()
