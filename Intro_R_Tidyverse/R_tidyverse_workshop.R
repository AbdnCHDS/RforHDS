########## Introduction to R and the Tidyverse ##########

# Dimitra Blana and Jess Butler, Dec 2019

# Based on online material from Amy Willis, Kiirsti Owen and Amelia McNamara, 
# and the book "R for Data Science" by Hadley Wickham and Garrett Grolemund
# The "R for Data Science" book is available for free online: https://r4ds.had.co.nz/

# Workshop objective: To give you the confidence to find out how to do data analysis in R!

# Specific aims 
# Learn how to:
# 1. load data
# 2. manipulate and summarise data
# 3. make plots



##### R Studio Layout

# Bottom left: "Console" window. This is where you interact with R - type a command and press Enter, 
# and you will see the results. 
# When you close R studio, anything you type in the Console is forgotten. 
# For code you want to run again, use the "Source" window.

# Top left: "Source" window. This is where you type your code and save it as an R script file (like this one), 
# so you can run is as many times as you like.

# Top right: "Environment" window. This shows you the list of all data you have currently available.

# Bottom right: This is where your plots will be displayed. 
# Under the "packages" tab it shows the packagers currently installed and loaded (more on that below).
# The "Help" tab is also quite handy!



##### R as a calculator

# In the Console window below, type: 2+2 and press Enter
# Also try:

2^5
3/10
(3+5)^2
sqrt(4)

# Tip: To run a line (or multiple lines) of code from a script without typing them into the Console, 
# select the line(s) you want to run and press Ctrl+Enter (Command+Enter on a Mac)



##### Objects

# R stores data as objects. You create new objects when you assign a value to them using "<-":

x <- 3  # Check the "Environment" window!

# Tip: use the R studio shortcut Alt+ - (Alt and the minus sign) to easily create the assignment symbol <-

y <- 6
x+y

# Tip: R is case sensitive so if you've defined your object as x, it will not recognise (capital) X. 
# Similarly, the function for square root is sqrt, R will give you an error if you try to use Sqrt.


##### Packages

# Packages extend the functionality of base R
# They are distributed via CRAN: the Comprehensive R Archive Network

# To install a package, use: install.packages("packagename")
# You then need to load it, using library(packagename)

# We will be using a collection of packages called the Tidyverse:

install.packages("tidyverse")
library(tidyverse)

# When you load the tidyverse, you'll see a message about conflicts.
# As there is an (increasingly) large number of packages in R, 
# it is possible to have functions with the same name in more than one package.
# The message tells you that packages dplyr and stats both have a function called filter
# and the one that will be used is the one from dplyr. It is the one that was loaded last.
# If you want to use a function from a particular package, you need to include packagename:: before the name of the function.
# In this example, you can use stats::filter() instead of just filter() to use filter from the stats package.

find("filter") # this shows you the packages a function belongs to, in order of priority



# The tidyverse packages we will be using mostly in this workshop are readr (for reading in data), 
# dplyr (for transforming data) and ggplot2 (for plotting)
# There are many more you can explore later (the book "R for Data Science" mentioned at the top is a good resource).


##### Functions

# When using the Tidyverse, you can call functions in two ways:

sqrt(4) # base R

4 %>%
  sqrt  # "pipe" operator (you can read is as "and then...")

# Tip: use the R Studio shortcut Ctrl + Sft + M to create the pipe operator %>%

# Tip: If you are not sure what a function does, type ?functionname in the Console:
?sqrt

##### Working directory

getwd()  # What does this function do?

# --> Set the working directory to the directory where you have stored this R script (and the csv files):



##### Reading in data

# To read in a comma-separated value (csv) file, use the read_csv function:
fev_data <- read_csv("fev.csv")

# Tip: If you got an error that "fev.csv" does not exist, check that you are working in the correct directory!

# --> How would you use read_csv with the pipe operator?


# Look at the top few rows of the data:
head(fev_data)

# fev_data is a tibble - this is a tidyverse structure similar to a data frame (from base R) 
# but with some differences:
# - default printing is shorter
# - tells you the column types (character, double, etc.)
# - doesn't change the types of inputs


# Tip: if your data is in a Microsoft Excel spreasheet, you will need a different package to read it in, 
# such as readxl. So you'll need:

# install.packages("readxl")
# library(readxl)
# excel_data <- read_xlsx(filename, sheet = 1) #(to read the first sheet)


# --> How would you read in a text file? (Check the cheat sheet!)
# There is a text file in your dataset so you can practice: seizure.txt


# --> Have a look at the "Useful arguments" section of the cheat sheet. 
# Use a few of them when you read in fev.csv and look at the data, is that what you expected?


# --> Apply the summary function to a tibble. What does it do?




##### Operating on data: columnns

# Individual columns are identified using the $ symbol:

head(fev_data$fev)
summary(fev_data$fev)
length(fev_data$fev)

