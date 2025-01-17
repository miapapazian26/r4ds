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

#lengthening data 
#most real analyses will require at least a little tidying
#tidyr provides two functions for pivoting data: pivot_longer and pivot_wider

#data in column names 
#the billboard dataset records the billboard rank of songs in the year 2000
#each observation is a song, first three columns are variables that describethe song, 76 columns that describe the rank of the song in each week
#column names are one variable and cell values are another 
#to tidy this data use pivot_longer():
billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )
#there are three key arguments:
# cols specifies which columns need to be pivoted. uses the same syntax as select() so ex. !c(artist, track, date.entered) or starts_with("wk")
# names_to names the variable stored in the column names, we named that variable week 
# values_to names the variable stored in the cell values, we named that variable rank 
#note that "week" and "rank" are quoted because those are new variables were creating, they dont exist in the data yet when we run pivot_longer()
#take the NAs that result from the song being in the top 100 for less than 76 weeks, we can ask pivot_longer() to. get rid of them by setting values_drop_na = TRUE
billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week", 
    values_to = "rank", 
    values_drop_na = TRUE
  )
#what if a song is in the top 100 for more than 76 weeks? 
#additional columns wk77 and wk78 would be added to the data set

#the data is now tidy, but to make future computation a bit easier we can covert values of week from character strings to numbers using mutate() and readr::parse_number()
#parse_number() is a handy function that will extract the first number from a string ignoring all other text. 
billboard_longer <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |>
  mutate(
    week = parse_number(week)
  )
billboard_longer

#now that we have all the week numbers in one variable and all the rank values in another, we can visualize how song ranks vary over time:
billboard_longer |>
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha = 0.25) +
  scale_y_reverse()

#how does pivoting work? 
#suppose we have three patients with ids A, B and C and we take two blood pressure measurements on each patient
#we will create the data with tribble()
df <- tribble(
  ~id, ~bp1, ~bp2,
  "A", 100, 120,
  "B", 140, 115,
  "C", 120, 125
)
#we want our new data set to have three variables: id, measurement, and value. to achieve this we need to pivot the df longer:
df |>
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
)

#many variables in column names 
#using the who2 data set, we can organize with pivot_longer()
who2 |>
  pivot_longer(
    cols = !(country:year), 
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )
#an alternative to names_sep is names_pattern which can be used to extract variables from more complicated naming scenarios 

#data and variable names in the column headers
#in cases where column names include a mix of variable values and variable names
#using the household dataset 
household
#the dataset contains data about five families, with the names and dates of birth of up to two children 
#the challenge is that the column names contain the names of two variables and the values of another 
#to solve this problem we supply a vector to names_to, but this time using the ".value" sentinel
#it tells pivot_longer() to use the first component of the pivoted column name as a variable name in the output
household |>
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
  )
#values_drop_na = TRUE is used since the shape of the input forces the creation of explicit missing variables 

#when you use ".value" the column names in the input contribute to both values and variable names in the output

#widening data 
#using pivot_wider(), data sets are made wider by increasing columns and reducing rows, and helps when one observation is spread across multiple rows 
#looking at cms_patient_experience 
cms_patient_experience
#we can see the complete set of values for measure_cd and measure_title by using distinct():
cms_patient_experience |>
  distinct(measure_cd, measure_title)
#neither of these columns will make good variable names 
#measure_cd will be used as a source for the new column names for now, but in a real analysis you might want to create your own variable names that are short/meaningful
#pivot_wider() has the opposite interface to pivot_longer(): 
#instead of choosing new column names, we need to provide the existing columns that define the values (values_from) and the column name (names_from):
cms_patient_experience |>
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )
#the output doesn't look quite right. this is because pivot_wider needs to be told which column or columns have values that uniquely identify each row; in this case those are the variables starting with "org":
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )
#this gives the output that we are looking for. 

#how does pivot_wider() work
#starting with a simple data set,
df <- tribble(
  ~id, ~measurement, ~value, 
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115,
  "A",        "bp2",    120,
  "A",        "bp3",    105
)
#take the values from the value column and the names from the measurement column 
df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
#to begin the process, pivot_wider() needs to first figure out what will go in the rows and columns. the new column names will be the unique values of measurement: 
df |>
  distinct(measurement) |>
  pull()
#by default, the rows in the output are determined by all the variables that aren't going into the new names or values. these are called the id_cols. There is only one column but in general there can be any number:
df |>
  select(-measurement, -value) |>
  distinct()
#pivot_wider() then combines these results to generate an empty data frame: 
df |>
  select(-measurement, -value) |>
  distinct() |>
  mutate(x = NA, y = NA, z = NA)
#it then fills in all the missing values using the data in the input 
#in this case, not every cell in the output has a corresponding value in the input as there's no third blood pressure measurement for patient B, so the cell remains missing. the idea that pivot_wider can "make" missing values

#in a case where there is multiple rows in the input that correspond to one cell in the output:
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)
#if we attempt to pivot this we get an output that contains list-columns (chapter 23):
df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
#follow the hints in the warning to figure out where the problem is: 
df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)
#after this its up to you to work out any warning messages 


#SCRIPTS 
#running code 
#the key to using the script editor effectively is to memorize one of the most important keyboard shortcuts: ctrl + enter
#this executes the current R expression in the console
#ex. 
library(dplyr)
library(nycflights13)

not_cancelled <- flights |> 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled |> 
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))
#makes it easy to step through your complete script by repeatedly

#always start the script with the packages you need 
#but never include "install.packages" because that is inconsiderate 
#rstudio diagnostics (6.1.2)
#in the script editor, rstudio will highlight syntax errors with a red squiggly line and a cross in the sidebar - hover over to see the problem 
#will also alert about potential problems 

#6.1.3 saving and naming 
#rstudio automatically saves the contents of the script editor when you quit
#three important principles for file naming are as follows:
#file names should be machine readable: avoid spaces, symbols, and special characters. don’t rely on case sensitivity to distinguish files.
#file names should be human readable: use file names to describe what’s in the file.
#file names should play well with default ordering: start file names with numbers so that alphabetical sorting puts them in the order they get used.
#number key scripts to make it obvious in which order they run 

#6.2 projects 
#to handle these real life situations, you need to make two decisions:
#what is the source of truth? what will you save as your lasting record of what happened?
#where does your analysis live?

#6.2.1 what is the source of truth? 
#to make it easier to work on larger projects or collaborate with others, your source of truth should be the R scripts.
#i save with github - do i need to do this? 

#6.2.2 where does the analysis live? 
#working directory 
#you can print this by running getwd():
getwd()
# [1] "/Users/hadley/Documents/r4ds"

#6.2.3 project creation
#skipped because i already use this as my directory 

#6.2.4 relative and absolute paths 
#a relative path is relative to the working directory, i.e. the project’s home. point to the same place regardless of your working directory. 

#DATA IMPORT
#focus on reading plain-text rectangular files
#learn how to load flat files in R with the readr package, which is part of the core tidyverse
library(tidyverse)

#7.2 reading data from a file 
#most common rectangular data file type: CSV, which is short for comma-separated values
#here is what a simple CSV file looks like. the first row, commonly called the header row, gives the column names, and the following six rows provide the data. the columns are separated, aka delimited, by commas
#we can read this file into R using read_csv().
#the first argument is the most important: the path to the file. You can think about the path as the address of the file: the file is called students.csv and that it lives in the data folder.
students <- read_csv("data/students.csv")
#we can read the file directly from that URL with:
students <- read_csv("https://pos.it/r4ds-students-csv")
#when you run read_csv(), it prints out a message telling you the number of rows and columns of data, the delimiter that was used, and the column specifications (names of columns organized by the type of data the column contains). It also prints out some information about retrieving the full column specification and how to quiet this message.

#7.2.1 practical advice 
#once you read data in, the first step usually involves transforming it in some way to make it easier to work with in the rest of your analysis. let’s take another look at the students data with that in mind.
students
#in the favourite.food column, there are a bunch of food items, and then the character string N/A, which should have been a real NA that R will recognize as “not available”. this is something we can address using the na argument
students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))
students

