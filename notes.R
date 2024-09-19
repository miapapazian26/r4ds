#notes on r4ds by hadley 
#the tidyverse 
install.packages("tidyverse")
library(tidyverse) #loads to make available to use 
#^these are the core tidyverse packages 
#you can see if updates are available with:
tidyverse_update()
#other packages: 
install.packages(c("arrow", "babynames", "curl", "duckdb", "gapminder", "ggrepel", "ggridges", "ggthemes", "hexbin", "janitor", "Lahman", "leaflet", "maps", "nycflights13", "openxlsx", "palmerpenguins", "repurrrsive", "tidymodels", "writexl"))

#running R code
#functions are displayed in code font and followed by parenthesis.
#other R objects are in code font without parenthesis
#to make it clear which package an object comes from, we can use the package name followed by two colons
dplyr::mutate() #ex. 

#WHOLE GAME 
#overview of the main tools: importing, tidying, transforming, and visualizing data. 

#data visualization 
#ggplot is one of the most elegant and versatile systems for making plots 
#implements the grammar of graphics 
#first, load the tidyverse:
library(tidyverse)
#also load palmerpenguins package which includes the 'penguins' dataset; and load the ggthemes package
library(palmerpenguins)
library(ggthemes)

#we have all these questions relating to relationship between flipper length and body mass in penguins. 
#we can test our answers to these questions using the penguins data frame
palmerpenguins::penguins
#data frame = rectangular collection of variables (in columns) and observations (in rows)

#defining terms
#variable = a quantity, quality, or property that we can measure.
#value = the state of a variable when you measure it.
#observation = set of measurements made under similar conditions. sometimes referred to as a data point. 
#tabular data = set of values, each associated with a variable and an observation.

#type the name of the data frame in the console and R will print a preview of its contents
#note that it says tibble on top of this preview. 
#tibbles are just special data frames 
penguins 
#for an alternative view, to see all variables and first few observations of each variable use: 
glimpse()
#if we are in RStudio, run: opens up an interactive data viewer
View(penguins)
#to learn more, open help page by running 
?penguins

#creating a ggplot
#with ggplot, we begin the plot with the function 'ggplot' defining a plot object that you then add layers to
ggplot(data = penguins) #creates an empty graph that is primed to display the penguins data, but we havent told it how to visualize the data, therefore it is blank. basically an empty canvas. 
#next, we need to tell ggplot() how the information from our data will be visually represented. 
#the mapping argument of the ggplot function defines how varialbes are mapped to visual properties, or aesthetics. 
#mapping is always defined in the aes() function. 
#the x and y arguments of aes() specify which variables to map to the y and x axes. 
#for now, we will only map flipper length to the x aesthetic and body mass to the y aesthetic. 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)
#now we have more structure
#but we have not articulated in our code how to represent the observations. 
#in order to do this we define a geom: the geometrical object that a plot uses to represent data. 
#the objects are made avail. in ggplot2 with functions that start with geom_
#ex., bar charts use (geom_bar())
#line charts use (geom_line())
#boxplots use (geom_boxplot())
#scatterplots use (geom_point()) : geom_point adds a layer of points to your plot, which creates a scatterplot. 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()
#now we can see a scatterplot. the relationship between flipper length and body mass seems to be positive, where as flipper length increases, so does body mass. it appears to be fairly linear, and moderately strong. (not too much scatter around such a line)
#review the warning message. there are two penguins in the dataset with missing bodymass and/or flipper length values, ggplot has no way of representing them on the plot without both of these values. 
#for the remaining plots in this chapter we will suppress the warning so its not printed alongside every plot we make. 

#adding aesthetics and layers 
#it is important to ask whether there may be other variables that explain or change the nature of this apperant relationship, like if the relationship between flipper length and body mass differ by species. 
#lets incorporate species into our plot and see if this reveals any additional insights. 
#we will do this by representing each species with a different color point. 
#to do this, we must modify the aes() function (aesthetic function)
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point()
#when a categorical variable is mapped to an aesthetic, ggplot will assign a unique value of the aesthetic to each unique level of the variable, known as scaling. 
#it will also add a legend that explains which values correspond to which levels. 
#now lets add one more layer: a smooth curve displaying the relationship between body mass and flipper length. 

