
# Install the required Packages
install.packages("ggplot2")
install.packages("reshape2")
install.packages("pheatmap")
install.packages("naniar")
install.packages("missRanger")
install.packages("mice")
install.packages("visdat")

library(ggplot2)
library(reshape2)

#Load the data 
d1 <- read.csv("C:/Users/ROHIT/Downloads/countdata5.csv")
d2 <- read.csv("C:/Users/ROHIT/Downloads/countdata10.csv")
d3 <- read.csv("C:/Users/ROHIT/Downloads/countdata30.csv")

# Checking Data Structure and summary

# For 5% Dataset
str(d1)
head(d1)
summary(d1)

# For 10% Dataset
str(d2)
head(d2)
summary(d2)

# For 30% Dataset
str(d3)
head(d3)
summary(d3)

# Checking missing data patterns in each dataset
missing_values<- data.frame(
  Dataset = c("d1", "d2", "d3"),
  Missing_values <- c(sum(is.na(d1)), sum(is.na(d2)), sum(is.na(d3)))
)
# Print result
print(missing_values)

# Visualizing the missing data
# Create Label Vectors
column_labels <- paste0("Identifiers", 1:39)
row_labels <- paste0("Genome", 1:nrow(d1))

column_labels2 <- paste0("Identifiers2", 1:39)
row_labels2 <- paste0("Genome2", 1:nrow(d2))

column_labels3 <- paste0("Identifiers3", 1:39)
row_labels3 <- paste0("Genome3", 1:nrow(d3))


# Convert Data to Long Format
d1_long <- melt(as.matrix(d1))
names(d1_long) <- c("Genome", "Identifiers", "Value")

d2_long <- melt(as.matrix(d2))
names(d2_long) <- c("Genome2", "Identifiers2", "Value2")

d3_long <- melt(as.matrix(d3))
names(d3_long) <- c("Genome3", "Identifiers3", "Value3")
#transforming to long format helps with easy grouping and plotting of graphs


# Add labels
d1_long$Genome <- row_labels[d1_long$Genome]
d1_long$Identifiers <- column_labels[d1_long$Identifiers]

d2_long$Genome2 <- row_labels2[d2_long$Genome2]
d2_long$Identifiers2 <- column_label3s[d2_long$Identifiers2]

d3_long$Genome3 <- row_labels2[d3_long$Genome3]
d3_long$Identifiers3 <- column_labels3[d3_long$Identifiers3]


# Plotting using ggplot2

#For 5% Dataset
ggplot(d1_long, aes(x = Genome, y = Value, color = Identifiers)) + geom_point() +labs(x = "Genome", y = "Values", color = "Identifiers") +theme(axis.text.x = element_text(angle = 90, hjust = 1)) +scale_x_discrete(labels=row_labels)

#For 10% Dataset
ggplot(d2_long, aes(x = Genome2, y = Value2, color = Identifiers2)) + geom_point() +labs(x = "Genome", y = "Values", color = "Identifiers") +theme(axis.text.x = element_text(angle = 90, hjust = 1)) +scale_x_discrete(labels=row_labels2)

#For 30% Dataset
ggplot(d3_long, aes(x = Genome3, y = Value3, color = Identifiers3)) + geom_point() +labs(x = "Genome", y = "Values", color = "Identifiers") +theme(axis.text.x = element_text(angle = 90, hjust = 1)) +scale_x_discrete(labels=row_labels3)

#Conclusion : Here Genome is used to colour the points based on columns.


# Heatmap to check Correlation between missing data
library(pheatmap)

# Function to convert all columns to numeric, setting non-convertible values to NA
convert_to_numeric <- function(df) {
  df[] <- lapply(df, function(x) as.numeric(as.character(x)))
  return(df)
}

# Apply the conversion function to each dataset
d1_num <- convert_to_numeric(d1)
d2_num <- convert_to_numeric(d2)
d3_num <- convert_to_numeric(d3)

# Calculate the correlation matrices for each dataset
d1_cor <- cor(d1_num, use = "pairwise.complete.obs")
d2_cor <- cor(d2_num, use = "pairwise.complete.obs")
d3_cor <- cor(d3_num, use = "pairwise.complete.obs")

# Replace NA/NaN/Inf values with zeros
d1_cor[is.na(d1_cor)] <- 0
d2_cor[is.na(d2_cor)] <- 0
d3_cor[is.na(d3_cor)] <- 0

# Plot heatmaps for each correlation matrix with additional customization
pheatmap(d1_cor, main = "Correlation Heatmap for Dataset d1",
         color = colorRampPalette(c("blue", "white", "red"))(50), 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean")

pheatmap(d2_cor, main = "Correlation Heatmap for Dataset d2",
         color = colorRampPalette(c("blue", "white", "red"))(50), 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean")

pheatmap(d3_cor, main = "Correlation Heatmap for Dataset d3",
         color = colorRampPalette(c("blue", "white", "red"))(50), 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean")

# Conclusion:
# The heatmaps show that the correlation between variables varies across the three datasets.
# In general, the variables in d1 have the highest correlation, followed by d2 and then d3.
# This suggests that the missing data in each dataset may be affecting the relationships between the variables.



# Checking Data structure and summary for long format

# For 5% Dataset
str(d1_long)
summary(d1_long)

# For 10% Dataset
str(d2_long)
summary(d2_long)

# For 30% Dataset
str(d3_long)
summary(d3_long)           


# Package for analyzing missing data
library(visdat)

# Visual summary of missing data
vis_miss(d1, warn_large_data = FALSE)

vis_miss(d2, warn_large_data = FALSE)

vis_miss(d3, warn_large_data = FALSE)



# Visualizing the Missing Pattern
library(naniar)

# Number of missing values in each variable
#For 5% Dataset
gg_miss_var(d1)

#For 10% Dataset
gg_miss_var(d2)

#For 30% Dataset
gg_miss_var(d3)


# Visualizing using Upset plot
#For 30% Dataset
gg_miss_upset(d1)

#For 30% Dataset
gg_miss_upset(d2)

#For 30% Dataset
gg_miss_upset(d3)
#Conclusion:
#Upset plots provide overview of intersections among the sets.
#High intesection size shows overlap of sets while moderate and low intersections show specific relationships and unique elements.

# Package for exploring missing data pattern
library(mice)

# Exploratory Data Analysis
md.pattern(d1)

md.pattern(d2)

md.pattern(d3)


# Packgae for evaluating the Missing Pattern
library(missRanger)

# Little's MCAR (Missing Completely At Random) test
#For 5% Dataset
mcar_test(d1)

#For 30% Dataset
mcar_test(d2)

#For 30% Dataset
mcar_test(d3)
# Conclusion:
# If the p-value is less than 0.05, we reject the null hypothesis and conclude that the data is not missing completely at random.
# If the p-value is greater than or equal to 0.05, we fail to reject the null hypothesis and cannot conclude that the data is not missing completely at random.

# Based on the results of the MCAR tests, we can conclude that:

# - The data in d1 is not missing completely at random (p-value < 0.05).
# - The data in d2 is missing completely at random (p-value > 0.05).
# - The data in d3 is not missing completely at random (p-value < 0.05).