#notice that the Student ID and Full Name columns are surrounded by backticks. that’s because they contain spaces, breaking R’s usual rules for variable names; they’re non-syntactic names. to refer to these variables, you need to surround them with backticks, `
students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

#an alternative approach is to use janitor::clean_names() to use some heuristics to turn them all into snake case at once
#the janitor package is not part of the tidyverse, but it offers handy functions for data cleaning and works well within data pipelines that use |>
students |> janitor::clean_names()
#another common task after reading in data is to consider variable types. For example, meal_plan is a categorical variable with a known set of possible values, which in R should be represented as a factor
students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))
#the values in the meal_plan variable have stayed the same, but the type of variable denoted underneath the variable name has changed from character (<chr>) to factor (<fct>)
#before you analyze these data, you’ll probably want to fix the age column. Currently, age is a character variable because one of the observations is typed out as five instead of a numeric 5
students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )
students 

#new function here is if_else(), which has three arguments. the first argument test should be a logical vector. the result will contain the value of the second argument, yes, when test is TRUE, and the value of the third argument, no, when it is FALSE. here we’re saying if age is the character string "five", make it "5", and if not leave it as age
#7.2.2 other arguments 
#first show you a handy trick: read_csv() can read text strings that you’ve created and formatted like a CSV file:
read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

#read_csv() uses the first line of the data for the column names, which is a very common convention. but it’s not uncommon for a few lines of metadata to be included at the top of the file. you can use skip = n to skip the first n lines or use comment = "#" to drop all lines that start with (e.g.) #:
read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

#other cases, the data might not have column names. You can use col_names = FALSE to tell read_csv() not to treat the first row as headings and instead label them sequentially from X1 to Xn:
read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)

#you can pass col_names a character vector which will be used as the column names:
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

#7.2.3 other file types 
#read_csv2() reads semicolon-separated files. These use ; instead of , to separate fields and are common in countries that use , as the decimal marker.
#read_tsv() reads tab-delimited files.
#read_delim() reads in files with any delimiter, attempting to automatically guess the delimiter if you don’t specify it.
#read_fwf() reads fixed-width files. You can specify fields by their widths with fwf_widths() or by their positions with fwf_positions().
#read_table() reads a common variation of fixed-width files where columns are separated by white space.
#read_log() reads Apache-style log files.

#7.3 controlling column types 
#readr uses a heuristic to figure out the column types. For each column, it pulls the values of 1,0002 rows spaced evenly from the first row to the last, ignoring missing values. It then works through the following questions:
#does it contain only F, T, FALSE, or TRUE (ignoring case)? If so, it’s a logical.
#does it contain only numbers (e.g., 1, -4.5, 5e6, Inf)? If so, it’s a number.
#does it match the ISO8601 standard? If so, it’s a date or date-time. (We’ll return to date-times in more detail in Section 17.2).
#otherwise, it must be a string.
read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")
#this heuristic works well if you have a clean dataset, but in real life, you’ll encounter a selection of weird and beautiful failures.

#7.3.2 missing values, column types and problems 
#the most common way column detection fails is that a column contains unexpected values, and you get a character column instead of a more specific type. one of the most common causes for this is a missing value, recorded using something other than the NA that readr expects.
#take this simple one column CSV file: 
simple_csv <- "
  x
  10
  .
  20
  30"
#if we read it without any additional arguments, x becomes a character column:
read_csv(simple_csv)

#what happens if you have thousands of rows with only a few missing values represented by .s sprinkled among them? One approach is to tell readr that x is a numeric column, and then see where it fails. you can do that with the col_types argument, which takes a named list where the names match the column names in the CSV file:
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)
#now read_csv() reports that there was a problem, and tells us we can find out more with problems():
problems(df)

#tells us that there was a problem in row 3, col 1 where readr expected a double but got a .. that suggests this dataset uses . for missing values. so then we set na = ".", the automatic guessing succeeds, giving us the numeric column that we want:
read_csv(simple_csv, na = ".")

#7.3.3 column types 
#readr provides a total of nine column types for you to use:
#col_logical() and col_double() read logicals and real numbers. they’re relatively rarely needed (except as above), since readr will usually guess them for you.
#col_integer() reads integers. we seldom distinguish integers and doubles in this book because they’re functionally equivalent, but reading integers explicitly can occasionally be useful because they occupy half the memory of doubles.
#col_character() reads strings. this can be useful to specify explicitly when you have a column that is a numeric identifier, i.e., long series of digits that identifies an object but doesn’t make sense to apply mathematical operations to. Examples include phone numbers, social security numbers, credit card numbers, etc.
#col_factor(), col_date(), and col_datetime() create factors, dates, and date-times respectively; you’ll learn more about those when we get to those data types in Chapter 16 and Chapter 17.
#col_number() is a permissive numeric parser that will ignore non-numeric components, and is particularly useful for currencies. You’ll learn more about it in Chapter 13.
#col_skip() skips a column so it’s not included in the result, which can be useful for speeding up reading the data if you have a large CSV file and you only want to use some of the columns.

#possible to override the default column by switching from list() to cols() and specifying .default:
another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

#another useful helper is cols_only() which will read in only the columns you specify:
read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)

#7.4 reading data from multiple files 
#sometimes your data is split across multiple files instead of being contained in a single file
#you can read these data in at once and stack them on top of each other in a single data frame:
sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")

#the id argument adds a new column called file to the resulting data frame that identifies the file the data come from. This is especially helpful in circumstances where the files you’re reading in do not have an identifying column that can help you trace the observations back to their original sources.

#you can use the base list.files() function to find the files for you by matching a pattern in the file names
sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)
sales_files

#7.5 writing to a file 
#readr also comes with two useful functions for writing data back to disk: write_csv() and write_tsv().
#the most important arguments to these functions are x (the data frame to save) and file (the location to save it). you can also specify how missing values are written with na, and if you want to append to an existing file.
write_csv(students, "students.csv")
#read that csv file back in - the variable type information that you just set up is lost when you save to CSV because you’re starting over with reading from a plain text file again:
students 

#this makes CSVs a little unreliable for caching interim results—you need to recreate the column specification every time you load in. 
#there are two main alternatives:

#write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS(). these store data in R’s custom binary format called RDS. this means that when you reload the object, you are loading the exact same R object that you stored.
write_rds(students, "students.rds")
read_rds("students.rds")

#the arrow package allows you to read and write parquet files, a fast binary file format that can be shared across programming languages
library(arrow)
write_parquet(students, "students.parquet")
read_parquet("students.parquet")

#parquet tends to be much faster than RDS and is usable outside of R, but does require the arrow package.

#7.6 data entry 
#sometimes you’ll need to assemble a tibble “by hand” doing a little data entry in your R script
#two useful functions to help you do this which differ in whether you layout the tibble by columns or by rows. tibble() works by column:
tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

#laying out the data by column can make it hard to see how the rows are related, so an alternative is tribble(), short for transposed tibble, which lets you lay out your data row by row
#tribble() is customized for data entry in code: column headings start with ~ and entries are separated by commas. 
#this makes it possible to lay out small amounts of data in an easy to read form:
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)

#WORKFLOW: GETTING HELP 
#8.1 google is your friend
#if you get stuck, start with google. 
#additionally add package names to narrow down results
#google error messages 
#look through stack overflow

#8.2 making a reprex
#if googling doesn't come up with anything useful, its a good idea to prepare a reprex
#reprex = reproducible example
#first, make the code reproducible
#second, make it minimal - strip everything that is not directly related to your problem

#when creating a reprex by hand, avoid problems by using the reprex package which is installed as part of the tidyverse
#ex. lets say you copy this code onto your clipboard
y <- 1:4
mean(y)

#then call reprex() where the default output is formatted for GitHub: 
reprex::reprex()
#a nicely rendered HTML preview will display in RStudio’s Viewer
#the reprex is automatically copied to your clipboard 
#this text is formatted in a special way, called Markdown, which can be pasted to sites like StackOverflow or Github and they will automatically render it to look like code. here’s what that Markdown would look like rendered on GitHub:
# y <- 1:4
# mean(y)
# #> [1] 2.5
#anyone can now copy, paste and run this code immediately 