#since this is a new genometric object representing our data, we will add a new geom as a layer on top of our point geom: geom_smooth() 
#we will specify that we want to draw the line of best fit based on a linear model with method = "lm"
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth(method = "lm")

#since we want points to be colored based on species but dont want the lines to be separated out for them, we should specify color = species for geom_point only. 
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")
#its generally not a good idea to represent information using only colors on a plot, as people perceive colors differently. 
#in addition to color, we can also map species to the shape aesthetic. 
ggplot(
  data = penguins, 
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) + 
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")

#finally, we can improve the labels of our plot using the labs() function in a new layer. 
#arguments: title adds a title, subtitle adds a subtitle. x is the x-axis label, y is the y-axis label, color and shape define the label for the legend. 
#to improve the color palette to be colorblind safe, use scale_color_colorblind() function from ggthemes package. 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) + 
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") + 
  labs(
    title = "Body mass and flipper length", 
    subtitle = "Dimensions for Adelie, Chinstrap and Gentoo Penguins", 
    x = "Flipper length (mm)", y = "Body mass (g)", 
    color = "Species", shape = "Species"
  ) + 
  scale_color_colorblind()
#we now have a plot that matches the example. 

#ggplot2 calls 
#the first two arguments to ggplot() are data and mapping, these names form now on will not be supplied. 
#rewriting the previous plot more concisely yields: 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()

#the pipe, |>, allows us to create the same plot with: 
penguins |>
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

#visualizing distributions 
#how we visualize distribution of a variable depends on the type of variable: categorical or numerical. 

#categorical variables: a variable is categorical if it can only take one of a small set of values. 
#to examine the distribution of a caegorical variable, we can use a bar chart. 
#the height of the bar displays how many observations occured with each x value. 
ggplot(penguins, aes(x = species)) +
  geom_bar()
#in bar plots of categorical variables with non-ordered levels, like the penguin species above, it is preferable to reorder the bars based on frequency. 
#doing so requires transforming the variable to a factor and then reordering the levels of that factor. 
ggplot(penguins, aes(x = fct_infreq(species))) + 
  geom_bar()

#numerical variables: a variable is numerical if it can take on a wide range of numerical values, and it is sensible to add, subtract, or take averages with those values. 
#numerical variables can be continuous or discrete.
#one common visualization for distributions of continuous variables is a histogram. 
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(binwidth = 200)
#a histogram divides the x-axis into equally spaced bins and then uses the height of a bar to display the number of observations that fall in each bin.
#you can set the width of the intervals in a histogram with the binwidth argument, which is measured in the units of the x variable. 
#different binwidths can reveal different patterns. 

#an alternative visualization for distributions of numerical variables is a density plot. 
#density plot: a smoothed-out version of a histogram, practical for continuous data that comes from an underlying smooth distribution. 
#it shows fewer details than a histogram but can make it easier to quickly glean the shape of distribution. particularly with respect to modes and skewness. 
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density()

#visualizing relationships: 
#to visualize a relationship, we need to have at least two variables mapped to aesthetics of a plot

#a numerical and a categorical variable
#to visualize a relationship between a numerical and a categorical variable, we can use side-by-side plots. 
#a boxplot is a type of visual shorthand for measures of position (percentiles) that describe a distribution. it is also useful for identifying potential outliers. 
#each boxplot consists of: a box that indicates the range of the middle half of the data, a distance known as the interquartile range(IQR, stretches from the 25th percentile to the 75th percentile), and a line in the middle of the box that displays the median
#visual points that display observations that fall more than 1.5 times the IQR from either edge of the box. 
#a line that extends from each end of the box and geos to the farthest non-outlier point in the distribution. 
#lets look at the distribution of body mass by species using geom_boxplot():
ggplot(penguins, aes(x = species, y = body_mass_g)) + 
  geom_boxplot()