# Other useful functions for tibbles and data frames:
names(fev_data)
dim(fev_data)

# Other useful functions for columns:
max(fev_data$fev)
mean(fev_data$fev)
sd(fev_data$fev)



##### Operating on data: subsets

# To select subsets of the data (not just columns with $) use square brackets:

fev_data$fev[32] # 32nd element of the fev column

fev_data[32,3] # 32nd row, 3rd column

fev_data[32,"age"]  # Same thing, but using the name of the 3rd column - better, as it is more readable and robust

fev_data[32, ] # Everything in the 3rd row

fev_data[32,1:3]

fev_data[32,-5]

fev_data[32,-1:-2]

fev_data[32,c(1,3,5)] #c(1,3,5) is a vector of numbers (c means "combine")

c(1,3,5) %>%
  length

# --> How would you drop the 1st, 3rd and 5th column?




##### Logicals

# Besides numbers and strings of characters, R also stores logicals - TRUE and FALSE

# Example: a new vector with elements that are TRUE if height is above 72 cm and FALSE otherwise:

is_tall <- fev_data$height > 72

# Useful summary command:
table(is_tall)

# Which subjects in fev_data are tall?
fev_data[is_tall, ]



##### Filtering (selecting rows)

fev_data %>%
  filter(height > 72)

fev_data %>%
  filter(age == 6)

fev_data %>%
  filter(age != 20)

fev_data %>%
  filter(age <= 20)


# You can also filter by whether data are not a number (na):
fev_data %>%
  filter(is.na(age))  # opposite: !is.na(age)


# You can combine multiple expressions with Boolean operators: & is "and", | is "or", and ! is "not"

fev_data %>%
  filter(age == 14 & smoke !=0)   # age is 14 and smoker

fev_data %>%
  filter(age < 5 | height < 50)  # either younger than 5 or shorter than 50 cm


# Rules for filtering for categorical data:
# sex == "F" or sex != "F"
# sex %in% c("M","F")



##### Selecting columns

fev_data %>%
  select(fev, height, age)


fev_data %>%
  select(-seqnbr, -subjid)



##### Summarising data

fev_data %>%
  filter(age == 14 & smoke != 0) %>%
  summarise(mean(fev))

# You can name the summary variable:

fev_data %>%
  filter(age == 14 & smoke != 0) %>%
  summarise(my_mean = mean(fev))


fev_data %>%
  filter(age == 14 & smoke != 0) %>%
  summarise(mean(fev), sd(fev))


# To get the average FEV for both smokers and non-smokers we don't need to repeat for smoke==0. 
# We can create a grouping variable:

fev_data %>%
  group_by(smoke)
 
# (Same exact data, it just prints the two groups)

fev_data %>%
  group_by(smoke) %>%
  summarise(mean(fev), sd(fev))

# But what is the size of each group? n() gives us the number of observations in each group:

fev_data %>%
  group_by(smoke) %>%
  summarise(n = n(), mean = mean(fev), sd = sd(fev))


# You can also group by your own variables:

fev_data %>%
  group_by(height < 60) %>%
  summarise(n(), mean(fev))

# A useful function: arrange

fev_data %>%
  group_by(age) %>%
  summarise(n(), mean(fev)) %>%
  arrange(age) # arrange by increasing age


fev_data %>%
  group_by(age) %>%
  summarise(n(), mean(fev)) %>%
  arrange(desc(age)) # arrange by decreasing age


# To sort a particular column:
fev_data$age %>% sort

# To sort unique values in a column:
fev_data$age %>% unique %>% sort

# table() gives you a count of a particular factor or combination of factor levels:
table(fev_data$age)
table(fev_data$age,fev_data$smoke)


# --> Problem 1: Which subjects are male and which are female? (i.e. what does sex == 1 mean?)

# <Insert your code here!>



# --> Problem 2: Why do smokers appear to have better lung function (higher forced expiratory volume - FEV)?

# <Insert your code here!>



# Useful function: rename
fev_data %>%
  rename(ID = subjid)


# Mutate: compute new column
fev_data %>%
  mutate(heightdiff = height - mean(height))


# Remember that to save these changes you need to assign to a new tibble:

new_fev_data <- fev_data %>%
  rename(id = subjid) %>%
  mutate(heightdiff = height - mean(height))




##### Plotting

# The first step to using ggplot is creating a blank canvas:

fev_data %>%
  ggplot(aes(x = age, y = fev))   # aes stands for "aesthetic"



##### Scatterplots

# We add points using geom_point:

fev_data %>%
  ggplot(aes(x = age, y = fev)) +
  geom_point()

# Add limits, labels, title:

fev_data %>%
  ggplot(aes(x = age, y = fev)) +
  geom_point() +
  ylim(0, 7) +
  ylab("Forced exhalation\nvolume (litres)") +
  ggtitle("Distribution of FEV")