#you need three things to make your example reproducible - required packages, data, and code 
#packages should be loaded at the top of the script so its easy to see which ones the example needs 
#the easiest way to include data is to use dput() to generate the R code needed to recreate it. 
#ex. to recreate the mtcars dataset in R, perform the following steps: 
dput(mtcars) #run in R
#copy the output
#in reprex, type mtcars <-, then paste

#8.3 investing in yourself 
#keep on dedicating time each day to reading about R to pay off in the long run 

#8.4 summary 
#this concludes the "whole game" part of the book. 
#next is visualize section, using ggplot2 to conduct exploratory data analysis.

#VISUALIZE
#9 layers 
library(tidyverse)

#9.2 aesthetic mappings 
#the mpg data frame bundled with the ggplot2 package contains 234 observations on 38 car models
mpg

#among the variables there are displ, hwy, and class 
#start by visualizing the relationship between displ and hwy for various classes of cars
#do this with a scatterplot where the numerical variables are mapped to the x and y aesthetics and the categorical variable is mapped to an aesthetic like color or shape. 
#left
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

#right
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()

#when class is mapped to shape we get two warnings. since ggplot only uses 6 shapes at a time, by default additional groups will go unplotted when you use the shape aesthetic. the second warning is related. there are 62 SUVs in the data set and they're not plotted
#similarly we can map class to size, or alpha aesthetics as well, which control the size and transperancy of the points respectively. 
#left
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()
#right
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

#both of these produce warnings as well. 
#mapping an unordered discrete variable to an ordered aesthetic is generally not a good idea because it implies a ranking that does not in fact exist. 
#once you map an aesthetic ggplot takes care of the rest.
#you can set the visual properties of your geom manually as an argument of your geom function instead of relying on a variable mapping to determine the appearance 

#ex. we can make all the points in our plot blue 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")
#here the color does not convey information about a variable, but only changes the appearance of the plot. 
#need to pick a value that makes sense for that aesthetic 

#9.3 geometric objects
#the plots use different geometric objects - geom - to represent the data 
#plot on the left uses point geom and plot on the right uses smooth geom, a smooth line fitted to the data 
#to change the geom in the plot, change the geom function that you add to ggplot(). 
#to make the plots above: 
#left - 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

#right
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

#not every aesthetic works in every geom. you can set the shape of a point but cannot set the shape of a line.
#you can set the linetype of the line for each unique value of the variable that you map to lineup. 
#left
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) +
  geom_smooth()
#right 
ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth()

#here geom_smooth() separates the cars into three lines based on their drv value, which describes a cars' drive train. one line describes all of the points that have a 4 value, one line describes all the points that have an f value, and one line describes all points that have an r value. 
#here, 4 stands for four-wheel drive, f for front-wheel drive, and r for rear-wheel drive. 
#we can make it clearer by overlaying the lines on top of the raw data. 
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(aes(linetype = drv))

#note that this plot contains two geoms in the same graph 
#many geoms, like geom_smooth(), use a single geometric object to display multiple rows of data. for these geoms, you can set the group aesthetic to a categorical variable to draw multiple objects. 
#ggplot will draw a separate object for each unique value of the grouping variable. 
#ggplot will automatically group the data for these geoms whenever you map an aesthetic to a discrete variable.
#this is convenient because the group aesthetic by itself does not add a legend or distinguishing features to the geoms
#left
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()
#middle
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))
#right
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

#if you place mappings in a geom function, ggplot will treat them as local mappings for the layer. it will use these mappings to extend or overwrite the global mappings for that layer only.
#this makes it possible to display different aesthetics in different layers. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

#you can use this same idea to specify different data for each layer. 
#here we used red points as well as open circles to highlight two-seater cars. the local data arguement in geom_point overrides the global data argument in ggplot for that layer only. 

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    shape = "circle open", size = 3, color = "red"
  )

#geoms are the fundamental building blocks of ggplot2. you can completely transform the look of your plot by changing its geom. diff geoms can reveal diff features of your data. 
#ex. the histogram an density plot below reveal that the distribution of highway mileage is bimodal and right skewed while the boxplot reveals two potential outliers.

#left
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)
#middle
ggplot(mpg, aes(x = hwy)) +
  geom_density()
#right
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()

#ggplot provides more than 40 geoms, but these don't cover all possible plots one could make. 
#ex. the ggridges package (https://wilkelab.org/ggridges/) is useful for making ridgeline plots, which can be useful for visualizing the density of a numerical variable for different levels of a categorical variable. 

#in the following plot, we use a new geom, and we have also mapped the same variable to multiple aesthetics as well as set an aethetic to make the density curves transparent. 
library(ggridges)

ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)
#picking joint bandwidth of 1.28

#to learn more about any single geom, use help (?geom_smooth)

#9.4 facets 
#faceting with facet_wrap, which splits a plot into subplots that each display one subset of the data based on a categorical variable.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~cyl)
#to facet your plot with the combination of two variables, switch from facet_wrap to facet_grid.
#the first argument of facet_grid is also a formula, but now it is double sided. ex. rows ~ cols
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)
#by default, each of the facets share the same scale and range for x and y axes. 
#this is useful when we want to compare data across facets but can be limiting when we want to visualize the relationship between each facet
#setting the scales argument in a faceting function to "free_x" will allow for different scales on y-axis across rows, and "free" will allow both. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free")

#9.5 statistical transformations
#the diamonds dataset is in the ggplot2 package.
#this plot shows that more diamonds are available with high quality cuts than with low quality cuts. 
ggplot(diamonds, aes(x = cut)) +
  geom_bar()

#bar charts, histograms, and frequency polygond bin your data and then plot bin counts, the number of points that fall in each bin.
#smoothers fit a model to your data and then plot predictions from the model
#boxplots compute the five-number summary of the distribution and then display that summary as a specially formatted box. 
#the algorithm used to calculate new values for a graph is a stat (statistical transformation)

#every geom has a default stat and every stat has a default geom
#there are three reasons why you might need to use a stat explicitly
#you might want to override the default stat. for ex. in the following code, we change the stat of geom_bar from count to identity. this lets us map the height of the bars to the raw values of a y variable.
diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")
#you might want to override the default mapping from transformed variables to aesthetics. for ex., you may want to display a bar chart of proportions rather than counts: 
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) +
  geom_bar()
#to look for the possible variables that can be computed by the stat, look for the section titled "computed variables" in the help for geom_bar(). 

#third, you might want to draw greater attention to the statistical transformation in your code.  
ggplot(diamonds) +
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min, 
    fun.max = max,
    fun = median
  )

#9.6 position adjustments 
#theres one more piece of magic associated with bar charts. you can color a bar chart using either the color aesthetic or more usefully, the fill aesthetic:
#left
ggplot(mpg, aes(x = drv, color = drv)) +
  geom_bar()
#right
ggplot(mpg, aes(x = drv, fill = drv)) +
  geom_bar()

#note what happens if you map the fill aesthetic to another variable, like class: the bars are automatically stacked. each colored rectange represents a combination of drv and class: 
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar()
#the stacking is performed automatically using the position adjustment specified by the position argument. if you don't want a stacked bar chart, you can use one of three other options: "identify", "doge", or "fill"

#position = "identity" will place each object exactly where it falls in the context of the graph. this is not very useful for bars, because it overlaps them. to see that overlapping we either need to make the bars slightly transparent by setting alpha to a small value, or completely transparent by setting fill = NA
#left
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(alpha = 1/5, position = "identity")
#right
ggplot(mpg, aes(x = drv, color = class)) +
  geom_bar(fill = NA, position = "identity")

#the identity position adjustment is more useful for 2d geoms, like points, where it is the default. 

#position = "fill" works like stacking, but makes each set of stacked bars the same height. this makes it easier to compare proportions across groups 
#position = "dodge" places overlapping objects directly beside one another. this makes it easier to compare individual values. 
#left
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "fill")
#right
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "dodge")

