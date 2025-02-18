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

#9.5.1 exercises 
#1 the default geom of stat_summary is geom = "pointrange". this is a point and error bar range based on the summary stats you provide. 
#2 geom_col requires you to provide the height of each bar explicitly. used when you have already computed values for each bar. geom bar does an automatic counting of rows for each x-axis category. if only an x-axis variable is provided, geom_bar will count the occurrences for each category and display the frequencies as bar heights. 
# geom_col = pre-aggregated values, geom_bar = raw data was want to aggregate by counting 
#3
#geom	        default stat	         description
#geom_bar()	stat_count	Creates bar plots by counting occurrences in each category.
#geom_col()	stat_identity	Creates bar plots using pre-summarized values provided directly as y-axis values.
#geom_histogram()	stat_bin	Creates histograms by binning data along the x-axis.
#geom_freqpoly()	stat_bin	Similar to histogram but with lines connecting points for binned data.
#geom_density()	stat_density	Creates a smoothed density estimate of data.
#geom_boxplot()	stat_boxplot	Creates boxplots to show distributional summary (quartiles, median, outliers) of data.
#geom_violin()	stat_ydensity	Creates violin plots, showing density distribution mirrored along the y-axis.
#geom_smooth()	stat_smooth	Adds a smoothed line (often a LOESS or linear model) through data points.
#geom_point()	stat_identity	Plots data points at specific coordinates (no transformation).
#geom_line()	stat_identity	Connects points in the order they appear in the data (no transformation).
#geom_area()	stat_identity	Fills the area under a line plot (no transformation).
#geom_ribbon()	stat_identity	Creates bands around lines (e.g., confidence intervals) with ymin and ymax values.
#geom_text()	stat_identity	Adds text labels to specified coordinates (no transformation).
#geom_tile()	stat_identity	Creates heatmap-style plots using pre-specified x, y, and fill values.
#geom_bin2d()	stat_bin2d	Creates heatmaps by binning data into 2D rectangular bins and counting occurrences.
#geom_hex()	stat_binhex	Similar to geom_bin2d() but bins data into hexagonal cells.
#geom_contour()	stat_contour	Draws contour lines based on a 2D density estimate or pre-computed matrix.
#geom_sf()	stat_sf	Plots simple features (geospatial data) without data transformation.
#geom_quantile()	stat_quantile	Fits and displays quantile regression lines through data.
#geom_function()	stat_function	Plots a mathematical function by generating x-y pairs across a specified range.
#geom_boxplot()	stat_boxplot	Plots box plots to show distributional summaries.
#geom_qq()	stat_qq	Creates a Q-Q plot to compare quantiles of a dataset to a theoretical distribution.
#geom_qq_line()	stat_qq_line	Adds a line to a Q-Q plot for reference against a theoretical distribution.
#geom_sf()	stat_sf_coordinates	Draws spatial features based on coordinates from simple features.
#geom_map()	stat_identity	Creates maps based on spatial polygons (no transformation).
#geom_step()	stat_identity	Creates step plots, often used for time series or survival data (no transformation).

#4 the stat_smooth function is used to add a smoothed line to a plot. it computes the fitted values and the confidence interval bounds.
#5 when creating a proportion bar chart, setting group = 1 is necessary to indicate that all bars belong to a single group for calculating proportions correctly.

#9.6.1 exercises 
#1
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()
#change to: 
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter()
#2 there is no difference between the two plots. position identity is the default behavior for geom point anyways. 
#3 there are two main parameters, width and height. default is 0.4 for both. you can also just jitter in one direction if you need. 
#4
#the jitter geom is a convenient shortcut for geom_point(position = "jitter"). it adds a small amount of random variation to the location of each point, and is a useful way of handling overplotting caused by discreteness in smaller datasets.
#this is a variant geom_point() that counts the number of observations at each location, then maps the count to point area. it useful when you have discrete data and overplotting.
#5 the default position adjustment for geom_boxplot() is "dodge"
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

#9.7.1 exercises
#1 
ggplot(mpg, aes(x = "", fill = class)) +
  geom_bar(width = 1) +
  coord_polar("y")