# We can change the colour of the points (colour - but you can also use col or color), 
# the shape of the points (shape) and the size in mm (size):

fev_data %>%
  ggplot(aes(x = age, y = fev)) +
  geom_point(size = 0.5, shape = 18, colour = "blue")  # Shape 18 is filled diamond

# Tip: Find out more about ggplot's aesthetic specifications here: 
# https://cran.r-project.org/web/packages/ggplot2/vignettes/ggplot2-specs.html


# To colour by sex or smoking status, we add the variables as aesthetic elements:

fev_data %>%
  mutate(sex = as.character(sex),
         smoke = as.character(smoke)) %>% # change sex and smoke from continuous to categorical variables
  ggplot(aes(x = age, y = fev)) +
  geom_point(aes(colour = sex, size = smoke))


# Add a smooth line fitted to the data:

fev_data %>%
  mutate(sex = as.character(sex),
         smoke = as.character(smoke)) %>%
  ggplot(aes(x = age, y = fev)) +
  geom_point(aes(colour = sex, size = smoke)) +
  geom_smooth()

# One smooth line per sex:

fev_data %>%
  mutate(sex = as.character(sex),
         smoke = as.character(smoke)) %>%
  ggplot(aes(x = age, y = fev)) +
  geom_point(aes(colour = sex, size = smoke)) +
  geom_smooth(aes(colour=sex))

# One smooth line per sex or smoking status:

fev_data %>%
  mutate(sex = as.character(sex),
         smoke = as.character(smoke)) %>%
  ggplot(aes(x = age, y = fev)) +
  geom_point(aes(colour = sex, size = smoke)) +
  geom_smooth(aes(colour=sex, size = smoke))

# or:

fev_data %>%
  mutate(sex = as.character(sex),
         smoke = as.character(smoke)) %>%
  ggplot(aes(x = age, y = fev, colour = sex, size = smoke)) +
  geom_point() +
  geom_smooth()



##### Line plots

fev_average <- fev_data %>%
  group_by(age, smoke) %>%
  summarise(mean(fev))

# This is not quite right:

fev_average %>%
  ggplot(aes(x = age, y = fev_mean)) +
  geom_line(aes(colour = smoke))  # smoke is a continuous numeric variable!


# This is better :)

fev_average %>%
  mutate(smoke = as.character(smoke)) %>%
  ggplot(aes(x = age, y = fev_mean)) +
  geom_line(aes(colour = smoke))



##### Bar plots

# How many subjects smoke?

fev_data %>%
  mutate(smoke = as.character(smoke)) %>%
  ggplot(aes(x = smoke)) + 
  geom_bar()  # by default, the y variable is the count of the x (in this case, number of smokers)

# How many men and how many women smoke / don't smoke?

fev_count <- fev_data %>%
  group_by(sex, smoke) %>%
  summarise(smoke_count = n())

# It might be easier to replace 0 and 1 with meaningful words...

fev_count <- fev_data %>%
  mutate(Smoke = ifelse(smoke == 1, "Smoker", "Non-smoker"),
         Sex = ifelse(sex == 1, "Male", "Female")) %>%
  group_by(Sex, Smoke) %>%
  summarise(Count = n())

fev_count %>%
  ggplot(aes(x = Smoke, y = Count, fill = Sex)) + 
  geom_bar(stat = "identity",     # "identity" allows us to specify a y variable, otherwise it is count (as above)
           position = "dodge") +  # Put bars side-by-side instead of stacked
  scale_fill_brewer(palette="Spectral")

# Tip: Find out much more about colours in ggplot here: http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/



##### Box plots

fev_data %>%
  filter(age < 18 & age > 9) %>%
  mutate(smoke = as.character(smoke),
         age = as.character(age)) %>%
  ggplot(aes(x = age, y = fev, colour = smoke)) +
  geom_boxplot() + 
  theme_bw()



##### Saving plots

ggsave("age_vs_fev.pdf")

# To change the size:
ggsave("age_vs_fev.pdf", width=10, height=5)



##### Case Study: Hip replacement outcomes for men and women in England

# You have a csv file with patient reported outcomes in England (Hip Replacement CCG 1819.csv)
# We are interested in looking at gender differences when it comes to hip replacements. 

# It comes from this NHS Visual Data Challenge: https://www.nuffieldtrust.org.uk/project/nhs-visual-data-challenge
# We want to create a compelling data visualisation about gender health differences. Do you want to help?

# You are welcome to look at any outcome you like in the csv file, here are some suggestions:

# 1. How do the numbers of hip replacement procedures compare between men and women?
# 2. Compare pre- and post-operative 'EQ-5D Index' scores for men and women
# 3. Do patient reported outcomes correlate (visually) with conditions such as stroke, lung disease or diabetes?





# Thank you for taking part in our R workshop!