#alternatively we can make density plots with geom_density():
ggplot(penguins, aes(x = body_mass_g, color = species)) + 
  geom_density(linewidth = 0.75)
#we can customize the thickness of the lines using the linewidth argument
#additionally, we can map species to both color, and fill aesthetics and use the alpha aesthetic to add transperency to the filled density curves.
#this aesthetic takes values between 0 and 1. in the following plot it is set to 0.5
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) + 
  geom_density(alpha = 0.5)
#we 'map' variables to aesthetics if we want the visual attribute represented by that aesthetic to vary based on the values of that variable. otherwise, we 'set' the value of an aesthetic. 

#two categorical variables 
#we can use stacked bar plots to visualize the relationship between two categorical variables. 
#for ex., the following two stacked bar plots both display the relationship between island and species, or visualizing the distribution of species within each island. 
#the first plot shows the frequencies of each species of penguins on each island. the plot of frequencies shows that there are equal numbers of Adelies on each island. but, we dont have a good sense of the percentage balance within each island. 
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar()
#the second plot, a relative frequency plot created by setting position = "fill" in the geom is more useful for comparing species distributions across islands since it's not affected by the unequal numbers of penguins across the islands. 
#using this plot, we can see that Gentoo penguins all live on Biscoe island and make up roughly 75% of the penguins on that island. chinstrap all live on dream island and make up roughly 50% of the penguins on that island. adellie live on all three islands and make up all of the penguins on torgersen. 
ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar(position = "fill")
#in creating these bar charts, we map the variable that will change the colors inside the bars to the fill aesthetic. 

#two numerical variables 
#a scatterplot is probably the most commonly used plot for visualizing the relationship between two numerical variables. 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()

#three or more variables 
#we can incorporate more variables into a plot by mapping them to additional aesthetics for example, the following scatterplot uses the colors of points to represent species and the shapes of points to represent islands. 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island))

#however, too many aesthetic mappings to a plot will make it look cluttered and difficult to make sense of.
#for categorical variables commonly, another way is to split the plot into facets. 
#facet = subplots that each display one subset of the data.  
#to facet your plot by a single variable, use facet_wrap(). the first argument of facet_wrap is a formula which you create with ~ followed by a variable name. the variable that you pass to facet_wrap() should be categorical. 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = species)) + 
  facet_wrap(~island)

#saving your plots
#once youve made a plot, you might want to get it out of R by saving it as an image that you can use elsewhere. 
#ggsave() saves the plot most recently created to disk: 
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point()
ggsave(filename = "penguin-plot.png")
#for reproducible code, you will want to specify the width and height.

#common problems 
#press escape to abort processing if R thinks it has been given an incomplete expression
#you can get help about any R function by running ?function_name in the console. 


#WORKFLOW:BASICS
#coding basics: 
#you can use R to do basic math calculations 
#ex.: 
1/200 * 30 
sin(pi/2)
#create new objects with the assignment operator <-:
x = 3 * 4
#combine multiple elements into a vector with c():
primes <- c(2, 3, 5, 7, 11, 13)
#basic arithmetic on vectors is applied to every element of the vector: 
primes * 2
primes - 1
#all assignment statements have the same form: 
object_name <- value 

#comments 
#obviously R will ignore any text after # for that line
#they are helpful in briefly describing what the following code does. for ex.: 
#create a vector of primes 
primes <- c(2, 3, 5, 7, 11, 13)
#multiply primes by 2
primes * 2
#use comments to describe the why of your code. 

#whats in a name? 
#reccomended to separate lowercase words with _
#you can inspect an object by typing its name: 
x
#make another assignment: 
this_is_a_really_long_name <- 2.5
#use tab to complete long names 
#press ^ arrow to bring back the last command you typed 
#make yet another assignment: 
r_rocks <- 2^3
#you must be completely precise in instructions, R cannot read your mind. 