#theres one other type of adjustment that's not useful for bar charts, but can be very useful for scatterplots.
#recall our first scatterplot. the plot displays only 126 points, even though there are 234 observations in the dataset.
#the underlying values of hwy and displ are rounded so the points appear on a grid and many points overlap each other. this problem is known as overplotting. this arrangement makes it difficult to see the distribution of the data. 
#you can avoid the confusion by setting the position adjustment to "jitter"
#position = "jitter" adds a small amount of random noise to each point. this spreads the points out because no two points are likely to receive the same amount of random noise. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "jitter")

#adding randomness seems like a strange way to improve your plot, but while it makes your graph less accurate at small scales, it makes your graph more revealing at large scales. because this is such a useful operation, ggplot2 comes with a shorthand for - geom_point(position = "jitter"):
geom_jitter()

#again, to learn more about a position adjustment, look up the help page associated with each adjustment. 
#ex. ?position_fill 

#9.7 coordinate systems
#coordinate systems are probably the most complicated part of ggplot2. the default coordinate system is the cartesian coordinate system where the x and y positions act independently to determine the location fo each point. there are two other coordinate system that are occasionally helpful. 
# coord_quickmap() sets the aspect ratio correctly for geographic maps. this is very important if you're plotting spacial data with ggplot2. 
#ex. 
nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

#coord_polar() uses polar coordinates. polar coordinates reveal an interestinf connection between a bar chart and a coxcomb chart. 
#ex. 
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()

#9.8 the layered grammar of graphics 
#we can expand on the graphing template from 1.3 by adding position adjustments, stats, coordinate systems, and faceting:
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

#our new template takes seven parameters, the bracketed words that appear in the template.  
#the seven parameters in the template compose the grammar of graphics, a formal system for building plots. the grammar of graphics is based on the insight that you can uniquely describe any plot as a combination of a dataset, a geom, a set of mappings, a stat, a position adjustment, a coordinate system, a faceting scheme, and a theme.

#for more about the theoretical underpinnings of ggplot2 - read "the layered grammar of graphics 

#COMMUNICATION 
#11.1 install needed packages 
library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)

#11.2 labels 
#the first place to start when turning an exploratory graphic into an expository graphic is with good labels. you add labels with the labs() function. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type",
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )
#the purpose of a plot title is to summarize the main findings. if you need more text, there are two other useful labels, subtitle ass additional detail in a smaller font beneath the title and caption adds text at the bottom right of the plot, often used to describe the source of the data. labs can replace the axis and legend titles. 

#it is possible to use mathematical equations instead of text strings. switch "" out for quote()
df <- tibble(
  x = 1:10,
  y = cumsum(x^2)
)

ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(x[i]),
    y = quote(sum(x[i] ^ 2, i == 1, n))
  )

#11.3 annotations
#in addition to labelling major compenents of a plot, it is also useful to label individual observation or groups of observations.
#we can do this using geom_text - geom_text is similar to geom_point, but it has the additional aesthetic of label that makes it possible to add textual labels to the plot. 
#there are two sources of labels. first you could have a tibble that provides labels.
#ex., in the following plot, we pull out the cars with the highest engine size in each drive type and save their information as a new data frame called label_info. 
label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |>
  select(displ, hwy, drv, drive_type)

label_info
#then we can use this new data frame to directly label the three groups to replace the legend with labels placed directly on the plot. 
#using the fontface and size arguments we can customize the look of the text labels. they r larger than the rest of the text on the plot and bolded
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")
#> `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
#note the use of hjust (horizontal justification) and vjust (vertical justification) to control the alignment of the label
#the plot we made above is hard to read because the labels overlap with eachother and with the points. 
#we can use the geom_label_repel() function to address both of these issues. (ggrepel package)
#this useful package will automatically adjust labels so that they don't overlap
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")
#> `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
#you can use the same idea to highlight certain points on a plot with geom_text_repel()
#note another handy technique used here -> we added a second layer of large, hollow points to further highlight the labelled points 
potential_outliers <- mpg |>
  filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text_repel(data = potential_outliers, aes(label = model)) +
  geom_point(data = potential_outliers, color = "red") +
  geom_point(
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )

#in addition to geom_text() and geom_label(), you have many other geoms in ggplot2 available to help annotate your plot
#geom_hline() and geom_vline() to add reference lines. we often make them thick (linewidth = 2) and white (color = white), and draw them underneath the primary data layer. That makes them easy to see, without drawing attention away from the data.
#geom_rect() to draw a rectangle around points of interest. the boundaries of the rectangle are defined by aesthetics xmin, xmax, ymin, ymax. alternatively, look into the ggforce package, specifically geom_mark_hull(), which allows you to annotate subsets of points with hulls.
#geom_segment() with the arrow argument to draw attention to a point with an arrow. use aesthetics x and y to define the starting location, and xend and yend to define the end location.

#another handy function for adding annotations to plots is annotate(). 
#as a rule of thumb, geoms are generally useful for highlighting a subset of the data while annotate is useful for adding one or few annotation elements to a plot. 

#to demonstrate using annotate, we can create some text to add to our plot
#this text is a bit long, so we can use stringr::str_wrap() to automatically add line breaks to it given the number of characters you want per line:
trend_text <- "Larger engine sizes tend to have lower fuel economy." |>
  str_wrap(width = 30)
trend_text
#> [1] "Larger engine sizes tend to\nhave lower fuel economy."
#then we add two layers of annotation: one with a label geom and the other with a segment geom. the x and y aesthetics in both define where the annotation should state, and the xend and yend aesthetics in the segment annotation define the end location of the segment. 
#note that the segment is styled as an arrow
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )
#annotation is a powerful tool for communicating main takeaways and interesting festures of your visualizations. the only limit is your imagination. 

#11.4 scales 
#the third way you can make your plot better for communication is to adjust the scales. scales control how the aesthetic mappings manifest visually. 

#11.4.1 default scales 
#normally ggplot2 automatically adds scales for you. ex. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))
#ggplot will automatically add default scales behind the scenes: 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

#note the naming scheme for scales: scale_ followed by the name of the aesthetic, then _, then the name of the scale. the default scales are named according to the type of variable they align with: continuous, discrete, datetime, or date. scale_x_continuous() puts the numeric values from displ on a continuous number line on the x-axis, scale_color_discrete() chooses colors for each of the class of car, etc.
#the default scales have been carefully chosen to do a good job with a wide range of inputs. 
#you might want to override the defaults for two reasons: you might want to tweak some of the parameters of the default scale, this allows you to do things like change the breaks on the axes or the key labels on the legend. 
#you might want to replace the scale altogether and use a different algorithm. often you can do better than the default because you know more about the data. 

#11.4.2 axis ticks and legend keys 
#collectively axes and legends are called guides. axes are used for x and y aesthetics; legends are used for everything else 
#there are two primary arguments that affect the appearance of the ticks on the axes and the keys on the legend. breaks and labels. 
#breaks control the position of the ticks or the values associated with the keys. labels controls the text label associated with each tick/key. the most common use of breaks is to override the default choice. 
#ex: 
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 
#you can use labels the same way, but you can also set it to NULL to suppress the labels altogether. This can be useful for maps, or for publishing plots where you can't share the absolute numbers. you can also use breaks and labels to control the appearance of legends. for discrete scales for categorical variables, labels can be named list of the existing level names and the desired labels for them. 
#ex. 
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))
#the labels argument coupled with labelling functions from the scales package is also useful for formatting numbers as currency, percent, etc. 
#the plot on the left shows default labelling with label_dollar(), which adds a dollar sign as well as a thousand separator coma. the plot on the right adds further customization by dividing dollar values by 1,000 and adding a suffix "K" (for thousands) as well as adding custom breaks.
#note, breaks is in the original scale of the data. 
# left
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = label_dollar())

# right
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
  )
#another handy label function is label_percent(): 
ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = label_percent())
#another use of breaks is when you have relatively few data points and want to highlight exactly where the observations occur. for example, take this plot that shows when each US president started and ended their term. 
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")
#note that for the breaks argument we pulled out the start variable as a vector with presidential$start because we can't do an aesthetic mapping for this argument. also, note that the specification of breaks and labels for date and datetime scales is a little different: 
#date_labels takes a format specification, in the same form as parse_datetime()
#date_breaks takes a string like "2 days" or "1 month" 

