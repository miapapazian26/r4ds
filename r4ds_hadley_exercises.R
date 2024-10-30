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

#9.3.1 exercises
#1 geom_line, geom_boxplot, geom_histogram, and geom_area
#2 show.legend = FALSE removes the legend from view in a plot. we used it earlier so it was easier to ignore?
#3 the se argument geom_smooth controls whether we display the confidence interval around the smooth line. 
#4
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "black") +
  geom_smooth(se = FALSE, color = "blue")

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(color = "black") +
  geom_smooth(aes(linetype = drv), color = "blue", se = FALSE)
 
ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(color = "blue", se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(aes(linetype = drv), color = "blue", se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(fill = drv), shape = 21, color = "white", stroke = 1.5)

#9.4.1 exercises 
#1 ggplot will treat the continuous variable as a discrete value, will create "bins" to separate the data, so unlimited bins? 
#2 the empty cells signify areas where no data points fell, following code:
ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))
#relate to the empty cells where cyl and drv do not overlap, therefore no data point. 
#3"." is a way to include all possible items in a function. the following code:
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
#makes one plot faceted into three sections, separated by drv. the second is a 4 section faceted plot separated by cyl.
#4 take the first faceted plot in this section:
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ cyl, nrow = 2)
#faceting creates distinct panels for each group, which makes it easier to see trends or patterns. issues with overlapping points are avoided when using facets. more space is required tho, in order to use facets. 
#the balance may shift with a larger dataset due to overcrowding. 
#5 nrow specifies the number of rows in the layout of the faceted plot. ncol specifies the number of columns in the layout of the faceted plot. there is also dir, as.table, scales, strip.position, etc. facet_grid doesnt have nrow and ncol because it is designed to create a grid of panels based on two variables, one for rows and one for columns. 
#6 
ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)
#the first, due to the spacing. 
#7
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(drv ~ .)
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
#the positions of the facet labels switch from the top side to the right hand side.

#9.5 statistical transformations