#calling functions 
#R has a large collection of built-in functions that are called like this: 
function_name(argument1 = value1, argument2 = value2, ...)
#using seq(), we can make regular sequences of numbers. 
seq(from = 1, to = 10)
#we often omit the names of the first several arguments in function calls so we can rewrite as:
seq(1,10)
#the environment pane displays all the objects that we have created


#DATA TRANSFORMATION 
#transformation using the dplyr package
library(nycflights13)
library(tidyverse)

#nycflights13 
#using the dataset nycflights13::flights 
flights 
#flights is a tibble, a special type of data frame used by the tidyverse to avoud some common gotchas. 
#the most important difference between tibbles and dfs is the way tibbles print. they are designed for large datasets so they only show the first few rows and only the columns that fit on one screen. 
#use (if in RStudio)
View(flights)
#or 
print(flights, width = Inf) #shows all columns, or 
glimpse(flights)
#in both views the variables names are followed by abbreviations that tell you the type of each variable 
# <int> = integer, <dbl> = double (aka real numbers), <chr> = character (aka strings), and <dttm> = date-time

#dplyr basics
#the first argument is always a data frame. the subsequent arguments typically describe which columns to operate on, using the variable names(without quotes). the output is always a new data frame.
#solving complex problems usually requires combining multiple functions, so we do so with the pipe (|>). the pipe takes the thing to its left and passes it along to the function on its right. the easiest way to pronouce the pipe is "then". 
flights |>
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )
#dplyrs verbs (functions) are organized into 4 groups based on what they operate on: rows, columns, groups or tables. 

#rows 
#the most important verbs that operate on rows of a data set are 
filter() #which changes which rows are present without changing their order
arrange() #which changes the order of the rows without changing which rows are present. 
distinct() #finds rows with unique values but unlike arrange and filter, it can optionally modify the columns. 

#filter()
filter() #allows you to keep rows based on the values of the columns.
#the first argument is the data frame. the second and subsequent arguments are the conditions that must be true to keep the row. 
#ex., we could find all flights that departed more than 120 minutes late: 
flights |>
  filter(dep_delay > 120)
#as well as >, we can also use >= (greater than or equal to), <, <=, == (equal to), and != (not equal to)
#we can also combine conditions with & or , to indicate "and" (check for both conditions) or with | to indicate "or" (check for either condition)
#ex., flights that departed on January 1: 
flights |>
  filter(month == 1 & day == 1)
#flights that departed in January or February
flights |>
  filter(month == 1 | month == 2)
#there is a useful shortcut when we are combining | and == : %in%
#it keeps rows where the variable equals one of thee values on the right 
#ex, a sorter way to select flights that departed in January or February:
flights |> 
  filter(month %in% c(1, 2))
#when you run filter() dplyr executes the filtering operation, creating a new data frame and then printing it. 
#it doesnt modify the existing flights dataset because dplyr functions never modify their inputs. to save the result, you need to use the assignment operator, <-
jan1 <- flights |>
  filter(month == 1 & day == 1)
#common mistakes 
#must use ==, just = will return an error. 

#arrange()
arrange() #changes the order of the rows based on the value of the columns. 
#it takes a data frame and a set of column names to order by. if you provide more than one column name, each additional column will be used to break ties in the values of preceding columns. 
#for example, the following code sort by the departure time, which is spread over four columns. we get the earliest years first, and then within a year the earliest months, etc. 
flights |>
  arrange(year, month, day, dep_time)
#you can use desc() on a column inside of arrange() to re-order the data frame based on that column in descending (big-small) order. 
#ex., ordering flights from most to least delayed: 
flights |>
  arrange(desc(dep_delay))
#note that the number of rows has not changed - we are only arranging the data, not filtering it. 

#distinct()
distinct() #finds all the unique rows in a dataset, so in a technical sense, it primarily operates on the rows. most of the time, however, youll want the distinct combination of some variables so you can also optionally supply column names: 
#remove duplicate rows, if any: 
flights |>
  distinct()
#find all unique origin and destination pairs
flights |>
  distinct(origin, dest)