#11.4.3 legend layout 
#you will most often use breaks and labels to tweak the axes. while they both also work for legends, there are a few other techniques you are more likely to use. 
#to control the overall positioning of the legend, you need to use theme() setting. 
#they control the non-data parts of the plot. the theme setting legend.position controls where the legend is drawn. 
base <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

base + theme(legend.position = "right") # the default
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") +
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 3))

#if your plot is short and wide, place the legend at the top or bottom, and if it's tall and narrow, place the legend at the left or right. you can also use legend.position = "none" to suppress the display of the legend altogether.
#to control the display of individual legends, use guides() along with guide_legend() or guide_colorbar. 
#the following example shows two important settings, controlling the number of rows the legend uses with nrow, and overriding one of the aesthetics to make the points bigger. this is particularly useful if you have used a low alpha to display many points on a plot. 
#ex: 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2, override.aes = list(size = 4)))
#> `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

#11.4.4 replacing a scale 
#instead of tweaking the details a little, you can replace the scale altogether. there are two types of scales you're most likely to want to switch out: continuous position scales and color scales. fortuneately, the same principles apply to all the other aesthetics
#ex: it's easier to see the precise relationship between carat and price if we log transform them: 
# left
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d()

# right
ggplot(diamonds, aes(x = log10(carat), y = log10(price))) +
  geom_bin2d()

#the disadvantage of this transformation is that the axes are now labelled with the transformed values, making it hard to interpret the plot.
#instead of doing the transformation in the aesthetic mapping, we can instead do it with the scale. 
#this is visually identical, except the axes are labelled on the original data scale. 
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

#another scale that is frequently customized is color. the default categorical scale picks colors that are evenly spaced around the color wheel. useful alternatives are the colorbrewer scales which have been hand tuned to work better for people with common types of color blindness. 
#the two plots below look similar, but there is enough difference in the shades of red and green that the dots on the right can be distinguished even by people with red-green color blindness. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")

#don't forget simpler techniques for improving accessibility. if there are just a few colors, you can add a redundant shape mapping. this will also help ensure your plot is interpretable in black and white. 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

#when you have a predefined mapping between values and colors, use scale_color_manual(). 
#ex, if we map presidential party to color, we want to use the standard mapping of red for republican and blue for democrat. one approach for assigning these colors is using hex color codes. 
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))

#for continuous color, use the built in scale_color_gradient() or scale_fill_gradient()
#if you have a diverging scale, you can use scale_color_gradient2(). That allows you to give, for example, positive and negative values different colors. that's sometimes useful if you want to distinguish points above or below the mean. 
#another option is to use the viridis color scales. 
#these scales are available as continuous, discrete, and binned palettes in ggplot2
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c() +
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, binned", x = NULL, y = NULL)

#note that all color scales come in two varieties: scale_color_*() and scale_fill_*() for the color and fill aesthetics respectively. 

#11.4.5 zooming 
#there are three ways to control the plot limits: adjusting what data are plotted, setting the limits in each scale, and setting xlim and ylim in coord_cartesian()

#demonstrated in the following series of plots. the plot on the left shows the relationship between engine size and fuel efficiency, colored by type of drive train. the plot on the right shows the same variables but subsets the data that are plotted. subsetting the data has affected the x and y scales as well as the smooth curve. 
# left
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

# right
mpg |>
  filter(displ >= 5 & displ <= 6 & hwy >= 10 & hwy <= 25) |>
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

#compare these to the two plots below where the plot on the left sets the limits on individual scales and the plot on the right sets them in coord_cartesian(). see that reducing the limits is equivalent to subsetting the data. to zoom in on a region of the plot, it’s generally best to use coord_cartesian().
# left
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  scale_x_continuous(limits = c(5, 6)) +
  scale_y_continuous(limits = c(10, 25))

# right
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 6), ylim = c(10, 25))

#setting the limits on individual scales is generally more useful if you want to expand the limits, e.g., to match scales across different plots
#ex., if we extract two classes of cars and plot them separately, it’s difficult to compare the plots because all three scales (the x-axis, the y-axis, and the color aesthetic) have different ranges.
suv <- mpg |> filter(class == "suv")
compact <- mpg |> filter(class == "compact")

# left
ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

# right
ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

#a way to overcome this problem is to share scales across multiple plots, training the scales with the limits of the full data.
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

# left
ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

# right
ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale
#in this case, you could have simply used faceting, but this technique is useful more generally, if for instance, you want to spread plots over multiple pages of a report. 

#11.5 themes 
#you can customize the non-data elements of your plot with a theme: 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()

#ggplot includes the eight themes shown in figure 11.2 with theme_gray as the default. you can create your own themes need be. 
#it is possible to control individual components of each theme, like the size and color of the font used for the y-axis. 
#in the plot below we change the direction of the legend as well as put a black border around it. customization of the legend box and plot title elements of the theme are done with element_*() functions. 
#they specify the styling of non-data components, e.g., the title text is bolded in the face argument of element_text() and the legend border color is defined in the color argument of element_rect().
#theme elements that control the position of the title and the caption are plot.title.position and plot.caption.position, respectively. these are set to "plot" to indicate these elements are aligned to the entire plot area, instead of the plot panel (the default). 
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  labs(
    title = "Larger engine sizes tend to have lower fuel economy",
    caption = "Source: https://fueleconomy.gov."
  ) +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )
#> Warning: A numeric `legend.position` argument in `theme()` was deprecated in ggplot2
#> 3.5.0.
#> ℹ Please use the `legend.position.inside` argument of `theme()` instead.

#11.6 layout 
#what if you have multiple plots you want to lay out in a certain way?
#the patchwork package allows you to combine separate plots into the same graphic
#to place two plots next to each other, you can simply add them to each other. you first need to create the plots and save them as objects (in the following example they’re called p1 and p2). then, you place them next to each other with +.
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p1 + p2
#it's important to note that in the above code chunk we did not use a new function from the patchwork package. instead, the package added a new functionality to the + operator. 
#you can also create complex plot layouts with patchwork, ex. the following. 
p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
(p1 | p3) / p2

#patchwork allows you to collect legends from multiple plots into one common legend, customize the placement of the legend as well as dimensions of the plots, and add a common title, subtitle, caption, etc. to your plots
p1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")

p3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")

p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")

#REGULAR EXPRESSIONS
#15.1 this chapter will focus on functions that use regular expressions, a concise and powerful language for describing patterns within strings. 
#the term “regular expression” is a bit long, so most people abbreviate it to “regex”1 or “regexp”
library(tidyverse)
library(babynames)

#15.2 pattern basics 
#when supplied with a regex: str_view() will show only the elements of the string vector that match, surrounding each match with <>, and, where possible, highlighting the match in blue.
#the simplest patterns consist of letters and numbers which match those characters exactly:
str_view(fruit, "berry")

#Letters and numbers match exactly and are called literal characters. 
#most punctuation characters, like ., +, *, [, ], and ?, have special meanings2 and are called metacharacters. 
#for example, . will match any character3, so "a." will match any string that contains an “a” followed by another character:
str_view(c("a", "ab", "ae", "bd", "ea", "eab"), "a.")

#we could find all the fruits that contain an “a”, followed by three letters, followed by an “e”:
str_view(fruit, "a...e")

#quantifiers control how many times a pattern can match:
# ? makes a pattern optional (i.e. it matches 0 or 1 times)
# + lets a pattern repeat (i.e. it matches at least once)
# * lets a pattern be optional or repeat (i.e. it matches any number of times, including 0).
# ab? matches an "a", optionally followed by a "b".
#ex.:
str_view(c("a", "ab", "abb"), "ab?")
#> [1] │ <a>
#> [2] │ <ab>
#> [3] │ <ab>b

# ab+ matches an "a", followed by at least one "b".
str_view(c("a", "ab", "abb"), "ab+")
#> [2] │ <ab>
#> [3] │ <abb>

# ab* matches an "a", followed by any number of "b"s.
str_view(c("a", "ab", "abb"), "ab*")
#> [1] │ <a>
#> [2] │ <ab>
#> [3] │ <abb>

