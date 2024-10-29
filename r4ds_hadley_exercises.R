# 2.5 exercises: workflow basics 

# 1: the code doesn't work because the coder typed in "my_var1able" and not "my_variable" 
# 2: a) library(tidyverse)
# b) ggplot(data = mpg) +
#     geom_point(mapping = aes(x = displ, y = hwy)) +
#     geom_smooth(method = "lm")
# 3: this key combo brings up the keyboard shortcuts help dialog. if you navigate to the help button on the files pane, we can pull up the same menu. 
# 4: the plot that is saved as "mpg.plot.png" is the bar plot. this is due to the ggsave function being used, where the filename is "mpg-plot.png" and the plot assignment is my_bar_plot

# 4.6 exercises: code style 
# pipe 1 restyle 
flights |> 
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  summarize(
    n = n(), 
    delay = mean(arr_delay, na.rm = TRUE)
  ) |>
  filter(n > 10)

# pipe 2 restyle 
flights |> 
  filter(
    carrier == "UA", 
    dest %in% c("IAH", "HOU"), 
    sched_dep_time > 0900, 
    sched_arr_time < 2000
  ) |>
  group_by(flight) |>
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    cancelled = sum(is.na(arr_delay)),
    n = n()
  ) |> 
  filter(n > 10)

# 5.2.1 exercises 
# 1: in the first table example, the table shows the rate of cases per 10,000 people for different countries and years. the country column represents the name of the country, the year column represents the year in which the data was recorded, the cases column represents the number of reported cases in that country for that year, the population column gives the total population of the country for that year, and the rate column gives us the rate of cases per 10,000 people 
# in the second table example, the table summarizes the total number of cases reported per year, over all countries. the year gives the total number of cases reported, and the total_cases is the total number of cases reported for that year, summed across all countries
# in the third table example, the plot visualizes the number of cases changing over time in different countries. year represents the x-axis, cases reported represent the y-axis, group = country represents the trend over time, where each country is represented by its own line, color = country visually assigns each country a color, making it easier to differentiate trends, shape = country assigns different shapes for points that represent different countries, and scale_x_continuous(breaks = c(1999, 2000)) customizes the x-axis so that there are breaks at the years 1999 and 2000  
# 2: a) extract the number of TB cases, we can use select to focus on the columns country, year, and cases 

#9.2.1 exercises 
#1:
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "pink", shape = 24, fill = "pink")

#2: because color = "blue" is being treated as a categorical variable 
#3: the stroke aesthetic controls the width of the border of shapes that have both fill and outline
#4: ggplot will evaluate that condition for each data point and create a new categorical variable based on whether the condition is true/false. 

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