#alternatively if we want to keep other columns when filtering for unique rows, we can use .keep_all = TRUE:
flights |>
  distinct(origin, dest, .keep_all = TRUE)
#it is not a coincidence that all of the distinct flights are on jan 1. distinct() will find the first occurence of a unique row in the dataset and discard the rest. 
#if you want to find the number of occurrences instead, you are better off swapping distinct for count(), and the sort = TRUE will arrange them in descending order of number of occurrences:
flights |>
  count(origin, dest, sort = TRUE)

#columns
#there are 4 important verbs that affect the columns without changing the rows:
mutate() #created new columns that are derived from the existing columns, 
select() #changes which columns are present
rename() #changes the names of the columns 
relocate() #changes the positions of the columns 

#mutate()
mutate() #adds new columns that are calculated from the existing columns. 
#using basic algebra, we can compute the gain, or how much time a delayed flight made up in the air, and the speed in miles per hour: 
flights |>
  mutate(
    gain = dep_delay - arr_delay, 
    speed = distance / air_time * 60
  )
#by default, mutate adds new columns on the right hand side of our dataset, which makes it difficult to see what is happening.
#we can use the .before argument to ass the variables to the left hand side instead: 
flights |>
  mutate(
    gain = dep_delay - arr_delay, 
    speed = distance / air_time * 60, 
    .before = 1
  )
#the '.' sign is a notifier that .before is an argument to the function, not the name of a third new variable we are creating. 
#.after can be used to add after a variable and in both .before and .after we can use the variable name instead of a position. 
#ex., we can add the new variables after day: 
flights |>
  mutate(
    gain = dep_delay - arr_delay, 
    speed = distance / air_time * 60, 
    .after = day
  )
#alternitively, we can control which variable are kept with the .keep argument. a particularly useful argument is "used" which specifies that we only keep the columns that were involved or created in the mutate() step. 
#ex., the following output will contain only the variables dep_delay, arr_delay, air_time, gain, hours, and gain_per_hour:
flights |>
  mutate(
    gain = dep_delay - arr_delay, 
    hours = air_time / 60, 
    gain_per_hour = gain / hours, 
    .keep = "used"
  )
#note that since we havent assigned the result of the above computation back to flights, the new variables gain, hours and gain_per_hour will only be printed but will not be stored in a data frame. 
#if we want them to be available in a data frame for future use, we should think carefully about whether we want the result to be assigned back to flights, overwriting the original data frame with many more variables, or to a new object. 
#often the right answer is a new object that is names informatively to indicate its contents. 
#ex., delay_gain, but there may be a good reason for overwriting flights.

#select()
select() #allows us to rapidly zoom in on a useful subset using operations based on the names of the variables:
#ex. select columns by name:
flights |>
  select(year, month, day)
#select all columns between year and day(inclusive):
flights |>
  select(year:day)
#select all columns except those from year to day(inclusive):
flights |>
  select(!year:day)
#historically this operation was done with - instead of !. the two operators serve the same purpose, but with subtle differences in behavior. we reccomend using ! because it reads as "not" and combines well with & and |. 
#select all columns that are characters:
flights |>
  select(where(is.character))
#there are a number of helper functions that can be used within select():
starts_with("abc") #matches names that begin with "abc"
ends_with("xyz") #matches names that end with "xyz"
contains("ijk") #matches names that contain "ijk"
num_range("x", 1:3) #matches x1, x2 and x3.
#see ?select for more details. once we know regular expressions we can use matches() to select variables that match a pattern. 

#you can rename variables as you select() by using '='
#the new name appears on the left hand side of the =, and the old variable appears on the right hand side: 
flights |> 
  select(tail_num = tailnum)

#rename()
rename() #will keep all existing variables and just rename a few. 
flights |>
  rename(tail_num = tailnum)
#if we have a multitude of inconsistently names columns, check out janitor::clean_names() which provides some useful automated cleaning. 

#relocate()
relocate() #can move variables around. 
#we may want to collect related variables together or move important variables to the front. by default relocate() moves variables to the front: 
flights |>
  relocate(time_hour, air_time)