#2 the difference is how they handle map projections. coord_quickmap is faster and useful for basic visualizations where a quick map view is sufficient. coord_map() allows you to specify a map projection, performs a true map projection, more computationally expensive. 
#3 
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()
#the plot is the relationship between city and highway mpg. points along the geom_abline indicate that city and highway mpg are the same for those cars. since all of the points are above the line, it indicates that the highway mpg is greater than the city mpg for most cars.
#coord_fixed is so important because it ensures the axes are scaled the same way, meaning that the units on both the x and y axes are equal in physical length. 

#11.2.1 exercises 
#1 
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  labs(
    title = "Fuel Economy Analysis",
    x = "Engine Displacement (L)",
    y = "Highway MPG",
    color = "Vehicle Class"
  )
#2
ggplot(mpg, aes(x = cty, y = hwy, color = drv, shape = drv)) +
  geom_point(size = 3) +
  labs(
    title = "Fuel Efficiency: Highway vs City",
    x = "City MPG",
    y = "Highway MPG",
    color = "Drive Train",
    shape = "Drive Train"
  )
#3
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() +
  labs(
    title = "Highway MPG Compared to City MPG",
    x = "City MPG",
    y = "Highway MPG",
  )

#11.3.1
#1 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text(aes(x = Inf, y = Inf), label = "Top Right", hjust = 1, vjust = 1) +
  geom_text(aes(x = -Inf, y = Inf), label = "Top Left", hjust = 0, vjust = 1) +
  geom_text(aes(x = Inf, y = -Inf), label = "Bottom Right", hjust = 1, vjust = 0) +
  geom_text(aes(x = -Inf, y = -Inf), label = "Bottom Left", hjust = 0, vjust = 0)
#2
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate("point", x = 4, y = 30, color = "blue", size = 4, shape = 21)
#3
# the labels will appear in each facet by default. to add a label to only one facet, you can filter your data so that the label only applies to that specific subset of the data.
#4
# the appearance of the background box is controlled by arguments like fill, color, and label.size
# to have different labels in each facet, create a separate label for each facet in your dataset and use geom_text() with facet_wrap() or facet_grid().
#5
# angle: sets the angle of the arrowhead.
# type: specifies the shape of the arrow (e.g., "closed" or "open").
# length: defines the length of the arrowhead (can be set with unit()).
# ends: controls w

#11.4.6 
#1 
# geom_hex uses the fill aesthetic by default, not color. the scale_color_gradient affects the color aesthetic but geom_hex needs fill to control the color scale of the hex bins. 
#2
# the first argument to every scale_* function is aesthetics. it specifies the aesthetics that the scale should apply to. in labs, this function is used to set labels for the axes, title and legends rather than modifying how data is mapped to aesthetics. 
#3
# create the plot with your 'presidential' dataset
presidential |>
  mutate(id = row_number()) |>
  ggplot(aes(x = start, y = id)) +
  # plot points at the start of each term, colored by party
  geom_point(aes(color = party), size = 3) +  
  # plot segments for each presidential term
  geom_segment(aes(xend = end, yend = id, color = party), size = 6) +
  # customize x-axis to break every 4 years
  scale_x_date(name = "Year", 
               breaks = seq(from = min(presidential$start), 
                            to = max(presidential$end), 
                            by = "4 years"), 
               date_labels = "'%y") +
  # improve y-axis display
  scale_y_continuous(breaks = presidential$id, 
                     labels = presidential$name, 
                     expand = c(0.1, 0.1)) +
  # add informative plot labels
  labs(title = "Presidential Terms in the United States",
       subtitle = "Color-coded by party, labeled by president",
       x = "Year",
       y = "President",
       caption = "Data source: US Presidential history") +
  # use a minimal theme with adjusted x-axis labels
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels for readability
        axis.text.y = element_text(size = 10)) +  # Adjust y-axis label size
  # label each term with the president's name
  geom_text(aes(label = name), vjust = -0.5, hjust = 0.5)  # Position labels slightly above the points
#4
# create the plot
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), alpha = 1/20)  # Use transparency to reduce point overlap
# modify the plot to improve legend visibility
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), alpha = 1/20) +
  scale_color_discrete(
    name = "Diamond Cut", 
    guide = guide_legend(
      override.aes = list(size = 4, alpha = 1)  # Increase symbol size and remove transparency in the legend
    )
  )