#character classes are defined by [] and let you match a set of characters, e.g., [abcd] matches “a”, “b”, “c”, or “d”.
#you can also invert the match by starting with ^: [^abcd] matches anything except “a”, “b”, “c”, or “d”
#we can use this idea to find the words containing an “x” surrounded by vowels, or a “y” surrounded by consonants
str_view(words, "[aeiou]x[aeiou]")
#> [284] │ <exa>ct
#> [285] │ <exa>mple
#> [288] │ <exe>rcise
#> [289] │ <exi>st
str_view(words, "[^aeiou]y[^aeiou]")
#> [836] │ <sys>tem
#> [901] │ <typ>e

#you can use alternation, |, to pick between one or more alternative patterns. 
#for example, the following patterns look for fruits containing “apple”, “melon”, or “nut”, or a repeated vowel.
str_view(fruit, "apple|melon|nut")
#>  [1] │ <apple>
#> [13] │ canary <melon>
#> [20] │ coco<nut>
#> [52] │ <nut>
#> [62] │ pine<apple>
#> [72] │ rock <melon>
#> ... and 1 more
str_view(fruit, "aa|ee|ii|oo|uu")
#>  [9] │ bl<oo>d orange
#> [33] │ g<oo>seberry
#> [47] │ lych<ee>
#> [66] │ purple mangost<ee>n

#15.3 key functions 
#the following section, you’ll learn how to detect the presence or absence of a match, how to count the number of matches, how to replace a match with fixed text, and how to extract text using a pattern.

#15.3.1 detect matches 
# str_detect() returns a logical vector that is TRUE if the pattern matches an element of the character vector and FALSE otherwise:
str_detect(c("a", "b", "c"), "[aeiou]")
#> [1]  TRUE FALSE FALSE

#since str_detect() returns a logical vector of the same length as the initial vector, it pairs well with filter()
#ex. this code finds all the most popular names containing a lower-case “x”
babynames |> 
  filter(str_detect(name, "x")) |> 
  count(name, wt = n, sort = TRUE)

#we can also use str_detect() with summarize() by pairing it with sum() or mean(): sum(str_detect(x, pattern)) tells you the number of observations that match and mean(str_detect(x, pattern)) tells you the proportion that match
#ex. the following snippet computes and visualizes the proportion of baby names that contain “x”, broken down by year
babynames |> 
  group_by(year) |> 
  summarize(prop_x = mean(str_detect(name, "x"))) |> 
  ggplot(aes(x = year, y = prop_x)) + 
  geom_line()

#there are two functions that are closely related to str_detect(): str_subset() and str_which()
#str_subset() returns a character vector containing only the strings that match. str_which() returns an integer vector giving the positions of the strings that match.

#15.3.2 count matches 
#the next step up in complexity from str_detect() is str_count(): rather than a true or false, it tells you how many matches there are in each string.
x <- c("apple", "banana", "pear")
str_count(x, "p")

#each match starts at the end of the previous match, i.e. regex matches never overlap
#ex in "abababa", how many times will the pattern "aba" match? Regular expressions say two, not three
str_count("abababa", "aba")
str_view("abababa", "aba")

#its natural to use str_count() with mutate()
#ex. uses uses str_count() with character classes to count the number of vowels and consonants in each name
babynames |> 
  count(name) |> 
  mutate(
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

#notice that there’s something off with our calculations: “Aaban” contains three “a”s, but our summary reports only two vowels. that’s because regular expressions are case sensitive
#there are three ways we could fix this:
#add the upper case vowels to the character class: str_count(name, "[aeiouAEIOU]").
#tell the regular expression to ignore case: str_count(name, regex("[aeiou]", ignore_case = TRUE)). 
#use str_to_lower() to convert the names to lower case: str_count(str_to_lower(name), "[aeiou]").
#this variety of approaches is pretty typical when working with strings — there are often multiple ways to reach your goal, either by making your pattern more complicated or by doing some preprocessing on your string

#since we’re applying two functions to the name, it’s easier to transform it first:
babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name),
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

#15.3.3 replace values 
#as well as detecting and counting matches, we can also modify them with str_replace() and str_replace_all()
#str_replace() replaces the first match, and as the name suggests, str_replace_all() replaces all matches
x <- c("apple", "pear", "banana")
str_replace_all(x, "[aeiou]", "-")

#str_remove() and str_remove_all() are handy shortcuts for str_replace(x, pattern, ""):
x <- c("apple", "pear", "banana")
str_remove_all(x, "[aeiou]")

#these functions are naturally paired with mutate() when doing data cleaning, and you’ll often apply them repeatedly to peel off layers of inconsistent formatting.
#15.3.4
#last function we’ll discuss uses regular expressions to extract data out of one column into one or more new columns: separate_wider_regex()
#they operate on (columns of) data frames, rather than individual vectors.
#ex. here we have some data derived from babynames where we have the name, gender, and age of a bunch of people in a rather weird format:
df <- tribble(
  ~str,
  "<Sheryl>-F_34",
  "<Kisha>-F_45", 
  "<Brandon>-N_33",
  "<Sharon>-F_38", 
  "<Penny>-F_58",
  "<Justin>-M_41", 
  "<Patricia>-F_84", 
)

#to extract this data using separate_wider_regex() we just need to construct a sequence of regular expressions that match each piece. 
df |> 
  separate_wider_regex(
    str,
    patterns = c(
      "<", 
      name = "[A-Za-z]+", 
      ">-", 
      gender = ".",
      "_",
      age = "[0-9]+"
    )
  )
#if the match fails, you can use too_few = "debug" to figure out what went wrong, just like separate_wider_delim() and separate_wider_position()

#15.4 pattern details 
#15.4.1 escaping
#in order to match a literal ., you need an escape which tells the regular expression to match metacharacters6 literally
#regexps use the backslash for escaping. so, to match a ., you need the regexp \.. unfortunately this creates a problem. we use strings to represent regular expressions, and \ is also used as an escape symbol in strings. so to create the regular expression \. we need the string "\\.", as the following example shows.
## to create the regular expression \., we need to use \\.
dot <- "\\."

# but the expression itself only contains one \
str_view(dot)
#> [1] │ \.

# and this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

#f \ is used as an escape character in regular expressions, how do you match a literal \? 
#you need to escape it, creating the regular expression \\. 
#to create that regular expression, you need to use a string, which also needs to escape \. that means to match a literal \ you need to write "\\\\" — you need four backslashes to match one
x <- "a\\b"
str_view(x)
#> [1] │ a\b
str_view(x, "\\\\")
#> [1] │ a<\>b

#you might find it easier to use the raw strings
#lets you avoid one layer of escaping
str_view(x, r"{\\}")
#> [1] │ a<\>b

#trying to match a literal ., $, |, *, +, ?, {, }, (, ), there’s an alternative to using a backslash escape: you can use a character class: [.], [$], [|], … all match the literal values
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

#15.4.2 anchors 
#regular expressions will match any part of a string. If you want to match at the start or end you need to anchor the regular expression using ^ to match the start or $ to match the end:
str_view(fruit, "^a")
#> [1] │ <a>pple
#> [2] │ <a>pricot
#> [3] │ <a>vocado
str_view(fruit, "a$")
#>  [4] │ banan<a>
#> [15] │ cherimoy<a>
#> [30] │ feijo<a>
#> [36] │ guav<a>
#> [56] │ papay<a>
#> [74] │ satsum<a>

#to force a regular expression to match only the full string, anchor it with both ^ and $:
str_view(fruit, "apple")
#>  [1] │ <apple>
#> [62] │ pine<apple>
str_view(fruit, "^apple$")
#> [1] │ <apple>

#you can also match the boundary between words (i.e. the start or end of a word) with \b. this can be particularly useful when using RStudio’s find and replace tool. 
#for example, if to find all uses of sum(), you can search for \bsum\b to avoid matching summarize, summary, rowsum and so on:
x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(x, "sum")
#> [1] │ <sum>mary(x)
#> [2] │ <sum>marize(df)
#> [3] │ row<sum>(x)
#> [4] │ <sum>(x)
str_view(x, "\\bsum\\b")
#> [4] │ <sum>(x)