#you can also specify where to put them using the .before and .after arguments like in mutate:
flights |> 
  relocate(year:dep_time, .after = time_hour)
flights |>
  relocate(starts_with("arr"), .before = dep_time)

#the pipe
#ex., imagine that we wanted to find the fastest flights to Houston's IAH airport. we need to combine filter(), mutate(), select(), and arrange():
flights |>
  filter(dest == "IAH") |>
  mutate(speed = distance / air_time * 60) |>
  select(year:day, dep_time, carrier, flight, speed) |>
  arrange(desc(speed))
#if we didnt have the pipe, we could nest each function call inside the previous call: 
arrange(
  select(
    mutate(
      filter(
        flights,
        dest == "IAH"
      ), 
      speed = distance / air_time * 60
    ), 
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)
#or we could use a bunch of intermediate objects: 
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance / air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))

#magrittr
#may have familiarity with the %>% pipe provided by the magrittr package.
#you can use %>% whenever you load the tidyverse:
mtcars %>%
  group_by(cyl) %>%
  summarize(n = n())
#in simple cases |> and %>% behave identically. |> is recommended because its part of base R and simpler to type. 

#groups
group_by() #divides the dataset into meaningful groups for analysis.
flights |>
  group_by(month)
#group_by doesnt change the data but if you look at the output 
#youll notice the output indˆcates that it is "grouped by" month. this means that subsequent operations will now work "by month". group_by adds this grouped feature to the data frame (class) to the data frame, which changes the behavior of the subsequent verbs applied to the data

summarize() #the most important group operation. it reduces the data frame to have a single row for each group. 
#ex. this operation computes the average departure delay by month. 
flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay)
  )
#something went wrong and all results are NAs. (missing value) which happened because some of the observed flights had missing data. 
#for now we can just tell the mean() function to ignore all missing values by setting the argument na.rm to TRUE: 
flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )
#you can recreate any number of summaries in a single call to summarize()
n() #returns the number of rows in each group: 
flights |> 
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

#slice functions 
#there are five handy functions that allow you to extract specific rows within each group:
df |> slice_head(n = 1) #takes the first row from each group
df |> slice_tail(n = 1) #takes the last row in each group
df |> slice_min(x, n = 1) #takes the row with the smallest value of column x
df |> slice_max(x, n = 1) #takes the row with the largest value of column x
df |> slice_sample(n = 1) #takes one random row
#you can vary n to select more than one row, or instead of "n =" you can use prop = 0.1 to select 10% of the rows. 
flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 1) |> 
  relocate(dest)
#the output produces 108 rows but there are 105 destinations
#this is because "slice_min" and "slice_max" keep tied values so n = 1 means give us all rows with the highest value. if you want exactly one row per group you can set "with_ties = FALSE"
#this is similar to computing the max delay with summarize(), but you get the whole corresponding row instead of the single summary statistic. 

#grouping by multiple variables 
#you can create groups using more than one variable
#ex, can make a group for each date 
daily <- flights |>
  group_by(year, month, day)
daily
#when you summarize a tibble grouped by more than one variable, each summary peels off the last group
#this isnt the best way to make this function work, but its difficult to change without breaking existing code. 
#to make it obvious what is happening, dplyr displays a message that tells you how you can change this behavior:
daily_flights <- daily |> 
  summarize(n = n())
#if you are happy with this behavior, you can explicitly request it in order to suppress the message:
daily_flights <- daily |>
  summarize(
    n = n(),
    .groups = "drop_last"
  )
daily
#alternatively, change the default behavior by setting a different value, ex. "drop" to drop all grouping or "keep" to preserve the same groups.

#ungrouping 
#you might want to remove grouping from a data frame without using summarize. you can do this with ungroup(). 
daily |>
  ungroup()
#now what happens when you summarize an ungrouped data frame 
daily |>
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  )
#you get a single row back because dplyr treats all the rows in an ungrouped data frame as belonging to one group 