#11.5.1
#1 
# basic plot with theme applied
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), alpha = 1/20) +
  scale_color_discrete(
    name = "Diamond Cut", 
    guide = guide_legend(
      override.aes = list(size = 4, alpha = 1)  # Increase symbol size and remove transparency in the legend
    )
  ) +
  theme_minimal()  # Apply the "minimal" theme from ggthemes

#2 
# customize axis labels 
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), alpha = 1/20) +
  scale_color_discrete(
    name = "Diamond Cut", 
    guide = guide_legend(
      override.aes = list(size = 4, alpha = 1)  # Increase symbol size and remove transparency in the legend
    )
  ) +
  theme_minimal() +  # Apply the "minimal" theme from ggthemes
  theme(
    axis.title.x = element_text(color = "blue", face = "bold"),  # Make x-axis title blue and bold
    axis.title.y = element_text(color = "blue", face = "bold")   # Make y-axis title blue and bold
  )

#11.6.1
#1
# omitting the parenthesis can change how the plots are arranged. without them, the plots could be stacked or be misaligned. 
#2
# plot one should be on the top row, plot two and three should be on the second row, each spanning half the width of plot one. the plot also must be labeled. 
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1: Highway Mileage vs Engine Size (Fig. A)")

p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2: Highway Mileage vs Drive Train (Fig. B)")

p3 <- ggplot(mpg, aes(x = drv, y = cty)) + 
  geom_boxplot() + 
  labs(title = "Plot 3: City Mileage vs Drive Train (Fig. C)")

# combine the plots with patchwork
(p1) / (p2 | p3)

#15.3.5 exercises
#1
# find name with the most vowels
babynames %>%
  mutate(vowels = str_count(name, "[aeiouAEIOU]")) %>%
  slice_max(vowels, n = 1)

# find name with the highest proportion of vowels
babynames %>%
  mutate(vowels = str_count(name, "[aeiouAEIOU]"),
         proportion = vowels / nchar(name)) %>%
  slice_max(proportion, n = 1)
#2
path <- "a/b/c/d/e"

# replace forward slashes with backslashes
path_backslash <- str_replace_all(path, "/", "\\\\")  

# attempt to undo by replacing backslashes with forward slashes
path_undo <- str_replace_all(path_backslash, "\\\\", "/")

path_backslash
path_undo

#3
str_to_lower_simple <- function(x) {
  str_replace_all(x, "[A-Z]", tolower)
}

str_to_lower_simple("Hello WORLD!")

#4
phone_regex <- "\\(\\d{3}\\) \\d{3}-\\d{4}"

str_view(c("(123) 456-7890", "123 456 7890", "(908) 310-8132"), phone_regex)

#15.4.7 exercises 
#1
"\\\\'"
"\\$\\^\\$"
#2
#\\ is a string containing a single backslash. the backslash itself is an escape character, therefore \\ is needed to represent the literal backslash
#\\\ does not match because the third backslash is unescaped. would be interpreted as escaping the closing quote or some other control character.
#to match \\\, it must be escaped with \\\\\\\\
#3
library(stringr)

# get corpus of common words
words <- stringr::words

# 1. start with “y”
str_subset(words, "^y")

# 2. don’t start with “y”
str_subset(words, "^[^y]")

# 3. end with “x”
str_subset(words, "x$")

# 4. exactly three letters long (without using `str_length()`)
str_subset(words, "^...$")

# 5. have seven letters or more
str_subset(words, "^.{7,}$")

# 6. contain a vowel-consonant pair
str_subset(words, "[aeiou][^aeiou]")

# 7. contain at least two vowel-consonant pairs in a row
str_subset(words, "(?:[aeiou][^aeiou]){2,}")

# 8. only consist of repeated vowel-consonant pairs
str_subset(words, "^(?:[aeiou][^aeiou])+$")

#4
# 1. airplane/aeroplane
"airplane|aeroplane"

# 2. aluminum/aluminium
"aluminum|aluminium"

# 3. analog/analogue
"analog|analogue"

# 4. ass/arse
"ass|arse"

# 5. center/centre
"center|centre"

# 6. defense/defence
"defense|defence"

# 7. donut/doughnut
"donut|doughnut"

# 8. gray/grey
"gray|grey"

# 9. modeling/modelling
"modeling|modelling"

# 10. skeptic/sceptic
"skeptic|sceptic"