#used alone, anchors will produce a zero-width match:
str_view("abc", c("$", "^", "\\b"))
#> [1] │ abc<>
#> [2] │ <>abc
#> [3] │ <>abc<>

#helps you understand what happens when you replace a standalone anchor:
str_replace_all("abc", c("$", "^", "\\b"), "--")
#> [1] "abc--"   "--abc"   "--abc--"

#15.4.3 character classes
#a character class, or character set, allows you to match any character in a set. as we discussed above, you can construct your own sets with [], where [abc] matches “a”, “b”, or “c” and [^abc] matches any character except “a”, “b”, or “c”. apart from ^ there are two other characters that have special meaning inside of []:
# - defines a range ex. [a-z] matches any lowercase letter and [0-9] matches an number
# \ escapes special characters, so [\^\-\]] matches ^, - or ]
#ex. 
x <- "abcd ABCD 12345 -!@#%."
str_view(x, "[abc]+")
#> [1] │ <abc>d ABCD 12345 -!@#%.
str_view(x, "[a-z]+")
#> [1] │ <abcd> ABCD 12345 -!@#%.
str_view(x, "[^a-z0-9]+")
#> [1] │ abcd< ABCD >12345< -!@#%.>

# you need an escape to match characters that are otherwise special inside of []: 
str_view("a-b-c", "[a-c]")
#> [1] │ <a>-<b>-<c>
str_view("a-b-c", "[a\\-c]")
#> [1] │ <a><->b<-><c>

#some character classes are used so commonly that they get their own shortcut
#\d matches any digit;
#\D matches anything that isn’t a digit.
#\s matches any whitespace (e.g., space, tab, newline);
#\S matches anything that isn’t whitespace.
#\w matches any “word” character, i.e. letters and numbers;
#\W matches any “non-word” character.

#15.4.4 quantifiers 
#quantifiers control how many times a pattern matches.
#ex., colou?r will match american or british spelling, \d+ will match one or more digits, and \s? will optionally match a single item of whitespace. you can also specify the number of matches precisely with {}:
# {n} matches exactly n times.
# {n,} matches at least n times.
# {n,m} matches between n and m times.

#15.4.5 operator precedence and parenthesis
#what does ab+ match? 
#regular expressions have their own precedence rules: 
#quantifiers have high precedence and alternation has low precedence which means that ab+ is equivalent to a(b+), and ^a|b$ is equivalent to (^a)|(b$)
#you can use parentheses to override the usual order. But unlike algebra you’re unlikely to remember the precedence rules for regexes, so feel free to use parentheses liberally.

#15.4.6
#parentheses have another important effect: they create capturing groups that allow you to use sub-components of the match.
#first way to use a capturing group is to refer back to it within a match with back reference: \1 refers to the match contained in the first parenthesis, \2 in the second parenthesis, and so on
#ex. the following pattern finds all fruits that have a repeated pair of letters: 
str_view(fruit, "(..)\\1")
#this one finds all words that start and end with the same pair of letters 
str_view(words, "^(..).*\\1$")
#you can also use back references in str_replace(). for example, this code switches the order of the second and third words in sentences:
sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()
#can extract the matches for a group using str_match() but it returns a matrix so its not particularly easy to work with:
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  head()
#you can convert to a tibble and name the columns: 
sentences |> 
  str_match("the (\\w+) (\\w+)") |> 
  as_tibble(.name_repair = "minimal") |> 
  set_names("match", "word1", "word2")
#then you’ve basically recreated your own version of separate_wider_regex()

#occasionally, you’ll want to use parentheses without creating matching groups. you can create a non-capturing group with (?:)
x <- c("a gray cat", "a grey dog")
str_match(x, "gr(e|a)y")
#>      [,1]   [,2]
#> [1,] "gray" "a" 
#> [2,] "grey" "e"
str_match(x, "gr(?:e|a)y")
#>      [,1]  
#> [1,] "gray"
#> [2,] "grey"

#15.5 pattern control
#allows you to control the so called regex flags and match various types of fixed strings, as described below

#15.5.1 regex flags  
#there are a number of settings that can be used to control the details of the regexp
#these settings are often called flags in other programming languages. 
#in stringr, you can use these by wrapping the pattern in a call to regex(). 
#the most useful flag is probably ignore_case = TRUE because it allows characters to match either their uppercase or lowercase forms:
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))
#if you are doing alot of work with multiline strings, strings that contain \n, dotall and multiline may also be useful:
# dotall = TRUE lets . match everything including \n:
x <- "Line 1\nLine 2\nLine 3"
str_view(x, ".Line")
str_view(x, regex(".Line", dotall = TRUE))
# multiline = TRUE makes ^ and $ match the start and end of each line rather than the start and end of the complete string
x <- "Line 1\nLine 2\nLine 3"
str_view(x, "^Line")
str_view(x, regex("^Line", multiline = TRUE))

#if you’re writing a complicated regular expression and you’re worried you might not understand it in the future, you might try comments = TRUE
#it tweaks the pattern language to ignore spaces and new lines, as well as everything after #. 
#this allows you to use comments and whitespace to make complex regular expressions more understandable9, as in the following example:
phone <- regex(
  r"(
    \(?     # optional opening parens
    (\d{3}) # area code
    [)\-]?  # optional closing parens or dash
    \ ?     # optional space
    (\d{3}) # another three numbers
    [\ -]?  # optional space or dash
    (\d{4}) # four more numbers
  )", 
  comments = TRUE
)

str_extract(c("514-791-8141", "(123) 456 7890", "123456"), phone)

#if you are using comments and want to match a space, newline or #, youll need to escape it with \. 

#15.6 practice
# three general techniques: 
# checking your work by creating simple positive and negative controls
# combining regular expressions with Boolean algebra
# creating complex patterns using string manipulation

#15.6.1 check your work 
#find all of the sentences that start with "The". using the ^ anchor alone is not enough
str_view(sentences, "^The")
#because that pattern also matches sentences starting with words like They or These, we need to make sure that the "e" is the last letter in the word, which we can do by adding a word boundary:
str_view(sentences, "^The\\b")

#what about finding all of the sentences that begin with a pronoun:
str_view(sentences, "^She|He|It|They\\b")
#why do we get spurious matches? we didnt use parenthesis:
str_view(sentences, "^(She|He|It|They)\\b")

#you might wonder how you may spot a mistake if it didnt occur in the first few matches. create a few positive and negative matches and use them to test that your pattern works as expected:
pos <- c("He is a boy", "She had a good time")
neg <- c("Shells come from the sea", "Hadley said 'It's a great day'")

pattern <- "^(She|He|It|They)\\b"
str_detect(pos, pattern)

str_detect(neg, pattern)
#it is typically easier to come up with positive examples than negative. 

#15.6.2 boolean operations
#imagine we want to find words that only contain consonants. one technique is to create a character class that contains all letters except for the vowels, ex. [^aeiou]. then allow that to match any number of letters, ex. [^aeiou]+. then force it to match the whole string by anchoring to the beginning and the end, ex. (^[^aeiou]+$)
str_view(words, "^[^aeiou]+$")
#you can flip the problem around to look for words that do not contain any vowels.
str_view(words[!str_detect(words, "[aeiou]")])
#this is a useful technique whenever dealing with logical combinations, particularly involving "and" or "not" 
#ex. finding all words containing "a" and "b". there is no "and" operator built in to regular expressions, so we have to tackle it by looking for all words that contain an "a" followed by a "b" or a "b" followed by an "a":
str_view(words, "a.*b|b.*a")
#its simpler to combine the results of two calls to str_detect:
words[str_detect(words, "a") & str_detect(words, "b")]

#what if we wanted to see if there was a word that contains all vowels? 
#simplest way is to combine five calls to str_detect:
words[
  str_detect(words, "a") &
  str_detect(words, "e") &
  str_detect(words, "i") &
  str_detect(words, "o") &
  str_detect(words, "u")  
]

#so break down a problem into smaller pieces to easily solve challenges