#.by
#dplyr 1.1.0 includes a new, experimental, syntax per-operation grouping, the .by argument. 
group_by() #and 
ungroup() #are not going away, but we can now use the .by argument to group within a single operation 
flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(), 
    .by = month
  )
#or if you want to group by multiple variables: 
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin, dest)
  )
#.by works with all verbs and has the advantage that you dont need to use the .groups argument to suppress the grouping message or ungroup() when your done. 
#find the flights that are most delayed upon departure from each destination:

#workflow: code style
#tidyverse style guide overview: styler package by Lorenz Walthert
install.packages("styler")
#command palette: lets you use any built-in RStudio command and many addins provided by packages
#open the palette by pressing Ctrl + Shift + P, then type styler
#using the tidyverse and nycflights13 packages for code examples
library(tidyverse)
library(nycflights13)
#use _ to separate words within a name
#strive for 
short_flights <- flights |> filter(air_time < 60)
#avoid
SHORTFLIGHTS <- flights |> filter(air_time < 60)

#spaces 
#put spaces on either side of mathematical operators apart from ^ and around the assignment (<-) operator
#always put a space after a comma, like in standard english 
#it is ok to add extra spaces if it improves alignment 
#for ex. 
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )

#pipes
# "|>" should always have a space before it and should typically be the last thing on a line
#if the function youre piping into has named arguments, like mutate() or summarize(), put each argument on a new line. if teh function doesn't have named arguments keep everything on one line unless it doesn't fit, in which case you should put each argument on its' own line 
#after the first step in the pipe, indent each line by two spaces.
#make sure ) is on its own line, and un-indented to match the horizontal position of the function name 
#can disregard these rules if the pipeline fits easily on one line

#ggplot 
#the same basic rules apply to ggplot2, treat + the same way as |>
#ex:
flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()
#again, if we cannot fit all of the arguments to a function on to a single line, put each argument on its own line like: 
flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE, 
    color = "white", 
    linewidth = 4
  ) +
  geom_point()
#watch for the transition from "|>" to "+"
#ggplot2 was written before the pipe was discovered 

#sectioning comments 
#as scripts get longer, use sectioning comments to break up the file into manageable pieces 
#ex: 
# Load data --------------------------------------

# Plot data --------------------------------------

#rstudio provides a keyboard shortcut to create these headers:
#cmd/ctrl + shift + R will display them in the code navigation drop-down at the bottom-left of the editor 


#DATA TIDYING 
library(tidyverse)

#tidy data 
#you can represent the same underlying data in multiple ways
#there are three interrelated rules that make a dataset tidy: 
# 1) each variable is a column, each column is a variable
# 2) each observation is a row, each row is an observation 
# 3) each value is a cell; each cell is a single value 

#two main advantages to ensuring that your data is tidy 
#if you have a consistent data structure, its easier to learn the tools that work with it because they have underlying uniformity 
#there's an advantage to placing variables in columns because it allowed R's vectorized nature to shine 
#dplyr, ggplot2 and all other packages in the tidyverse are designed to work with tidy data
#ex showing how to possibly work with table1

# compute rate per 10,000
table1 |>
  mutate(rate = cases / population * 10000)
#> # A tibble: 6 × 5
#>   country      year  cases population  rate
#>   <chr>       <dbl>  <dbl>      <dbl> <dbl>
#> 1 Afghanistan  1999    745   19987071 0.373
#> 2 Afghanistan  2000   2666   20595360 1.29 
#> 3 Brazil       1999  37737  172006362 2.19 
#> 4 Brazil       2000  80488  174504898 4.61 
#> 5 China        1999 212258 1272915272 1.67 
#> 6 China        2000 213766 1280428583 1.67

# compute total cases per year
table1 |> 
  group_by(year) |> 
  summarize(total_cases = sum(cases))
#> # A tibble: 2 × 2
#>    year total_cases
#>   <dbl>       <dbl>
#> 1  1999      250740
#> 2  2000      296920

# visualize changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # x-axis breaks at 1999 and 2000