# 11. summarize/summarise
"summarize|summarise"

#5
words_switched <- str_replace_all(words, "(^.)(.*)(.)$", "\\3\\2\\1")
valid_words <- str_subset(words_switched, words_switched %in% words)
valid_words

#6
#^.*$ -  matches any string including empty ones. the ^ asserts the start of a line, .* matches any character zero or more, and $ asserts the end of the line
#"\\{.+\\}" - matches any string inside curly braces. the \\{ matches an opening brace {,.+ matches one or more characters (any), and \\} matches a closing brace
#\d{4}-\d{2}-\d{2} - matches a date in the format YYYY-MM-DD. \d matches digits, {4} specifies exactly four digits, and the - separates the year, month and day parts
#"\\\\{4}" - matches exactly four backslashes. each backslash needs to be escaped with another backslash, so \\\\ represents one literal backslash, and {4} ensures exactly 4 backslashes
#\..\..\.. - matches any string with three periods, with any characters in between. . matches any character except a newline, and \.. matches a literal period
#(.)\1\1 - matches a sequence of three identical characters. (.) captures one character, and \1 refers to the first captured group. so it matches a repeated character three times
#"(..)\\1" - matches a two-character sequence followed by the same sequence. ( .. ) captures two characters and \\1 refers to the first captured group 

#7 beginner regex crosswords 

#15.6.4 exercises
#1
result1 <- words[str_detect(words, "^x|x$")] #all words that start or end w x
print(result1)

result2 <- words[str_detect(words, "^[aeiouAEIOU].*[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]$")] #find all words that start with a vowel and end with a consonant
print(result2)

contains_all_vowels <- any(str_detect(words, "(?=.*a)(?=.*e)(?=.*i)(?=.*u)"))
print(contains_all_vowels)

#2
# supporting evidence: "ie" not after "c" OR "cei"
supporting <- words[str_detect(words, "(?<!c)ie|cei")]
print(supporting)

violating <- words[str_detect(words, "cie|(?<!c)ei")]
print(violating)

#3
#all color names
color_names <- colors()

#detect modified colors (prefix or suffix modifiers)
modified_colors <- color_names[str_detect(color_names, "^(light|dark|medium|pale|bright|deep)|gray$")]

#remove modifiers to extract base colors
base_colors <- str_remove_all(modified_colors, "^(light|dark|medium|pale|bright|deep)|gray$")
base_colors <- str_trim(base_colors)  # remove extra spaces

print("Modified Colors:")
print(modified_colors)
print("Base Colors:")
print(unique(base_colors))

#4
datasets <- data(package = "datasets")$results[, "Item"]
cleaned_datasets <- str_remove(datasets, "\\s*\\(.*\\)$")
print(cleaned_datasets)