#15.6.3 creating a pattern with code 
#what if we wanted to find all sentences that mention a color - combine alternation with word boundaries
str_view(sentences, "\\b(red|green|blue)\\b")

#easier to store the colors in a vector: 
rgb <- c("red", "green", "blue")
#create the pattern from the vector using str_c and str_flatten
str_c("\\b(", str_flatten(rgb, "|"), ")\\b")

#to make more comprehensive, start with the list of built in colors that R can use for plots
str_view(colors())
#eliminate numbered variants:
cols <- colors()
cols <- cols[!str_detect(cols, "\\d")]
str_view(cols)
#then turn it into a giant pattern:
pattern <- str_c("\\b(", str_flatten(cols, "|"), ")\\b")
str_view(sentences, pattern)
#in this example, cols only contains numbers and letters so you dont need to worry about metacharacters.

#15.7.1 tidyverse
#there are three other useful places to use regex
#matches(pattern) selects all variables whos name matches the supplied pattern. its a tidyselect function that you can use anywhere in any tidyverse function that selects variables. ex. select, rename_with and across
#pivot_longer names_pattern argument takes a vector of regular expressions like separate_wider_regex. useful when extracting data out of variable names with a complex structure
#delim argument in separate_longer_delim and separate_wider_delim usually matches a fixed string but you can use regex to make it a pattern. this is useful if you want to match a comma thatis optionally followed by a space, ex. regex(", ?")

#15.7.2 base r
#apropos(pattern) searches all objects available from the global environment that match the given pattern. this is useful if you can't quite remember the name of a function.
apropos("replace")
#list.files(path, pattern) lists all files in path that match a regular expression pattern. 
#ex. you can find all the r markdown files in the current directory with:
head(list.files(pattern = "\\.Rmd$"))

#FACTORS
#16.1
library(tidyverse)

#16.2 
#factor basics
#ex. variable that records month:

x1 <- c("Dec", "Apr", "Jan", "Mar")
#using a string to record this variable has two problems:
#there are only twelve possible months, and there’s nothing saving you from typos:
x2 <- c("Dec", "Apr", "Jam", "Mar")
#it doesn’t sort in a useful way:
sort(x1)
#> [1] "Apr" "Dec" "Jan" "Mar"

#to create a factor you must start be creating a list of the valid levels
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
#now create a factor 
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
#any values not in the level will be silently converted to NA
y2 <- factor(x2, levels = month_levels)
y2
#this seems risky. use forcats::fct()
y2 <- fct(x2, levels = month_levels)
#if you omit the levels, they will be taken from the data in alphabetical order 
factor(x1)

#sorting alphabetically is slightly risky because not every computer sorts strings in the same way. forcats::fct() orders by first appearance
fct(x1)

#if you need to access the set of valid levels directly, you can do so with levels():
levels(y2)

#you can create a factor when reading your data with readr with col_factor:
csv <- "
month,value
Jan,12
Feb,56
Mar,12"

df <- read_csv(csv, col_types = cols(month = col_factor(month_levels)))
df$month

#16.3 general social survey
#using farcats::gss_cat -  a sample of data from the general social survey which is a long running US survey conducted by NORC at university of chicago 
gss_cat

#when factors are stored in a tibble, you cannot see their levels so easily. we can view with count()
gss_cat |>
  count(race)

#when working with factors, the two most common operations are changing the order of the levels, and changing the values of the levels

#16.4 modifying factor order 
#ex. when you want to explore the avg number of hours spent watching TV per day across religions
relig_summary <- gss_cat |>
  group_by(relig) |>
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(x = tvhours, y = relig)) +
  geom_point()
#improve by reordering the levels using fct_reorder, it takes three arguments:
#.f the factor whose levels you want to modify
#.x a numeric vector that you want to use to reorder the levels
# optionally, .fun used if there are multiple values of .x for each value of .f. the default value is median
ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) +
  geom_point()
#reordering religion makes it much easier to see that people in the "dont know" category watch more TV. 
#as the transformations become more complicated, it is reccomended to move them out of aes and into mutate
#ex, the plot above an be rewritten as 
relig_summary |>
  mutate(
    relig = fct_reorder(relig, tvhours)
  ) |>
  ggplot(aes(x = tvhours, y = relig)) +
  geom_point()

#we can create a similar plot looking at how average age caries across reported income levels
rincome_summary <- gss_cat |>
  group_by(rincome) |>
  summarize(
    age = mean(age, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(x = age, y = fct_reorder(rincome, age))) +
  geom_point()
#in this case, reordering the levels isnt a good idea because rincome already has an order.
#it does make sense to pull "not applicable to the front with the other special levles. you can use fct_relevel. it takes a factor, .f, and then any number of levels that you want ot move to the frontof the line 
ggplot(rincome_summary, aes(x = age, y = fct_relevel(rincome, "Not applicable"))) +
  geom_point()
#why is the average for "not applicable" so high? 
#use fct_reorder(.f, .x, .y) for making the plot easier to read because of the colors of the line at the far right of the plot will line up with the legend. 
by_age <- gss_cat |>
  filter(!is.na(age)) |>
  count(age, marital) |>
  group_by(age) |>
  mutate(
    prop = n / sum(n)
  )

ggplot(by_age, aes(x = age, y = prop, color = marital)) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1")

ggplot(by_age, aes(x = age, y = prop, color = fct_reorder2(marital, age, prop))) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1") +
  labs(color = "marital")

#finally, for bar plots, use fct_infreq to order levels in decreasing frequency: the simplest type of reordering because it does not need any extra variables
#combine with fct_rev if you want the levels in increasing frequency so that the largest values are on the right in the bar plot:
gss_cat |>
  mutate(marital = marital |> fct_infreq() |> fct_rev()) |>
  ggplot(aes(x = marital)) +
  geom_bar()

#16.5 modifying factor levels
#more powerful than changing the order is changing the values of the levels
#most general and powerful tool is fct_recode. it allows you to recode or change the value of each level.
#ex, take partyid variable: 
gss_cat |> count(partyid)
#the levels are inconsistent. we can tweak them to be longer and use parallel construction. 
#new values go on the left and old values go on the right:
gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat"
                         )
  ) |>
  count(partyid)
#fct recode will leave the levels that arent explicitly mentioned as is, and will warn if accidentally referred to a level that does not exist

#to combine groups, you can assign multiple old levels to the same level: 
gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat",
                         "Other"                 = "No answer",
                         "Other"                 = "Don't know",
                         "Other"                 = "Other party"
    )
  )

#if you want to collapse a lot of levels, use fct_collapse.
#for each new variable you can provide a vector of old levels:
gss_cat |>
  mutate(
    partyid = fct_collapse(partyid,
                           "other" = c("No answer", "Don't know", "Other party"),
                           "rep" = c("Strong republican", "Not str republican"),
                           "ind" = c("Ind,near rep", "Independent", "Ind,near dem"),
                           "dem" = c("Not str democrat", "Strong democrat")
    )
  ) |>
  count(partyid)

#sometimes you need to lump together the small groups to make a plot or a table simpler. that is fct_lump_* job.
#fct_lump_lowfreq is a simple starting point that progressively lumps the smallest groups categories into "Other" always keeping other the smallest category:
gss_cat |>
  mutate(relig = fct_lump_lowfreq(relig)) |>
  count(relig)
#in this case it is not very helpful. instead we can use fct_lump_n to specify that we want exactly 10 groups:
gss_cat |>
  mutate(relig = fct_lump_n(relig, n = 10)) |>
  count(relig, sort = TRUE)

#16.6 ordered factors
#ordered factors imply a strict ordering between levels bu do not specify anything about the magnitude of the differences between the levels
#you can identify an ordered factor when it is printed because it uses < symbols between the factor levels
ordered(c("a", "b", "c"))
#in both base R and tidyverse, ordered factors behave similarly to regular factors. there are only two places where different behavior is noticed
#if you map an ordered factor to color or fill in ggplot2, it will default to scale_color_viridis()/scale_fill_viridis() which is a color scale that implies a ranking
#if using an ordered predictor in a linear model it will use "polynomial contrasts". to learn more access vignette("contrasts", package = "faux") by lisa debruine

#MISSING VALUES
#18.1