#16.3.1 exercises
#1
data("gss_cat", package = "forcats")
ggplot(gss_cat, aes(x = rincome)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Default Distribution of rincome", x = "Reported Income", y = "Count")

gss_cat %>%
  count(rincome, sort = TRUE) %>%
  ggplot(aes(x = reorder(rincome, n), y = n)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Improved Distribution of rincome", x = "Reported Income", y = "Count")
#default bar chart is harder to read due to overlapping text on x-axis. improved chart reorders categories by frequency and flips coordinates

#2
#most common relig
gss_cat |>
  count(relig, sort = TRUE) |>
  top_n(1)
#most common partyid
gss_cat |>
  count(partyid, sort = TRUE) |>
  top_n(1)

#3
#table of relig vs. denom
table(gss_cat$relig, gss_cat$denom)
#visualization
gss_cat |>
  filter(!is.na(denom)) |>
  count(relig, denom) |>
  ggplot(aes(x = relig, y = denom, size = n)) +
  geom_point(alpha = 0.7, color = "blue") +
  labs(title = "Relationship btwn relig and denom", x = "Religion", y = "Denomination")

#16.4.1 exercises
#1
#mean can be misleading. you can view the distribution using: 
ggplot(gss_cat, aes(x = tvhours)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Distribution of tvhours", x = "TV Hours", y = "Count")
#summary of statistics
summary(gss_cat$tvhours)
#remove outliers and re-compare: 
gss_cat |>
  filter(tvhours < quantile(tvhours, 0.99, na.rm = TRUE)) |>
  summarise(
    mean_tvhours = mean(tvhours, na.rm = TRUE),
    median_tvhours = median(tvhours, na.rm = TRUE)
  )

#2
#look at factors in gss_cat and their levels
factor_levels <- gss_cat |>
  select(where(is.factor)) |>
  summarise(across(everything(), ~ list(levels(.))))

#make the factor levels tidy
factor_levels_tidy <- factor_levels %>%
  pivot_longer(everything(), names_to = "Factor", values_to = "Levels") 

factor_levels_tidy

#arbitrary: race, denom, partyid, relig
#principled: rincome, marital 

#3
#levels determine plotting order. moving not applicable to the front of the levels makes it the first level. 
#when plotted, ggplot treats the first level as the bottom. or the leftmost axis

#16.5.1 exercises
#1
#filter and group partyid categories
party_trends_simple <- gss_cat |>
  mutate(partyid = fct_collapse(partyid,
                                Democrat = c("Strong Democrat", "Not Str Democrat", "Ind,Near Dem"),
                                Republican = c("Not Str Republican", "Strong Republican", "Ind,Near Rep"),
                                Independent = "Independent")) |>
  count(year, partyid) |>
  group_by(year) |>
  mutate(proportion = n / sum(n))
#plot trends
ggplot(party_trends_simple, aes(x = year, y = proportion, color = partyid)) +
  geom_line(size = 1) +
  labs(title = "Trends in Party Identification Over Time",
       x = "Year",
       y = "Proportion",
       color = "Party ID") +
  theme_minimal()

#2
#collapse rincome into fewer categories
gss_cat <- gss_cat |>
  mutate(rincome_collapsed = fct_collapse(rincome,
                                          Low = c("LT $1000", "$1000 to 2999", "$3000 to 3999"),
                                          Middle = c("$4000 to 4999", "$5000 to 6999", "$7000 to 9999"),
                                          High = c("$10000 to 14999", "$15000 or more"),
                                          Unknown = c("Don't know", "No answer", "Refused", "Not applicable")))

#check the results
gss_cat |>
  count(rincome_collapsed)

#3
#if there are fewer than n levels or if one of the levels is "Other" by default, it excludes "Other" from the count leaving 9 groups. 

#18.3.4 exercises 
#1
#identify planes mentioned in flights but not present in planes:
missing_planes <- flights |> 
  distinct(tailnum) |> 
  anti_join(planes, by = "tailnum")
#join w/ flights dataset 
missing_planes_with_carrier <- missing_planes |> 
  left_join(flights, by = "tailnum") |> 
  distinct(tailnum, carrier)
#see relationship
missing_planes_with_carrier |> 
  count(carrier)

#20.2.9 exercises 
#1 
survey <- read_excel(
  "~/downloads/survey.xlsx",  
  col_names = c("survey_id", "n_pets"), 
  skip = 1,                              
  na = c("", "N/A"),                     
  col_types = c("text", "text")          
)

survey <- survey |>
  mutate(
    n_pets = if_else(n_pets == "two", "2", n_pets), 
    n_pets = parse_number(n_pets)                  
  )
survey

#2
library(tidyverse)
library(readxl)
library(dplyr)
library(tidyr)
roster <- read_excel("~/downloads/roster.xlsx")
#fill missing values in 'group' and 'subgroup'
roster <- roster |>
  fill(group, subgroup, .direction = "down")
print(roster)

#3
#a
sales <- read_excel("~/downloads/sales.xlsx", skip = 4, col_names =  FALSE)
colnames(sales) <- c("id", "n")
print(sales)

#b 
sales <- sales |>
  mutate(brand = ifelse(grepl("Brand", id), id, NA)) |>  
  fill(brand) |>  
  filter(!grepl("Brand", id))  
print(sales)
sales <- sales |>
  mutate(
    id = as.numeric(id),
    n = as.numeric(n)
  )
print(sales)

#4
write.xlsx(bake_sale, file = "~/downloads/bake_sale.xlsx")

#5
library(janitor)
students_clean <- students |>
  clean_names()
colnames(students)

#6
#you cannot use read xls bc it only works from an older excel format 

#20.3.6 exercises 
#1
students_excel <- read_excel("~/downloads/students.xlsx")
students_sheet <- read_sheet(students_sheet_id)
students_excel
students_sheet
#i think they are the same

#2
survey_sheet_id <- "1yc5gL-a2OOBr8M7B3IsDNX5uR17vBHOyWZq6xSTG2G8"
survey_data <- read_sheet(survey_sheet_id, sheet = "Sheet1")
survey_data <- survey_data |>
  mutate(
    survey_id = as.character(survey_id),   
    n_pets = as.numeric(str_replace_all(n_pets, c("N/A" = NA, "two" = "2")))  # Replace text and convert
  )
str(survey_data)

#3
roster_sheet_id <- "1LgZ0Bkg9d_NK8uTdP2uHXm07kAlwx8-Ictf8NocebIE"
roster_sheet <- read_sheet(roster_sheet_id)
cleaned_roster_sheet <- roster_sheet |>
  fill(group, subgroup, .direction = "down")
cleaned_roster_sheet

#21.5.10 exercises 
#1
#distinct is translated to SELECT DISTINCT - ensures duplicate rows are removed from the result set
#head is translated to LIMIT - restricts the number of rows returned 

#2
SELECT *  
FROM flights 
WHERE dep_delay < arr_delay
#selects all columns in the flights table where the departure delay (dep_delay) is less than the arrival delay (arr_delay)
flights |>
  filter(dep_delay < arr_delay)

SELECT *, distance / (air_time / 60) AS speed  
FROM flights
#selects all columns from the flights table and calculates a new column called speed, which is computed as distance divided by air_time / 60. this converts air_time from minutes to hours, so the calculation gives the average speed of each flight in miles per hour (mph)
flights |>
  mutate(speed = distance / (air_time / 60))

#22.5.3 exercises 
#1
most_popular_books <- seattle_pq |> 
  filter(MaterialType == "BOOK") |> 
  group_by(CheckoutYear, Title) |> 
  summarise(TotalCheckouts = sum(Checkouts), .groups = "drop") |> 
  slice_max(TotalCheckouts, n = 1, with_ties = FALSE) |> 
  arrange(CheckoutYear) |> 
  collect()

#2
most_books_author <- seattle_pq |> 
  filter(MaterialType == "BOOK") |> 
  group_by(Creator) |> 
  summarise(TotalBooks = n_distinct(Title), .groups = "drop") |> 
  arrange(desc(TotalBooks)) |>  
  slice_head(n = 1) |>  
  collect()

most_books_author

#3
checkouts_summary <- seattle_pq |>
  filter(CheckoutYear >= 2013, CheckoutYear <= 2022, MaterialType %in% c("BOOK", "EBOOK")) |>
  group_by(CheckoutYear, MaterialType) |>
  summarise(TotalCheckouts = sum(Checkouts), .groups = "drop") |>
  collect()

checkouts_summary |>
  ggplot(aes(x = CheckoutYear, y = TotalCheckouts, color = MaterialType)) +
  geom_line() +
  labs(title = "Checkouts of Books vs Ebooks (2013-2022)",
       x = "Year", y = "Total Checkouts", color = "Material Type") +
  theme_minimal()

#23.3.5 exercises 
#1
#you need the names_repair argument. 
#if no names are provided, it will automatically generate column names 
#missing values result in NA where data is absent.
#2
#unnest_longer with named list-columns
#you get an additional column indicating the origin of each list element
#suppress using .drop = TRUE
#3
#if you apply unnest_longer() to both y and z, alignment may break
#unnest one column at a time and join the results 

#23.4.4 exercises
#1
#estimate because data could be missing/repos deleted
#2
owners <- gh_repos |> unnest_wider(owner) |> distinct()
#3
aliases <- got_chars |> unnest_wider(json) |> select(id, aliases) |> unnest_longer(aliases)

#23.5.4 exercises
json_col <- parse_json('
  {
    "x": ["a", "x", "z"],
    "y": [10, null, 3]
  }
')
json_row <- parse_json('
  [
    {"x": "a", "y": 10},
    {"x": "x", "y": null},
    {"x": "z", "y": 3}
  ]
')

df_col <- tibble(json = list(json_col)) 
df_row <- tibble(json = json_row)

df_col |> 
  unnest_wider(json) |> 
  unnest_longer(x) |> 
  unnest_longer(y)

